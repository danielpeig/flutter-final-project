import 'package:flutter/material.dart';
import 'package:flutter_final_project/restaurant.dart';

void main() {
  runApp(const RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: home(),
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
              Text("Profile")
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
                child: ListView(
                  children: [
                    SizedBox(height: 20),

                    // Restaurant Card Holder clickable/Redirect to specific resto
                    // Iterate based on restos in db
                    // *to be configed based on resto on db*
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child:
                      Card(
                        color: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RestaurantPage()),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image *replace with corresponding db data*
                              ClipRRect(
                                child: Image.asset(
                                  'images/resto-placeholder.png',
                                  height: 140,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              // Text
                              Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Restaurant Name
                                    Text(
                                      "Restaurant Name",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),

                                    SizedBox(height: 8),

                                    // Tags *to be configured based on db*
                                    Row(
                                      children: [
                                        Text("Cuisine", style: TextStyle(color: Colors.grey, fontSize: 14)),
                                        SizedBox(width: 5), // Small spacer
                                        Text("Food", style: TextStyle(color: Colors.grey, fontSize: 14)),
                                        SizedBox(width: 5), // Small spacer
                                        Text("Tags", style: TextStyle(color: Colors.grey, fontSize: 14)),
                                      ],
                                    ),

                                    SizedBox(height: 12),

                                    // Rating *to be configured based on db*
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.star, color: Colors.amber, size: 20),
                                            Icon(Icons.star, color: Colors.amber, size: 20),
                                            Icon(Icons.star, color: Colors.amber, size: 20),
                                            Icon(Icons.star, color: Colors.amber, size: 20),
                                            Icon(Icons.star, color: Colors.grey, size: 20), // Empty star
                                          ],
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "4.5",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
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


