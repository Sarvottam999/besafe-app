import 'package:besafe/services/ApiClient.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionService extends ChangeNotifier {
  final ApiClient _api; 
    SubscriptionService(this._api) {
    _loadSubscriptionStatus();
        _loadOnboardingStatus();  
          loadSearchAttempts(); // Add this line
          initStore();



  }

  static const String _boxName = 'app_preferences';
  static const String _subscriptionKey = 'isProUser';
  static const String _onboardingKey = 'hasCompletedOnboarding'; // Add this

    final InAppPurchase _iap = InAppPurchase.instance;


// ----------------------
  // String _userName = 'John Doe';
  // String _userEmail = 'john.doe@example.com';
  // bool _isProUser = true;
  bool _biometricEnabled = false;
  bool _autoLockEnabled = true;
  bool _pushNotificationsEnabled = true;
  bool _emailAlertsEnabled = false;
  bool _realTimeMonitoringEnabled = false;
  int _searchAttempts = 0; // Add this

  // Getters
  // String get userName => _userName;
  // String get userEmail => _userEmail;
  // bool get isProUser => _isProUser;
  bool get biometricEnabled => _biometricEnabled;
  bool get autoLockEnabled => _autoLockEnabled;
  bool get pushNotificationsEnabled => _pushNotificationsEnabled;
  bool get emailAlertsEnabled => _emailAlertsEnabled;
  bool get realTimeMonitoringEnabled => _realTimeMonitoringEnabled;

    bool isAvailable = false;
  List<ProductDetails> products = [];
  List<PurchaseDetails> purchases = [];


  // Toggle methods
  void toggleBiometric(bool value) {
    _biometricEnabled = value;
    notifyListeners();
  }

  void toggleAutoLock(bool value) {
    _autoLockEnabled = value;
    notifyListeners();
  }

  void togglePushNotifications(bool value) {
    _pushNotificationsEnabled = value;
    notifyListeners();
  }

  void toggleEmailAlerts(bool value) {
    _emailAlertsEnabled = value;
    notifyListeners();
  }

  void toggleRealTimeMonitoring(bool value) {
    _realTimeMonitoringEnabled = value;
    notifyListeners();
  }

  // void updateUserInfo(String name, String email) {
  //   _userName = name;
  //   _userEmail = email;
  //   notifyListeners();
  // }

  void upgradeToProUser() {
    _isProUser = true;
    notifyListeners();
  }
 

// Add method to sync with auth provider
// void syncWithAuthUser(String username, String email) {
//   _userName = username;
//   _userEmail = email;
//   notifyListeners();
// }

  // -----------------------


  bool _isProUser = false;
      bool _hasCompletedOnboarding = false; // Add this

  bool get isProUser => _isProUser;
    bool get hasCompletedOnboarding => _hasCompletedOnboarding; // Add this




  Future<void> _loadSubscriptionStatus() async {
    final box = await Hive.openBox(_boxName);
    _isProUser = box.get(_subscriptionKey, defaultValue: false);
    notifyListeners();
  }
    Future<void> _loadOnboardingStatus() async {
    final box = await Hive.openBox(_boxName);
    _hasCompletedOnboarding = box.get(_onboardingKey, defaultValue: false);
    notifyListeners();
  }

    Future<void> completeOnboarding() async {
    final box = await Hive.openBox(_boxName);
    _hasCompletedOnboarding = true;
    await box.put(_onboardingKey, true);
    notifyListeners();
  }



  Future<void> subscribe({required bool yearly}) async {
    final box = await Hive.openBox(_boxName);
    _isProUser = true;
    await box.put(_subscriptionKey, true);
    notifyListeners();
  }

  Future<void> unsubscribe() async {
    final box = await Hive.openBox(_boxName);
    _isProUser = false;
    await box.put(_subscriptionKey, false);
    notifyListeners();
  }

  //-------------  search attempts ---------------
  // This section tracks the number of search attempts and these is stored in the Hive box.
  int get searchAttempts => _searchAttempts;

  // search  attempts Hive box opts
  Future<void> saveSearchAttempts() async {
    final box = await Hive.openBox(_boxName);
    await box.put('searchAttempts', _searchAttempts);
  }
  Future<void> loadSearchAttempts() async {
    final box = await Hive.openBox(_boxName);
    _searchAttempts = box.get('searchAttempts', defaultValue: 0);
    notifyListeners();
  }
    void incrementSearchAttempts() {
    _searchAttempts++;
    notifyListeners();
    saveSearchAttempts(); // Save after incrementing

    
  }
  void resetSearchAttempts() {
    _searchAttempts = 0;
    saveSearchAttempts(); // Save after resetting

    notifyListeners();
  }
  void decrementSearchAttempts() {
    if (_searchAttempts > 0) {
      _searchAttempts--;
      notifyListeners();
      saveSearchAttempts(); // Save after decrementing
    }
  }

  // search attampt status based on the attem count eg: isGuestLimitExausted will be if the attam count is greater than 1 , isNotProLimitExausted will be if the attam count is greater than 5
  bool get isGuestLimitExhausted => _searchAttempts >= 1; // Guest users can search once
  bool get isNotProLimitExhausted => _searchAttempts >= 5; // Non-pro users can search up to 5 times



