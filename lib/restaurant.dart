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
    return Scaffold(
      // Top-Level StreamBuilder: Fetches the specific restaurant document
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tbl_restaurants')
            .doc(widget.restaurantId)
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          if (!snapshot.data!.exists) return Center(child: Text("Restaurant not found"));

          var restoInfo = snapshot.data!.data() as dynamic;
          var imageUrl = restoInfo['image_url'];

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: 260,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
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
                                  restoInfo['name'] ?? "Restaurant Name",
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  restoInfo['category'] ?? "General",
                                  style: TextStyle(color: Colors.grey, fontSize: 16),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  restoInfo['address'] ?? "Address not provided",
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
                                  "${restoInfo['reviews_count'] ?? '0'} Reviews",
                                  style: TextStyle(color: Colors.grey, fontSize: 10),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Divider(indent: 20, endIndent: 20),

                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Text(
                        "Reviews",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),

                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('tbl_reviews')
                          .where('restaurant_id', isEqualTo: widget.restaurantId)
                          .snapshots(),
                      builder: (context, reviewSnapshot) {
                        if (!reviewSnapshot.hasData) return Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));

                        var reviews = reviewSnapshot.data!.docs;
                        if (reviews.isEmpty) return Center(child: Padding(padding: EdgeInsets.all(40), child: Text("No reviews yet. Be the first!")));

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(20.0),
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            var reviewData = reviews[index].data() as Map<String, dynamic>;

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
                                          Text("Customer Reviewer", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                          Text("Posted on $formattedDate", style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: List.generate(5, (s) => Icon(
                                        Icons.star,
                                        size: 16,
                                        color: s < (reviewData['rating'] ?? 0) ? Colors.amber : Colors.grey.shade300,
                                      )),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Text(reviewData['content'] ?? "", style: TextStyle(color: Colors.black87, height: 1.4)),
                                Divider(height: 32),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),

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
                    child: Text("Leave a Review", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}