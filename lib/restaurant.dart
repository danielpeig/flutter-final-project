import 'package:flutter/material.dart';
import 'package:flutter_final_project/add_review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantPage extends StatefulWidget {
  final String restaurantId;

  const RestaurantPage({super.key, required this.restaurantId});

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
                      SizedBox(
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
                      Positioned(
                        top: 50,
                        left: 20,
                        child: CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.5),
                          child: IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                    ],
                  ),

                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('tbl_restaurants')
                        .doc(widget.restaurantId)
                        .snapshots(),
                    builder: (context, snapshot) {

                      if (!snapshot.hasData) {
                        return Center(
                            child: CircularProgressIndicator()
                        );
                      }

                      if (!snapshot.data!.exists) {
                        return Center(
                            child: Text("Restaurant not found")
                        );
                      }

                      var restoInfo = snapshot.data!.data() as Map<String, dynamic>;

                      return Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    restoInfo['name'],
                                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    restoInfo['category'],
                                    style: TextStyle(color: Colors.grey, fontSize: 16),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    restoInfo['address'],
                                    style: TextStyle(color: Colors.grey, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "${restoInfo['rating'] ?? '0.0'}",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                                  ),
                                  Text(
                                    "${restoInfo['totalReviews'] ?? '0'} Reviews",
                                    style: TextStyle(color: Colors.grey, fontSize: 10),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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
                        StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('tbl_reviews').
                          where('restaurant_id', isEqualTo: widget.restaurantId).snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return Center(child: Text("No reviews yet. Be the first!"));
                            }

                            var reviews = snapshot.data!.docs;

                            return ListView.builder(
                              padding: EdgeInsets.all(20.0),
                              itemCount: reviews.length,
                              itemBuilder: (context, index) {
                                var reviewData = reviews[index];

                                var date = (reviewData['timestamp'] as Timestamp).toDate();
                                var formattedDate = "${date.day}/${date.month}/${date.year}";

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
                                                "Customer Reviewer", // You can later link this to 'user_id' to get actual names
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                              ),
                                              Text(
                                                "Posted on $formattedDate",
                                                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: List.generate(5, (starIndex) {
                                            return Icon(
                                              Icons.star,
                                              color: starIndex < (reviewData['rating'] ?? 0)
                                                  ? Colors.amber
                                                  : Colors.grey.shade300,
                                              size: 16,
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      reviewData['content'] ?? "",
                                      style: TextStyle(color: Colors.black87, height: 1.4),
                                    ),
                                    SizedBox(height: 16),
                                    Divider(color: Colors.grey.shade300, thickness: 1),
                                    SizedBox(height: 16),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        Center(child: Text("Image Gallery Goes Here")),
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddReviewPage(restaurantId: widget.restaurantId),
                      ),
                    );
                  },
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