// ----  i app purchase methods ----
Future<void> initStore() async {
    isAvailable = await _iap.isAvailable();

    if (!isAvailable) {
      debugPrint("❌ In-App Purchase not available");
      return;
    }

    final ProductDetailsResponse response =
        await _iap.queryProductDetails({'com.besafe.pro'}.toSet());

    if (response.notFoundIDs.isNotEmpty) {
      debugPrint("⚠️ Product not found: ${response.notFoundIDs}");
    }

    products = response.productDetails;
    _iap.purchaseStream.listen(_onPurchaseUpdate);
  }
    void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    purchases.addAll(purchaseDetailsList);
    for (final purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.purchased) {
        _verifyPurchase(purchase);
      }
      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
      }
    }
    notifyListeners();
  }

  void buy(ProductDetails product) {
    final PurchaseParam param = PurchaseParam(productDetails: product);
    _iap.buyNonConsumable(purchaseParam: param);
  }

  // Future<void> _verifyPurchase(PurchaseDetails purchase) async {
  //   // 🔐 Here we call Django backend
  //   final token = purchase.verificationData.serverVerificationData;
  //   final productId = purchase.productID;

  //   // Use your Dio instance to POST this to Django
  //   // /api/purchase/verify/
  // }

  Future<void> _verifyPurchase(PurchaseDetails purchase) async {
  try {
    final response = await _api.post(
      'https://your-backend.com/api/purchase/verify/',
      data: {
        'product_id': purchase.productID,
        'purchase_token': purchase.verificationData.serverVerificationData,
        'platform': 'android',
      },
    );


    debugPrint("✅ Purchase verified: ${response.data}");
  } catch (e) {
    debugPrint("❌ Verification failed: $e");
  }
}







  void resetAllSettings() async {
    _biometricEnabled = false;
    _autoLockEnabled = true;
    _pushNotificationsEnabled = true;
    _emailAlertsEnabled = false;
    _realTimeMonitoringEnabled = false;
    _isProUser = false;
    _hasCompletedOnboarding = false; // Reset onboarding status
    _searchAttempts = 0; // Reset search attempts

    notifyListeners();

    // Save all settings to Hive
  final box = await Hive.openBox(_boxName); // Add await and openBox
  await box.put(_subscriptionKey, _isProUser); // Add await
  await box.put(_onboardingKey, _hasCompletedOnboarding); // Add await
  await box.put('searchAttempts', _searchAttempts); // Add await
    box.put('searchAttempts', _searchAttempts);
  }




}
