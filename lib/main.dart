import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final_project/restaurant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

// ── COLOR PALETTE (mirrors login.dart) ──
// Primary dark teal : Color(0xFF015C63)
// Primary teal      : Color(0xFF017075)
// Accent amber      : Colors.amber[500] / Colors.amber[600] / Colors.amber[700]
// Background        : Color(0xFFFFFDF7)  — warm white matching login bg

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  int _selectedCategoryIndex = 0;
  int _selectedNavIndex = 0;
  TextEditingController searchController = TextEditingController();
  String searchText = "";
  String sortBy = "Popular"; // Default sorting state

  // Updated to match your 10 specific DB categories
  final List<String> _categories = [
    "All", "Fine Dining", "Fast Casual", "Date Night", "Family Friendly",
    "Hidden Gems", "Healthy Eats", "Late Night", "Quick Bites", "Boozy Brunch", "Outdoor Seating"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF7),

      // ── APP BAR ──
      appBar: AppBar(
        backgroundColor: const Color(0xFF034C52),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "CraveHunt",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 20,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
      ),

      // ── DRAWER ──
      drawer: Drawer(
        backgroundColor: const Color(0xFF015C63),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [

            // ── DRAWER HEADER ──
            Container(
              height: 220,
              color: const Color(0xFF015C63),
              child: Stack(
                children: [

                  // Dark teal blob (mirrors login wave)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 180,
                      decoration: const BoxDecoration(
                        color: Color(0xFF034C52),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(40),
                        ),
                      ),
                    ),
                  ),

                  // Amber wave (mirrors login second wave)
                  Positioned(
                    top: 40,
                    left: -30,
                    child: Container(
                      height: 160,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.amber[400],
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(120),
                          topRight: Radius.circular(100),
                        ),
                      ),
                    ),
                  ),

                  // ── PROFILE INFO ──
                  Positioned(
                    bottom: 70,
                    left: 10,
                    right: 20,
                    child: FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('tbl_users')
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .get(),
                      builder: (context, snapshot) {
                        String fullname = "User";
                        String username = "user";
                        String email =
                            FirebaseAuth.instance.currentUser?.email ?? "";

                        if (snapshot.hasData && snapshot.data!.exists) {
                          var data =
                          snapshot.data!.data() as Map<String, dynamic>;
                          fullname = data['fullname'] ?? "User";
                          username = data['username'] ?? "user";
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [

                            // Avatar
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                Border.all(color: Colors.white, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 32,
                                backgroundColor: Colors.amber[100],
                                child: const Icon(
                                  Icons.person,
                                  color: Color(0xFF015C63),
                                  size: 38,
                                ),
                              ),
                            ),

                             SizedBox(width: 5),

                            // Name + username + email
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    fullname,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                      color: Colors.black87,
                                      height: 1.2,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                 SizedBox(height: 2),
                                  Text(
                                    "@$username",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                               SizedBox(height: 2),
                                  Text(
                                    email,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.black87,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // ── SECTION LABEL ──
            Padding(
              padding: EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Text(
                "ACCOUNT",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[400],
                  letterSpacing: 1.5,
                ),
              ),
            ),

            // ── LOGOUT TILE ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: Colors.transparent,
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF017075).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.logout_rounded,
                      color: Colors.amber[700], size: 20),
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.amber[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                trailing:
                Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ── BODY ──
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── TEAL HEADER SECTION ──
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
            decoration: BoxDecoration(
              color: Colors.amber[500],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Greeting
                const Text(
                  "What are you craving?",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search restaurants...",
                      // Clickable icon on the right
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search, color: Color(0xFF015C63)),
                        onPressed: () {
                          setState(() {
                            searchText = searchController.text.toLowerCase();
                          });
                        },
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── CATEGORY CHIPS ──
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: _categories.map((cat) {
                final isSelected = _categories.indexOf(cat) == _selectedCategoryIndex;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedCategoryIndex = _categories.indexOf(cat);
                      });
                    },
                    selectedColor: const Color(0xFF017075),
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[600],
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                );
              }).toList(),
            ),
          ),

          // ── RESTAURANT LIST ──
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('tbl_restaurants')
                  .snapshots(),
              builder: (context, snapshots) {
                if (!snapshots.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                        color: Colors.amber[400]),
                  );
                }

                // Use .where to strictly enforce BOTH category and search
                var docs = snapshots.data!.docs.where((doc) {
                  // Use doc.get() for safer access to fields
                  String name = (doc.get('name') ?? "").toString().toLowerCase();
                  String dbCategory = (doc.get('category') ?? "").toString();
                  String selectedCat = _categories[_selectedCategoryIndex];

                  // LOGIC: The restaurant must match the search text...
                  bool matchesSearch = name.contains(searchText.toLowerCase());

                  // ...AND it must match the category (if one is selected)
                  bool matchesCategory = (selectedCat == "All") || (dbCategory == selectedCat);

                  return matchesSearch && matchesCategory;
                }).toList();

                // (Keep your simplified sorting logic here...)

                if (docs.isEmpty) return const Center(child: Text("No restaurants found"));

                // var displayRestos = snapshots.data!.docs;

                return ListView.builder(
                  padding:
                  const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var restos = docs[index];
                    String restoId = restos.id;
                    double currentRating = double.parse(restos['rating'].toString()); // Safe conversion

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Card(
                        color: Colors.white,
                        elevation: 2,
                        shadowColor: Colors.black12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // Restaurant Image
                            Stack(
                              children: [
                                Image.network(
                                  restos['image_url'],
                                  height: 160,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF017075),
                                      borderRadius:
                                      BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      restos['category'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Card Content
                            Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    restos['name'],
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Row(
                                        children: List.generate(5, (starIndex) {
                                          double starPosition = starIndex + 1.0;

                                          if (currentRating >= starPosition) {
                                            return Icon(Icons.star, color: Colors.amber[400], size: 18);
                                          } else if (currentRating > starIndex && currentRating < starPosition) {
                                            return Icon(Icons.star_half, color: Colors.amber[400], size: 18);
                                          } else {
                                            return Icon(Icons.star_border, color: Colors.amber[400], size: 18);
                                          }
                                        }),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.amber[50],
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          currentRating.toStringAsFixed(1), // Shows 4.8 instead of 4.800001
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.amber[700],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),

                                      // ── VIEW REVIEWS BUTTON ──
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  RestaurantPage(
                                                      restaurantId:
                                                      restoId),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                            Icons.rate_review_outlined,
                                            size: 14,
                                            color: Colors.white),
                                        label: const Text(
                                          "View Reviews",
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          const Color(0xFF015C63),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(20),
                                          ),
                                          padding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6),
                                          minimumSize: Size.zero,
                                          tapTargetSize:
                                          MaterialTapTargetSize
                                              .shrinkWrap,
                                          elevation: 0,
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
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}