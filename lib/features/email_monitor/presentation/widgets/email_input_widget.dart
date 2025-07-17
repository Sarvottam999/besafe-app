// features/email_monitor/presentation/widgets/email_input_widget.dart
import 'package:besafe/features/email_monitor/presentation/pages/scan_result_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/validators.dart';
import '../providers/email_provider.dart';

class EmailInputWidget extends StatefulWidget {
  @override
  State<EmailInputWidget> createState() => _EmailInputWidgetState();
}

class _EmailInputWidgetState extends State<EmailInputWidget>
    with TickerProviderStateMixin {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String? _errorText;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
      if (_isFocused) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _validateAndSetEmail() {
    final email = _controller.text.trim();
    final error = Validators.validateEmail(email);

    setState(() {
      _errorText = error;
    });

    if (error == null) {
      context.read<EmailProvider>().setSelectedEmail(email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6C5CE7), Color(0xFF74B9FF)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.edit_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
            SizedBox(width: 12),
            Text(
              'Enter Your Email Address',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),

        // Input Field
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF1A1A2E).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isFocused
                        ? Color(0xFF6C5CE7)
                        : (_errorText != null
                            ? Colors.red.withOpacity(0.6)
                            : Colors.white.withOpacity(0.1)),
                    width: _isFocused ? 2 : 1,
                  ),
                  boxShadow: _isFocused
                      ? [
                          BoxShadow(
                            color: Color(0xFF6C5CE7).withOpacity(0.3),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ]
                      : [],
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    final provider =
                        Provider.of<EmailProvider>(context, listen: false);

                    final error =
                        Validators.validateEmail(_controller.text.trim());
                    if (error == null) {
                      provider.scanEmail(provider.selectedEmail);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ScanResultPage()));
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'example@email.com',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 16,
                    ),
                    prefixIcon: Container(
                      padding: EdgeInsets.all(12),
                      child: Icon(
                        Icons.email_outlined,
                        color: _isFocused
                            ? Color(0xFF6C5CE7)
                            : Colors.white.withOpacity(0.6),
                        size: 20,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  ),
                  onChanged: (_) {
                    // if (_errorText != null) {
                    _validateAndSetEmail();
                    // }
                  },
                  // onSubmitted: (_) => _validateAndSetEmail(),
                ),
              ),
            );
          },
        ),

        // Error Message
        if (_errorText != null) ...[
          SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red.withOpacity(0.8),
                size: 16,
              ),
              SizedBox(width: 8),
              Text(
                _errorText!,
                style: TextStyle(
                  color: Colors.red.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],

        SizedBox(height: 24),

        // Info Text
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Color(0xFF74B9FF),
                size: 20,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Enter any email address you want to monitor for security breaches',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
