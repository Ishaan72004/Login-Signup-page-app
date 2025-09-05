import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth Screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: const AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isLogin = true;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Password requirements
  bool _hasMinLength = false;
  bool _hasUpperCase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _toggleForm() {
    setState(() {
      _isLogin = !_isLogin;
      _controller.reset();
      _controller.forward();
    });
  }

  void _checkPasswordRequirements(String value) {
    setState(() {
      _hasMinLength = value.length >= 8;
      _hasUpperCase = value.contains(RegExp(r'[A-Z]'));
      _hasNumber = value.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with authentication
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isLogin ? 'Login successful!' : 'Account created successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated background with gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue.shade900.withOpacity(0.8),
                  Colors.purple.shade800.withOpacity(0.8),
                  Colors.deepPurple.shade900.withOpacity(0.9),
                ],
              ),
            ),
            child: Opacity(
              opacity: 0.15,
              child: Image.network(
                'https://i.pinimg.com/originals/e7/16/55/e7165502b2a1cf61fa81b20e02bad088.gif',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
          ),

          // Content
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return SingleChildScrollView(
                // Added SingleChildScrollView to handle overflow
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 50), // Reduced top spacing

                      // Logo and title with animation
                      Transform.translate(
                        offset: Offset(0, 50 - (_animation.value * 50)),
                        child: Opacity(
                          opacity: _animation.value,
                          child: Column(
                            children: [
                              Container(
                                width: 80, // Smaller logo
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                                ),
                                child: Icon(
                                  Icons.person,
                                  size: 40, // Smaller icon
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16), // Reduced spacing
                              Text(
                                _isLogin ? 'Welcome Back' : 'Create Account',
                                style: const TextStyle(
                                  fontSize: 24, // Smaller font
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(height: 6), // Reduced spacing
                              Text(
                                _isLogin
                                    ? 'Sign in to continue your journey'
                                    : 'Join us to get started',
                                style: TextStyle(
                                  fontSize: 14, // Smaller font
                                  color: Colors.white.withOpacity(0.8),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30), // Reduced spacing

                      // Form with animation
                      Transform.translate(
                        offset: Offset(0, 50 - (_animation.value * 50)),
                        child: Opacity(
                          opacity: _animation.value,
                          child: Container(
                            padding: const EdgeInsets.all(20), // Reduced padding
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (!_isLogin)
                                    _buildTextField(
                                      controller: _nameController,
                                      hintText: 'Full Name',
                                      icon: Icons.person_outline,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your name';
                                        }
                                        if (value.length < 3) {
                                          return 'Name must be at least 3 characters';
                                        }
                                        return null;
                                      },
                                    ),
                                  if (!_isLogin) const SizedBox(height: 12),

                                  _buildTextField(
                                    controller: _emailController,
                                    hintText: 'Email Address',
                                    icon: Icons.email_outlined,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                        return 'Please enter a valid email address';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 12),

                                  _buildTextField(
                                    controller: _passwordController,
                                    hintText: 'Password',
                                    icon: Icons.lock_outline,
                                    isPassword: true,
                                    onChanged: _checkPasswordRequirements,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      if (value.length < 8) {
                                        return 'Password must be at least 8 characters';
                                      }
                                      if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                        return 'Password must contain at least one uppercase letter';
                                      }
                                      if (!RegExp(r'[0-9]').hasMatch(value)) {
                                        return 'Password must contain at least one number';
                                      }
                                      if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                                        return 'Password must contain at least one special character';
                                      }
                                      return null;
                                    },
                                  ),

                                  // Password requirements (only visible during signup)
                                  if (!_isLogin) ...[
                                    const SizedBox(height: 12),
                                    _buildPasswordRequirements(),
                                  ],

                                  const SizedBox(height: 12),
                                  if (!_isLogin)
                                    _buildTextField(
                                      controller: _confirmPasswordController,
                                      hintText: 'Confirm Password',
                                      icon: Icons.lock_reset,
                                      isPassword: true,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please confirm your password';
                                        }
                                        if (value != _passwordController.text) {
                                          return 'Passwords do not match';
                                        }
                                        return null;
                                      },
                                    ),
                                  if (!_isLogin) const SizedBox(height: 12),

                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50, // Smaller button
                                    child: ElevatedButton(
                                      onPressed: _submitForm,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.blue.shade800,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        elevation: 4,
                                        shadowColor: Colors.white.withOpacity(0.5),
                                      ),
                                      child: Text(
                                        _isLogin ? 'Login' : 'Sign Up',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: Colors.white.withOpacity(0.3),
                                          thickness: 1,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        child: Text(
                                          'or continue with',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.7),
                                            fontSize: 12, // Smaller font
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: Colors.white.withOpacity(0.3),
                                          thickness: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildSocialButton(
                                        icon: Icons.g_mobiledata,
                                        color: Colors.white,
                                        bgColor: Colors.red.shade400,
                                        size: 50, // Smaller buttons
                                      ),
                                      _buildSocialButton(
                                        icon: Icons.facebook,
                                        color: Colors.white,
                                        bgColor: Colors.blue.shade800,
                                        size: 50,
                                      ),
                                      _buildSocialButton(
                                        icon: Icons.apple,
                                        color: Colors.white,
                                        bgColor: Colors.black,
                                        size: 50,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  GestureDetector(
                                    onTap: _toggleForm,
                                    child: RichText(
                                      text: TextSpan(
                                        text: _isLogin
                                            ? "Don't have an account? "
                                            : "Already have an account? ",
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 14,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: _isLogin ? 'Sign Up' : 'Login',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20), // Added bottom padding
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30), // Added bottom spacing
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    String? Function(String?)? validator,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.7), size: 20),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.4), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        suffixIcon: isPassword
            ? Icon(
          Icons.visibility_off,
          color: Colors.white.withOpacity(0.5),
          size: 20,
        )
            : null,
      ),
    );
  }

  Widget _buildPasswordRequirements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password must contain:',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        _buildRequirementRow('At least 8 characters', _hasMinLength),
        _buildRequirementRow('One uppercase letter', _hasUpperCase),
        _buildRequirementRow('One number', _hasNumber),
        _buildRequirementRow('One special character', _hasSpecialChar),
      ],
    );
  }

  Widget _buildRequirementRow(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isMet ? Colors.green.shade300 : Colors.white.withOpacity(0.5),
            size: 14,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: isMet ? Colors.green.shade300 : Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({required IconData icon, required Color color, Color? bgColor, double size = 60}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor ?? Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: size * 0.45),
    );
  }
}