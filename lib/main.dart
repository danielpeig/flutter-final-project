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
          title: Text("Restaurant Review"),
          centerTitle: true,
        ),

      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.person),
                  ),
                  const SizedBox(height: 10),
                  Text(
                      FirebaseAuth.instance.currentUser?.displayName ?? ""
                  ),
                  Text(
                    FirebaseAuth.instance.currentUser?.email ?? ""
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context)=> LoginPage()
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
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


