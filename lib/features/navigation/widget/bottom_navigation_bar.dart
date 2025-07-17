// features/navigation/presentation/widgets/bottom_navigation_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';

class BottomNavigationItem {
  final String label;
  final String icon;
  final String activeIcon;
  final Widget Function() pageBuilder;

  BottomNavigationItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.pageBuilder,
  });
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavigationItem> items;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A0A0F).withOpacity(0.95),
            Color(0xFF1A1A2E).withOpacity(0.98),
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 0.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: Color(0xFF74B9FF),
          unselectedItemColor: Colors.white.withOpacity(0.6),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = index == currentIndex;
            
            return BottomNavigationBarItem(
              icon: _buildIcon(item.icon, isSelected: isSelected),
              activeIcon: _buildIcon(item.activeIcon, isSelected: isSelected),
              label: item.label,
            );
          }).toList(),
        ),
      ),
    );
  }

 Widget _buildIcon(String iconPath, {required bool isSelected}) {
  return isSelected
        ? ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [Color(0xFF6C5CE7), Color(0xFF74B9FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
            blendMode: BlendMode.srcIn,
            child: SvgPicture.string(
              iconPath,
              width: 22,
              height: 22,
              color: Colors.white, // base color for blending
            ),
          )
        : SvgPicture.string(
            iconPath,
            width: 18,
            height: 18,
            color: Colors.white.withOpacity(0.6),
          );
 }}

// Navigation Controller
class NavigationController extends ChangeNotifier {
  int _currentIndex = 0;
  final List<BottomNavigationItem> _items = [];

  int get currentIndex => _currentIndex;
  List<BottomNavigationItem> get items => _items;

  void setItems(List<BottomNavigationItem> newItems) {
    _items.clear();
    _items.addAll(newItems);
    notifyListeners();
  }

  void changeIndex(int index) {
    if (index >= 0 && index < _items.length) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  Widget getCurrentPage() {
    if (_items.isEmpty || _currentIndex >= _items.length) {
      return Container(); // Return empty container if no items or invalid index
    }
    return _items[_currentIndex].pageBuilder();
  }
}

// Main Navigation Wrapper
class NavigationWrapper extends StatefulWidget {
  final List<BottomNavigationItem> navigationItems;
  final Widget? defaultPage;

  const NavigationWrapper({
    Key? key,
    required this.navigationItems,
    this.defaultPage,
  }) : super(key: key);

  @override
  State<NavigationWrapper> createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<NavigationWrapper> {
  late NavigationController _navigationController;

  @override
  void initState() {
    super.initState();
    _navigationController = NavigationController();
    _navigationController.setItems(widget.navigationItems);
  }

  @override
  void dispose() {
    _navigationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _navigationController,
      child: Consumer<NavigationController>(
        builder: (context, controller, child) {
          return Scaffold(
            backgroundColor: Color(0xFF0A0A0F),
            body: widget.defaultPage ?? controller.getCurrentPage(),
            bottomNavigationBar: CustomBottomNavigationBar(
              currentIndex: controller.currentIndex,
              onTap: controller.changeIndex,
              items: controller.items,
            ),
          );
        },
      ),
    );
  }
}

// Extension for easy integration
extension NavigationExtension on BuildContext {
  NavigationController? get navigationController {
    try {
      return Provider.of<NavigationController>(this, listen: false);
    } catch (e) {
      return null;
    }
  }
}