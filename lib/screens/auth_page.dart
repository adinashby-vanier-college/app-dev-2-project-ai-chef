import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_ai_app/screens/landing_page.dart';

import 'ingredients_list_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPage();
}

class _AuthPage extends State<AuthPage> {
  bool _signingIn = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    // Firebase is already initialized in main.dart
  }

  /// 🔥 Store user in Firestore (CREATE)
  Future<void> _createUserInFirestore(User user) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({
      'email': user.email,
      'provider': user.providerData.first.providerId,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    debugPrint('✅ User stored in Firestore');
  }

  /// Google Sign-In
  Future<void> _signInWithGoogle() async {
    setState(() => _signingIn = true);

    try {
      final googleSignIn = GoogleSignIn(
        signInOption: SignInOption.standard,
      );

      await googleSignIn.signOut(); // force chooser

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        setState(() => _signingIn = false);
        return;
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
      await _auth.signInWithCredential(credential);

      final user = userCredential.user;
      if (user == null) return;

      await _createUserInFirestore(user);

      _goToIngredientsPage();
    } catch (e) {
      debugPrint("Google Sign-In error: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Sign-In failed: $e")));
    } finally {
      setState(() => _signingIn = false);
    }
  }

  /// Email/Password Sign-In
  Future<void> _signInWithEmail() async {
    String email = '';
    String password = '';
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Sign in with Email"),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (value) => email = value,
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter email' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (value) => password = value,
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter password' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              Navigator.of(context).pop();
              setState(() => _signingIn = true);

              try {
                UserCredential userCredential;
                try {
                  userCredential =
                  await _auth.signInWithEmailAndPassword(
                      email: email, password: password);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    userCredential =
                    await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                  } else {
                    rethrow;
                  }
                }

                final user = userCredential.user;
                if (user == null) return;

                await _createUserInFirestore(user);

                _goToIngredientsPage();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Sign-In failed: $e")));
              } finally {
                setState(() => _signingIn = false);
              }
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  void _goToIngredientsPage() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => LandingPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Text(
                "Welcome to AI Chef",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Generate recipes from what you have in your kitchen",
                style: TextStyle(color: Colors.white70, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: OutlinedButton(
                  onPressed: _signingIn ? null : _signInWithGoogle,
                  child: _signingIn
                      ? const CircularProgressIndicator()
                      : const Text("Sign in with Google"),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                child: ElevatedButton(
                  onPressed: _signingIn ? null : _signInWithEmail,
                  child: _signingIn
                      ? const CircularProgressIndicator()
                      : const Text("Sign in with Email"),
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}