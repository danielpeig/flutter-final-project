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
            height: 300,
            width: double.infinity,
            color: Colors.white,
            child: Stack(
              children: [

                // Yellow background blob
                Positioned(
                  top: 0,
                  left: 0,
                  right: 50,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color:  Color(0xFF017075),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(80),
                        bottomRight: Radius.circular(180),
                      ),
                    ),
                  ),
                ),

                // Second wave shape
                Positioned(
                  top: 60,
                  left:0,
                  child: Container(
                    height: 180,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Color(0xFF015C63),
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(200),
                        topRight: Radius.circular(100),
                      ),
                    ),
                  ),
                ),

                // Title at bottom of wave
                Positioned(
                  bottom: 100,
                  left: 30,
                  child: Text(
                    "Welcome to",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w900,
                      color: Colors.amber[500],
                    ),
                  ),
                ),

                Positioned(
                  top: 180,
                  bottom: 5,
                  left: 30,
                  child: Text(
                    "CraveHunt!",
                    style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.w900,
                      color: Colors.amber[700],
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
                      color: Colors.black12,
                      fontSize: 20,
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