import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddReviewPage extends StatefulWidget {
  final String restaurantId;

  const AddReviewPage({super.key, required this.restaurantId});

  @override
  State<AddReviewPage> createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  int rating = 0;
  int _selectedNavIndex = 0;
  final reviewController = TextEditingController();

  final List<String> _ratingLabels = ['', 'Terrible', 'Bad', 'Okay', 'Good', 'Excellent'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF015C63),

      body: Column(
        children: [

          // ── AMBER TOP HEADER ──
          Container(
            color: Color(0xFF015C63),
            width: 500,
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Back button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.chevron_left, color: Colors.white, size: 26),
                  ),
                ),

                const SizedBox(height: 14),

                const Text(
                  "Leave a Review",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Your feedback helps others choose the best restaurants.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // ── OFF-WHITE ROUNDED BODY ──
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFFF8F0),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
                children: [

                  // ── RATING SECTION ──
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.star_rate_rounded, color: Colors.amber[500], size: 22),
                            const SizedBox(width: 8),
                            const Text(
                              "Your Rating",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Stars
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return GestureDetector(
                              onTap: () => setState(() => rating = index + 1),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(
                                  index < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                                  color: index < rating ? Colors.amber[400] : Colors.grey[300],
                                  size: 44,
                                ),
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          rating > 0 ? _ratingLabels[rating] : "Tap to rate",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: rating > 0 ? Colors.black : Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── REVIEW TEXT SECTION ──
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.rate_review_outlined, color: Color(0xFF015C63), size: 22),
                            const SizedBox(width: 8),
                            const Text(
                              "Write your Review",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: reviewController,
                          maxLines: 6,
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                          decoration: InputDecoration(
                            hintText: 'Share details of your experience...',
                            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                            filled: true,
                            fillColor: const Color(0xFFFFF8F0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: Colors.amber[400]!, width: 1.5),
                            ),
                            contentPadding: const EdgeInsets.all(14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── SUBMIT BUTTON (pinned to bottom) ──
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            color: const Color(0xFFFFF8F0),
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
                onPressed: () async {
                  String review = reviewController.text;
                  final User? user = FirebaseAuth.instance.currentUser;

                  if (rating == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Please select a rating'),
                        backgroundColor: Colors.amber[400],
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                    return;
                  }

                  if (review.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Please write a review'),
                        backgroundColor: Colors.amber[400],
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                    return;
                  }

                  await FirebaseFirestore.instance.collection('tbl_reviews').add({
                    'restaurant_id': widget.restaurantId,
                    'user_id': user?.uid,
                    'rating': rating,
                    'content': review,
                    'timestamp': DateTime.now(),
                  });

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Review submitted!'),
                        backgroundColor: Color(0xFF015C63),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                icon: Icon(Icons.send_rounded, color: Colors.white, size: 18),
                label: Text(
                  'Submit Review',
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
      ),
    );
  }
}