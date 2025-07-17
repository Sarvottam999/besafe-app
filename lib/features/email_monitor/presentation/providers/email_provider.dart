// features/email_monitor/presentation/providers/email_provider.dart
import 'package:besafe/features/email_monitor/data/models/email_model.dart';
import 'package:besafe/features/email_monitor/domain/repositories/email_repository.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/email_entity.dart';
import '../../domain/usecases/get_device_emails.dart';
import '../../domain/usecases/scan_email_breach.dart';

enum EmailState { initial, loading, loaded, error }

class EmailProvider extends ChangeNotifier {
  final EmailRepository emailRepository;
  final ScanEmailBreach scanEmailBreach;

  EmailProvider({
    required this.emailRepository,
    required this.scanEmailBreach,
  });

  EmailState _state = EmailState.initial;
  String _selectedEmail = '';
  bool _isMonitored = false;
  EmailEntity? _scanResult;
  String _errorMessage = '';

  // Getters
  EmailState get state => _state;
  String get selectedEmail => _selectedEmail;
  bool get isMonitored => _isMonitored;
  EmailEntity? get scanResult => _scanResult;
  String get errorMessage => _errorMessage;

  void setSelectedEmail(String email) {
    _selectedEmail = email;
    notifyListeners();
  }

  void toggleMonitoring(bool value) async {

    try {
        _isMonitored = value;
    if (_scanResult == null || _scanResult?.email == null) return;
  await emailRepository.toggleMonitoring(_scanResult?.email ?? "" ,value).then(
      (result) {
        result.fold(
          (failure) {
            print("##Failed to toggle monitoring: ${failure.toString()}");
            _isMonitored = !_isMonitored; // Revert the change on failure
          },
          (_) {
            _scanResult = _scanResult?.copyWith(isMonitored: _isMonitored);
          },
        );
      },
  );

    print("## _isMonitored ==> $_isMonitored");

    notifyListeners();
      
    } catch (e) {
      print("## error => $e");
      
    }
  
  }

//   Future<void> monitorEmail() async {
//   if (_scanResult == null) return;

//   final result = await emailRepository.saveMonitoredEmail(scanResult!);
//   result.fold(
//     (failure) => print("Failed to monitor: ${failure.toString()}"),
//     (_) {
//       _scanResult = scanResult!.copyWith(isMonitored: true);
//       notifyListeners();
//     },
//   );
// }


  // Future<void> fetchDeviceEmails() async {
  //   _state = EmailState.loading;
  //   notifyListeners();

  //   final result = await getDeviceEmails();
    
  //   result.fold(
  //     (failure) {
  //       _state = EmailState.error;
  //       _errorMessage = failure.toString();
  //     },
  //     (emails) {
  //       _state = EmailState.loaded;
  //       _deviceEmails = emails;
  //       _errorMessage = '';
  //     },
  //   );
    
  //   notifyListeners();
  // } 

  Future<void> scanEmail(String email) async {
    _state = EmailState.loading;
    notifyListeners();

    final result = await scanEmailBreach(email);
    
    result.fold(
      (failure) {
        _state = EmailState.error;
        _errorMessage = failure.toString();
        _scanResult = null;
      },
      (emailEntity) {
        _state = EmailState.loaded;
        _scanResult = emailEntity.copyWith(isMonitored: _isMonitored);
        _errorMessage = '';
      },
    );
    
    notifyListeners();
  }

  //  getMonitoredEmails
  Future<List<EmailModel>> getMonitoredEmails() async {
    try {
      final result = await emailRepository.getMonitoredEmails();
      return result.fold(
        (failure) {
          print("Failed to get monitored emails: ${failure.toString()}");
          return [];
        },
        (emails) {
          return emails.map((e) => EmailModel.fromEntity(e)).toList();
        },
      );
    } catch (e) {
      print("Error getting monitored emails: $e");
      return [];
    }
  }

  void reset() {
    _state = EmailState.initial;
    _selectedEmail = '';
    _isMonitored = false;
    _scanResult = null;
    _errorMessage = '';
    notifyListeners();
  }
}