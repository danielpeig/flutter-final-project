import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'registration.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,

      body: ListView(
        children: [

          // ── YELLOW WAVE HEADER ──
          Container(
            height: 280, // Reduced slightly to keep the form visible
            width: double.infinity,
            color: Colors.white,
            child: Stack(
              children: [
                // Dark Teal background blob
                Positioned(
                  top: 0,
                  left: 0,
                  right: 40,
                  child: Container(
                    height: 200,
                    decoration: const BoxDecoration(
                      color: Color(0xFF017075),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(80),
                        bottomRight: Radius.circular(180),
                      ),
                    ),
                  ),
                ),

                // Second wave shape
                Positioned(
                  top: 60,
                  left: 0,
                  child: Container(
                    height: 180,
                    width: 200,
                    decoration: const BoxDecoration(
                      color: Color(0xFF015C63),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(200),
                        topRight: Radius.circular(100),
                      ),
                    ),
                  ),
                ),

                // "Welcome to" - Now smaller and more elegant
                Positioned(
                  top: 75,
                  left: 30,
                  child: Text(
                    "Welcome to",
                    style: TextStyle(
                      fontSize: 24, // Dropped from 35 for better contrast with the brand name
                      fontWeight: FontWeight.w500, // Changed from w900 to make it look cleaner
                      color: Colors.white.withOpacity(0.9), // White looks sharper against the teal background
                      letterSpacing: 1.2,
                    ),
                  ),
                ),

                // "CraveHunt!" - The main focus
                Positioned(
                  top: 105, // Lowered slightly to create clear separation
                  left: 30,
                  right: 20,
                  child: Text(
                    "CraveHunt!",
                    style: TextStyle(
                      fontSize: 55, // 55 is the sweet spot for mobile brand titles
                      fontWeight: FontWeight.w900,
                      color: Colors.amber[500], // Using the primary amber for the logo feel
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 25),
          // ── FORM AREA ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Sign-in to your Account",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54, // Changed from black12 for better contrast
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // EMAIL
                TextFormField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(color: Color(0xFF015C63)),
                    prefixIcon: Icon(Icons.email, color: Color(0xFF015C63)),
                    border: const UnderlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF015C63)!),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber[600]!, width: 2),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // PASSWORD
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(color: Color(0xFF015C63)),
                    prefixIcon: Icon(Icons.lock, color: Color(0xFF015C63)),
                    border: const UnderlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF015C63)!),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber[600]!, width: 2),
                    ),
                  ),
                ),

                SizedBox(height: 30),

                // LOGIN BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton(

                    onPressed: () async {

                      var email = emailController.text;
                      var password = passwordController.text;

                      try {

                        await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                          email: email,
                          password: password,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Login Successful"),
                          ),
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const home(),
                          ),
                        );

                      } on FirebaseAuthException catch (e) {

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.message.toString()),
                          ),
                        );
                      }

                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF015C63),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    child: Text(
                      "LOGIN",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // SIGN UP LINK
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text(
                      "Don't have an account ? ",
                      style: TextStyle(color: Colors.black54),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.amber[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  ],
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}