import 'package:flutter/material.dart';

void main() {
  runApp(const home());
}

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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

              // Search Bar (Display for now, function later)
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

                    // Restaurant Card Holder
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: // Adds space below and to the right)
                      Card(
                        color: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        clipBehavior: Clip.antiAlias,
                        // Clickable/Redirect Function
                        child: InkWell(
                          onTap: () {
                            // Navigator to the details page
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => const DetailsPage()),
                            // );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image
                              ClipRRect(
                                // borderRadius: const BorderRadius.only(
                                //   // topLeft: Radius.circular(20),
                                //   // topRight: Radius.circular(20),
                                // ),
                                child: Image.asset(
                                  'images/resto-placeholder.png', // Make sure your asset is configured
                                  height: 140, // Match screenshot proportion
                                  width: double.infinity,
                                  fit: BoxFit.cover, // Fill the space without stretching
                                ),
                              ),

                              // Text
                              Padding(
                                padding: EdgeInsets.all(16.0), // Padding around all text
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

                                    // Tags/Category
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

                                    // Rating
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            // Should Display based on Backend Data Rating
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
      ),
    );
  }
}


