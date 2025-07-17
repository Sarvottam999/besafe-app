// lib/features/auth/presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: "sar");
  final _passwordController = TextEditingController(text: "sar");
  final _emailController = TextEditingController();
  bool _isSignup = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSignup ? 'Sign Up' : 'Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter username';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              if (_isSignup)
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    return null;
                  },
                ),
              if (_isSignup) SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return Column(
                    children: [
                      if (authProvider.error != null)
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            "Something went wrong: ${authProvider.error}",
                            style: TextStyle(color: Colors.white),
                            maxLines: 2,
                          ),
                        ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: authProvider.isLoading ? null : _submitForm,
                        child: authProvider.isLoading
                            ? CircularProgressIndicator()
                            : Text(_isSignup ? 'Sign Up' : 'Login'),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isSignup = !_isSignup;
                  });
                },
                child: Text(_isSignup
                    ? 'Already have an account? Login'
                    : 'Don\'t have an account? Sign Up'),
              ),
              //  TextButton(
              //   onPressed: () {
              //                      Navigator.pushReplacementNamed(context, '/home');

              //   },
              //   // enter as temperory  guest
              //   child: Text(
              //     'Enter as Guest',
              //     style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),  
              //   )
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      bool success;
      if (_isSignup) {
        success = await authProvider.signup(
          _usernameController.text,
          _passwordController.text,
          _emailController.text,
        );
      } else {
        success = await authProvider.login(
          _usernameController.text,
          _passwordController.text,
        );
      }
      
      if (success) {
Navigator.of(context).pop(); // This will return to the previous page
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed. Please try again.')),
        );
         
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}