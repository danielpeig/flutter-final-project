import 'package:flutter/material.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({super.key});

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 260,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('images/resto-placeholder.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Back Button
                      Positioned(
                        top: 50,
                        left: 20,
                        child: CircleAvatar(
                          backgroundColor: Colors.black.withValues(alpha: 0.5),
                          child: IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                      // Bookmark Button
                      Positioned(
                        top: 50,
                        right: 20,
                        child: CircleAvatar(
                          backgroundColor: Colors.black.withValues(alpha: 0.5),
                          child: IconButton(
                            icon: Icon(Icons.bookmark_border, color: Colors.white),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Restaurant Name",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Cuisine Type",
                                style: TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "123 Street Address, City Name",
                                style: TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ],
                          ),
                        ),

                        // Rating
                        Padding(
                          padding: EdgeInsets.only(top: 32.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "4.5",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                                ),
                                Text("52 Reviews", style: TextStyle(color: Colors.grey, fontSize: 10),)
                              ],
                            )
                          ),
                        ),
                      ],
                    ),
                  ),

                  TabBar(
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.black,
                    tabs: [
                      Tab(text: "Reviews"),
                      Tab(text: "Gallery"),
                    ],
                  ),

                  Container(
                    height: 430,
                    child: TabBarView(
                      children: [
                        // Reviews Tab
                        ListView.builder(
                          padding: EdgeInsets.all(20.0),
                          itemCount: 5, // Placeholder kung ilan reviews
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 22,
                                      backgroundImage: AssetImage('images/avatar-placeholder.png'),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Customer Reviewer",
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                          ),
                                          Text(
                                            "Posted on Dec 12, 2025",
                                            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.star, color: Colors.amber, size: 16),
                                        Icon(Icons.star, color: Colors.amber, size: 16),
                                        Icon(Icons.star, color: Colors.amber, size: 16),
                                        Icon(Icons.star, color: Colors.amber, size: 16),
                                        Icon(Icons.star, color: Colors.grey, size: 16),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Text(
                                  "Testing Review Content. This is where the user's feedback will go once the database is connected.",
                                  style: TextStyle(color: Colors.black87, height: 1.4),
                                ),
                                SizedBox(height: 16),

                                Divider(color: Colors.grey.shade300, thickness: 1),
                                SizedBox(height: 16),
                              ],
                            );
                          },
                        ),

                        // Gallery Tab
                        Center(
                            child: Text("Image Gallery Goes Here")
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Review Button
            Padding(
              padding: EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Leave a Review",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}