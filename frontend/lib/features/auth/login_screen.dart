import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../tiffin_tales_app/lib/features/user/user_preferences_screen.dart';
import '../../tiffin_tales_app/lib/features/meals/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  String _role = 'Customer';
  bool _isLogin = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() { _loading = true; _error = null; });
    try {
      UserCredential? userCred;
      if (_isLogin) {
        userCred = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        userCred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        await FirebaseFirestore.instance.collection('users').doc(userCred.user!.uid).set({
          'name': _nameController.text.trim(),
          'city': _cityController.text.trim(),
          'role': _role,
          'email': _emailController.text.trim(),
        });
      }
      final doc = await FirebaseFirestore.instance.collection('users').doc(userCred!.user!.uid).get();
      final data = doc.data();
      if (data == null || !data.containsKey('vegType') || !data.containsKey('cuisine')) {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const UserPreferencesScreen()),
        );
      } else {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() { _error = e.message; });
    } catch (e) {
      setState(() { _error = 'Something went wrong.'; });
    } finally {
      setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8F4E8),
              Color(0xFFF1E8D0),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Back button for signup
                      if (!_isLogin)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: _loading ? null : () => setState(() => _isLogin = true),
                            icon: Icon(Icons.arrow_back, color: Color(0xFF884513)),
                          ),
                        ),
                      
                      // Logo and Branding
                      Container(
                        padding: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFF8F4E8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                          border: Border.all(
                            color: Color(0xFF88860B),
                            width: 2,
                          ),
                        ),
                        child: Image.asset(
                          'lib/assets/HerTale.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // App Name
                      Text(
                        'HerTale',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004D00),
                          fontFamily: 'PlayfairDisplay',
                          letterSpacing: 1.5,
                        ),
                      ),
                      
                      // Tagline
                      Text(
                        'EVERY MEAL TELLS HER STORY',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF884513),
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Decorative Divider
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Color(0xFF88860B),
                              thickness: 1,
                              endIndent: 10,
                            ),
                          ),
                          Icon(Icons.restaurant_menu, color: Color(0xFF88860B), size: 20),
                          Expanded(
                            child: Divider(
                              color: Color(0xFF88860B),
                              thickness: 1,
                              indent: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      
                      // Form Fields
                      if (!_isLogin) ...[
                        _buildFormField(_nameController, 'Name', Icons.person),
                        const SizedBox(height: 16),
                        _buildFormField(_cityController, 'City', Icons.location_city),
                        const SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.people, color: Color(0xFF88860B)),
                              SizedBox(width: 16),
                              Text('Role:', style: TextStyle(color: Color(0xFF004D00), fontWeight: FontWeight.w600)),
                              SizedBox(width: 16),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _role,
                                  items: const [
                                    DropdownMenuItem(value: 'Customer', child: Text('Customer')),
                                    DropdownMenuItem(value: 'Homemaker', child: Text('Homemaker')),
                                  ],
                                  onChanged: (val) => setState(() => _role = val ?? 'Customer'),
                                  decoration: InputDecoration(border: InputBorder.none),
                                  dropdownColor: Color(0xFFF8F4E8),
                                  style: TextStyle(color: Color(0xFF004D00)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      
                      _buildFormField(_emailController, 'Email', Icons.email),
                      const SizedBox(height: 16),
                      _buildFormField(_passwordController, 'Password', Icons.lock, isPassword: true),
                      
                      // Error Message
                      if (_error != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, color: Colors.red),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(_error!, 
                                  style: TextStyle(color: Colors.red[800]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      
                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF004D00),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 4,
                            shadowColor: Colors.black26,
                          ),
                          onPressed: _loading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    _submit();
                                  }
                                },
                          child: _loading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(_isLogin ? Icons.login : Icons.person_add, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(_isLogin ? 'LOG IN' : 'SIGN UP',
                                        style: TextStyle(
                                          fontSize: 18, 
                                          color: Colors.white, 
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1,
                                        )),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Toggle between Login/Signup
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isLogin ? "Don't have an account?" : 'Already have an account?',
                            style: TextStyle(
                              color: Color(0xFF884513),
                            ),
                          ),
                          SizedBox(width: 8),
                          GestureDetector(
                            onTap: _loading
                                ? null
                                : () => setState(() => _isLogin = !_isLogin),
                            child: Text(
                              _isLogin ? 'Sign up' : 'Log in',
                              style: TextStyle(
                                color: Color(0xFF004D00),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      // Forgot Password
                      if (_isLogin) ...[
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(
                              color: Color(0xFF88860B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                      
                      // Decorative Bottom
                      
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField(TextEditingController controller, String hint, IconData icon, {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        prefixIcon: Icon(icon, color: Color(0xFF88860B)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        suffixIcon: isPassword 
            ? Icon(Icons.visibility_off, color: Color(0xFF88860B))
            : null,
      ),
      validator: (v) {
        if (v == null || v.isEmpty) {
          return 'Please enter $hint';
        }
        if (hint == 'Password' && v.length < 6) {
          return 'Password must be at least 6 characters';
        }
        if (hint == 'Email' && !v.contains('@')) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }
}