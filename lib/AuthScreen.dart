import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dashboard.dart'; // Import DashboardScreen
import 'SignUpScreen.dart'; // Import SignUpScreen for navigation

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _planeAnimation;
  late Animation<double> _cloudAnimation1;
  late Animation<double> _cloudAnimation2;
  late Animation<double> _cloudAnimation3;
  late Animation<double> _umbrellaAnimation;
  late Animation<double> _pyramidAnimation;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    // Animation controller for all animations
    _controller = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    )..repeat();

    // Airplane animation (flying across the screen)
    _planeAnimation = Tween<double>(begin: -100, end: 500).animate(
        CurvedAnimation(parent: _controller, curve: Curves.linear));

    // Cloud animations (floating slowly)
    _cloudAnimation1 = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _cloudAnimation2 = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _cloudAnimation3 = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Umbrella animation (subtle swaying)
    _umbrellaAnimation = Tween<double>(begin: -0.1, end: 0.1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Pyramid animation (static, in the background)
    _pyramidAnimation = Tween<double>(begin: 0, end: 0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void navigateToDashboard() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => DashboardScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 500), // Duration of the transition
      ),
    );
  }

  void navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
  }

  Future<void> _signIn() async {
    try {
      // Input validation
      final emailPattern = RegExp(r'^[^@]+@[^@]+\.[^@]+');
      if (!emailPattern.hasMatch(_emailController.text.trim())) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter a valid email'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        return;
      }
      if (_passwordController.text.trim().length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password must be at least 6 characters'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        return;
      }

      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      navigateToDashboard();
    } on FirebaseAuthException {
      // Handle specific Firebase Authentication errors
      String errorMessage = 'Sign-in failed: Email or password is incorrect';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      // Handle other errors (e.g., network issues)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign-in failed: ${e.toString()}'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
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
              Color(0xFF007E95),
              Color(0xFF004D65),
              Color(0xFF003653),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            _buildBackgroundDecorations(),
            Positioned(
              top: 80,
              left: MediaQuery.of(context).size.width / 2 - 60,
              child: Text(
                "Tourify",
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Center(child: _buildAuthCard()),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundDecorations() {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _planeAnimation,
          builder: (context, child) {
            return Positioned(
              top: 60,
              left: _planeAnimation.value,
              child: Icon(
                Icons.flight,
                size: 80,
                color: Colors.white.withOpacity(0.7),
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: _cloudAnimation1,
          builder: (context, child) {
            return Positioned(
              top: 100,
              left: 50 + (_cloudAnimation1.value * 50),
              child: Icon(
                Icons.cloud,
                size: 60,
                color: Colors.white.withOpacity(0.6),
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: _cloudAnimation2,
          builder: (context, child) {
            return Positioned(
              top: 150,
              left: 200 + (_cloudAnimation2.value * 50),
              child: Icon(
                Icons.cloud,
                size: 70,
                color: Colors.white.withOpacity(0.5),
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: _cloudAnimation3,
          builder: (context, child) {
            return Positioned(
              top: 50,
              left: 300 + (_cloudAnimation3.value * 50),
              child: Icon(
                Icons.cloud,
                size: 50,
                color: Colors.white.withOpacity(0.4),
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: _umbrellaAnimation,
          builder: (context, child) {
            return Positioned(
              bottom: 100,
              right: 40,
              child: Transform.rotate(
                angle: _umbrellaAnimation.value,
                child: Icon(
                  Icons.beach_access,
                  size: 100,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: _pyramidAnimation,
          builder: (context, child) {
            return Positioned(
              bottom: 50,
              left: 20,
              child: Icon(
                Icons.landscape,
                size: 80,
                color: Colors.white.withOpacity(0.6),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAuthCard() {
    return Container(
      width: 350,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 6, spreadRadius: 2),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Welcome Back!",
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.black54),
          ),
          SizedBox(height: 20),
          _buildAuthForm(),
          SizedBox(height: 10),
          GestureDetector(
            onTap: navigateToSignUp,
            child: Text(
              "Don't have an account? Sign up",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Color(0xFF003653),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthForm() {
    return Column(
      children: [
        _buildInputField(Icons.email, "Email"),
        _buildInputField(Icons.lock, "Password", isPassword: true),
        SizedBox(height: 10),
        GestureDetector(
          onTap: _signIn,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Color(0xFF003653),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: Text(
                "Login",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(
      IconData icon,
      String hint, {
        bool isPassword = false,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: hint == "Email" ? _emailController : _passwordController,
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Color(0xFF003653)),
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}