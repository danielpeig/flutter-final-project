import 'package:flutter/material.dart';
import 'package:flutter_final_project/registration.dart';
import 'package:flutter_final_project/restaurant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'login.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegisterPage(),
    );
  }
}

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurant Review"),
        centerTitle: true,
      ),

      drawer: Drawer(
        child: ListView(
          children: const [
            Text("Profile")
          ],
        ),
      ),

      backgroundColor: const Color.fromARGB(220, 248, 250, 252),

      body: Center(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search restaurants...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),

            Expanded(
              child: ListView(
                children: [

                  const SizedBox(height: 20),

                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 15),

                    child: Card(
                      color: Colors.white,
                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(20),
                      ),

                      clipBehavior: Clip.antiAlias,

                      child: InkWell(

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const RestaurantPage(),
                            ),
                          );
                        },

                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                            Image.asset(
                              'images/resto-placeholder.png',
                              height: 140,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),

                            Padding(
                              padding:
                              const EdgeInsets.all(16.0),

                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,

                                children: [

                                  const Text(
                                    "Restaurant Name",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                      FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Row(
                                    children: const [

                                      Text(
                                        "Cuisine",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),

                                      SizedBox(width: 5),

                                      Text(
                                        "Food",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),

                                      SizedBox(width: 5),

                                      Text(
                                        "Tags",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),

                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  Row(
                                    children: [

                                      Row(
                                        children: const [

                                          Icon(Icons.star,
                                              color: Colors.amber,
                                              size: 20),

                                          Icon(Icons.star,
                                              color: Colors.amber,
                                              size: 20),

                                          Icon(Icons.star,
                                              color: Colors.amber,
                                              size: 20),

                                          Icon(Icons.star,
                                              color: Colors.amber,
                                              size: 20),

                                          Icon(Icons.star,
                                              color: Colors.grey,
                                              size: 20),

                                        ],
                                      ),

                                      const SizedBox(width: 8),

                                      const Text(
                                        "4.5",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight:
                                          FontWeight.w500,
                                        ),
                                      ),

                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}