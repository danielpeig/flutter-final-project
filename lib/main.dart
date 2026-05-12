import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final_project/restaurant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';

void main() async{
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
      home: LoginPage(),
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
        backgroundColor: const Color(0xFFE07970),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "CraveHunt",
          style: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      drawer: Drawer(
        backgroundColor: Color(0xFFCDD7D8), // Powder Blue
        child: ListView(
          padding: EdgeInsets.zero,
          children: [

            // ── WAVE HEADER ──
            Container(
              height: 200,
              color: Color(0xFFCDD7D8), // Powder Blue
              child: Stack(
                children: [

                  // Salmon Paste blob
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 160,
                      decoration:  BoxDecoration(
                        color: Color(0xFFE07970), // Salmon Paste
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(40),
                        ),
                      ),
                    ),
                  ),

                  // Cantaloupe wave shape
                  Positioned(
                    top: 40,
                    left: -30,
                    child: Container(
                      height: 150,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Color(0xFFDE8948), // Cantaloupe
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(120),
                          topRight: Radius.circular(100),
                        ),
                      ),
                    ),
                  ),

                  // Profile info
                  Positioned(
                    bottom: 16,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Color(0xFFF9D58D), // Lemon Posset
                          child: Icon(
                            Icons.person,
                            color: Color(0xFFE07970), // Salmon
                            size: 40,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          FirebaseAuth.instance.currentUser?.displayName ?? "",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          FirebaseAuth.instance.currentUser?.email ?? "",
                          style:  TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),

            SizedBox(height: 10),

            // ── LOGOUT ──
            ListTile(
              leading: Icon(Icons.logout, color: Color(0xFFE07970)), // Salmon
              title: Text(
                "Logout",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),

          ],
        ),
      ),


      backgroundColor: Color.fromARGB (220, 248, 250, 252),

        body: Center(
          child: Column(
            children: [

              // Search Bar *make functional
              Padding(
                padding: EdgeInsets.all(5.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search restaurants...',
                    prefixIcon: Icon(Icons.search, color: Color(0xFFE07970)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Color(0xFFCDD7D8), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Color(0xFFE07970), width: 1.5),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('tbl_restaurants').snapshots(),
                  builder: (context, snapshots) {

                    // Loading Indicator
                    if(!snapshots.hasData){
                      return Center(
                          child: CircularProgressIndicator()
                      );
                    }

                    // Handle Errors
                    if (snapshots.hasError) {
                      return Center(
                          child: Text("Something went wrong")
                      );
                    }

                    var displayRestos = snapshots.data!.docs;

                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 20),
                      itemCount: displayRestos.length,
                      itemBuilder: (context, index) {

                        var restos = displayRestos[index];
                        String restoId = restos.id;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          child: Card(
                            color: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: () {
                                // 4. Pass the ID to your RestaurantPage
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RestaurantPage(restaurantId: restoId),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(
                                    restos['image_url'],
                                    height: 140,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          restos['name'],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          restos['category'],
                                          style: const TextStyle(color: Colors.grey, fontSize: 14),
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

                                            SizedBox(width: 8),

                                            Text(
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
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
    );
  }
}


