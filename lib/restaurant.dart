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
  bool _isFavorited = false;
  int _selectedNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF017075),

      // ── BOTTOM NAVIGATION BAR ──
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedNavIndex,
          onTap: (index) => setState(() => _selectedNavIndex = index),
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF017075),
          unselectedItemColor: Colors.grey[400],
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded, size: 26), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border_rounded, size: 26),
                label: 'Favorites'),
          ],
        ),
      ),

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tbl_restaurants')
            .doc(widget.restaurantId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.white));
          }
          if (!snapshot.data!.exists) {
            return const Center(child: Text("Restaurant not found"));
          }

          var restoInfo = snapshot.data!.data() as dynamic;
          var imageUrl = restoInfo['image_url'];

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [

                    // ── TEAL TOP SECTION ──
                    Container(
                      color: const Color(0xFF015C63),
                      padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // Back button
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.chevron_left,
                                color: Colors.white, size: 30),
                          ),

                          const SizedBox(height: 14),

                          // Name + Heart row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  restoInfo['name'] ?? "Restaurant Name",
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: () => setState(
                                        () => _isFavorited = !_isFavorited),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _isFavorited
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.amber[600],
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Rating + Category + Reviews count
                          Row(
                            children: [
                              // Rating pill — amber accent
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.amber[500],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.star,
                                        color: Colors.white, size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${restoInfo['rating'] ?? '0.0'}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 8),

                              // Category tag — semi-transparent white
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.20),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.fastfood,
                                        color: Colors.white, size: 13),
                                    const SizedBox(width: 4),
                                    Text(
                                      restoInfo['category'] ?? "Food",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 8),

                              Text(
                                "${restoInfo['reviews_count'] ?? '0'} Reviews",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // ── WARM WHITE ROUNDED BODY ──
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFFDF7),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // ── RESTAURANT IMAGE ──
                          Padding(
                            padding:
                            const EdgeInsets.fromLTRB(16, 20, 16, 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                imageUrl,
                                height: 220,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          // ── ADDRESS ──
                          Padding(
                            padding:
                            const EdgeInsets.fromLTRB(20, 16, 20, 4),
                            child: Row(
                              children: [
                                Icon(Icons.location_on,
                                    color: Colors.amber[500], size: 16),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    restoInfo['address'] ??
                                        "Address not provided",
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 13),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ── DIVIDER ──
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            child: Divider(
                                color: Colors.grey[200], thickness: 1),
                          ),

                          // ── REVIEWS HEADER ──
                          Padding(
                            padding:
                            const EdgeInsets.fromLTRB(20, 4, 20, 8),
                            child: Row(
                              children: [
                                const Icon(Icons.rate_review_outlined,
                                    color: Color(0xFF017075), size: 22),
                                const SizedBox(width: 8),
                                const Text(
                                  "Reviews",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ── REVIEWS LIST ──
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('tbl_reviews')
                                .where('restaurant_id',
                                isEqualTo: widget.restaurantId)
                                .snapshots(),
                            builder: (context, reviewSnapshot) {
                              if (!reviewSnapshot.hasData) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: CircularProgressIndicator(
                                        color: Colors.amber[400]),
                                  ),
                                );
                              }

                              var reviews = reviewSnapshot.data!.docs;

                              if (reviews.isEmpty) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(40),
                                    child: Column(
                                      children: [
                                        Icon(Icons.reviews_outlined,
                                            size: 48,
                                            color: Colors.grey[300]),
                                        const SizedBox(height: 12),
                                        Text(
                                          "No reviews yet.\nBe the first!",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              return ListView.builder(
                                shrinkWrap: true,
                                physics:
                                const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.fromLTRB(
                                    16, 0, 16, 16),
                                itemCount: reviews.length,
                                itemBuilder: (context, index) {
                                  var reviewData = reviews[index].data()
                                  as Map<String, dynamic>;

                                  var date =
                                  (reviewData['timestamp'] as Timestamp)
                                      .toDate();
                                  var formattedDate =
                                      "${date.day}/${date.month}/${date.year}";

                                  return Container(
                                    margin: const EdgeInsets.only(
                                        bottom: 12),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                      BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withOpacity(0.04),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            // Avatar — teal tinted
                                            CircleAvatar(
                                              radius: 22,
                                              backgroundColor:
                                              Colors.amber[100],
                                              child: const Icon(
                                                  Icons.person,
                                                  color:
                                                  Color(0xFF017075),
                                                  size: 26),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  const Text(
                                                    "Customer Reviewer",
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        fontSize: 15),
                                                  ),
                                                  Text(
                                                    "Posted on $formattedDate",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .grey.shade400,
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Rating badge — amber
                                            Container(
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.amber[50],
                                                borderRadius:
                                                BorderRadius.circular(
                                                    10),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.star,
                                                      size: 14,
                                                      color:
                                                      Colors.amber[400]),
                                                  const SizedBox(width: 3),
                                                  Text(
                                                    "${reviewData['rating'] ?? 0}",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color:
                                                      Colors.amber[700],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          reviewData['content'] ?? "",
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            height: 1.5,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── LEAVE A REVIEW BUTTON ──
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                color: const Color(0xFFFFFDF7),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF015C63),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddReviewPage(
                              restaurantId: widget.restaurantId),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit_outlined,
                        color: Colors.white, size: 20),
                    label: const Text(
                      "Leave a Review",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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