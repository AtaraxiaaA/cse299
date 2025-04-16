import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dashboard.dart'; // Import DashboardScreen
import 'AuthScreen.dart'; // Import AuthScreen for navigation

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  bool isLogin = false; // Start in sign-up mode by default
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  File? _profileImage; // To store the selected image file
  final ImagePicker _picker = ImagePicker(); // Image picker instance

  late AnimationController _controller;
  late Animation<double> _planeAnimation;
  late Animation<double> _cloudAnimation1;
  late Animation<double> _cloudAnimation2;
  late Animation<double> _cloudAnimation3;
  late Animation<double> _umbrellaAnimation;
  late Animation<double> _pyramidAnimation;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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

    print("SignUpScreen initialized with isLogin: $isLogin");
  }

  @override
  void dispose() {
    _controller.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: ${e.toString()}'),
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

  void navigateToDashboard() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => DashboardScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 500),
      ),
    );
  }

  void navigateToLogin() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => AuthScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 500),
      ),
    );
  }

  Future<void> _signUp() async {
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
      if (_usernameController.text.trim().length < 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Username must be at least 3 characters'),
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
      final phonePattern = RegExp(r'^\+?[1-9]\d{1,14}$');
      if (!phonePattern.hasMatch(_phoneController.text.trim())) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter a valid phone number (e.g., +1234567890)'),
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

      // Check if username is unique
      final usernameQuery = await _firestore
          .collection('usernames')
          .doc(_usernameController.text.trim())
          .get();
      if (usernameQuery.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Username already exists'),
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

      // Create user with Firebase Authentication
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Upload profile photo to Firebase Storage if selected
      String? profilePhotoUrl;
      if (_profileImage != null) {
        final storageRef = _storage
            .ref()
            .child('profile_photos/${userCredential.user!.uid}.jpg');
        await storageRef.putFile(_profileImage!);
        profilePhotoUrl = await storageRef.getDownloadURL();
      }

      // Store username in the usernames collection to enforce uniqueness
      await _firestore
          .collection('usernames')
          .doc(_usernameController.text.trim())
          .set({
        'uid': userCredential.user!.uid,
      });

      // Store additional user data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'username': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'profilePhotoUrl': profilePhotoUrl, // Store the photo URL (or null if no photo)
        'createdAt': FieldValue.serverTimestamp(),
      });

      navigateToDashboard();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign-up failed: ${e.toString()}'),
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
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Sign-in failed: ${e.message}';
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        errorMessage = 'Email or password is incorrect';
      }
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
            isLogin ? "Welcome Back!" : "Create an Account",
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.black54),
          ),
          SizedBox(height: 20),
          if (!isLogin) // Show profile photo picker only in sign-up mode
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFF264653),
                backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null
                    ? Icon(
                  Icons.camera_alt,
                  size: 40,
                  color: Colors.white,
                )
                    : null,
              ),
            ),
          if (!isLogin) SizedBox(height: 10),
          if (!isLogin)
            Text(
              "Tap to add a profile photo (optional)",
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
            ),
          SizedBox(height: 20),
          _buildAuthForm(),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              setState(() {
                isLogin = !isLogin;
                print("Toggled isLogin to: $isLogin"); // Debug print
              });
            },
            child: Text(
              isLogin
                  ? "Don't have an account? Sign up"
                  : "Already have an account? Login",
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
        if (!isLogin) // Show username field only in sign-up mode
          _buildInputField(Icons.person, "Username"),
        _buildInputField(Icons.email, "Email"),
        _buildInputField(Icons.lock, "Password", isPassword: true),
        if (!isLogin) // Show phone number field only in sign-up mode
          _buildInputField(Icons.phone, "Phone Number"),
        SizedBox(height: 10),
        GestureDetector(
          onTap: isLogin ? _signIn : _signUp,
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
                isLogin ? "Login" : "Sign Up",
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
        controller: hint == "Username"
            ? _usernameController
            : hint == "Email"
            ? _emailController
            : hint == "Password"
            ? _passwordController
            : _phoneController,
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