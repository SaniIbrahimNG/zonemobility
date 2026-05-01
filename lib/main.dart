import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:convert';
import 'package:timeago/timeago.dart' as timeago;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_map/flutter_map.dart';
//import 'package:latlong2/latlong.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:shimmer/shimmer.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as img;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyB_Zbz_z_jZ4VcRiOWAqiLme0gG7Fe2C-g",
        authDomain: "triex-e2f3d.firebaseapp.com",
        projectId: "triex-e2f3d",
        storageBucket: "triex-e2f3d.firebasestorage.app",
        messagingSenderId: "783775282648",
        appId: "1:783775282648:web:959810601586473ddd6ead",
        measurementId: "G-2M0BMJ8GGX"),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Application name
      title: 'Deck.',
      // Application theme data, you can set the colors for the application as
      // you want
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      // A widget which will be started on application startup
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo
                const SizedBox(height: 150),
                Text('Deck Mobility',
                    style: GoogleFonts.caveat(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 10),
                Text('Rides . Logistics . Transport',
                    style: GoogleFonts.caveat(
                      color: Colors.grey[800],
                      fontSize: 20,
                    )),
                const SizedBox(height: 100),

                // Login Button
                // Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'LOGIN',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Register Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'REGISTER',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false; // Add this variable

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> SignIn(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return; // Return early if form validation fails
    }

    setState(() {
      isLoading = true; // Start loading
    });

    // Show the loading dialog
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.black,
            strokeWidth: 6.0,
            backgroundColor: Colors.transparent,
          ),
        );
      },
    );

    try {
      // Sign in with Firebase
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Get the current user
      User? user = userCredential.user;

      if (user != null) {
        // Retrieve user's display name for passing to the HomePage
        String displayName = user.displayName ?? 'User';

        // Close the loading dialog
        Navigator.pop(context);

        // Navigate to the HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(userName: displayName),
          ),
        );
      }
    } catch (e) {
      // Close the loading dialog
      Navigator.pop(context);

      // Display the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error during login: $e")),
      );
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            'Login',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email or phone',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email or phone number';
                    }
                    // Validate as email or phone format
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value) &&
                        !RegExp(r'^\d{10}$').hasMatch(value)) {
                      return 'Enter a valid email or phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    await SignIn(context);
                  },
                  child: Container(
                    height: 50,
                    width: 300,
                    child: const Center(
                      child: Text('LOGIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          )),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    // Navigate to RegisterPage
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text(
                    'Don\'t have an account? Register here',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String userName;

  const HomePage({
    super.key,
    required this.userName,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  LatLng? userLocation;
  List<LatLng> nearbyDrivers = [];

  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  String pickupAddress = '';
  final TextEditingController _pickupController = TextEditingController();
  FocusNode _pickupFocusNode = FocusNode();
  final TextEditingController _destinationController = TextEditingController();
  FocusNode _destinationFocusNode = FocusNode();

  @override
  void dispose() {
    _pickupController.dispose();
    _pickupFocusNode.dispose();
    _destinationController.dispose();
    _destinationFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchUserLocation(); // Fetch location immediately
  }

  Future<void> _fetchUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        print("Location permanently denied");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        userLocation = LatLng(position.latitude, position.longitude);
      });

      _setMarkers();
      _loadNearbyDrivers();
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  void _loadNearbyDrivers() {
    if (userLocation != null) {
      nearbyDrivers = [
        LatLng(userLocation!.latitude + 0.001, userLocation!.longitude + 0.001),
        LatLng(userLocation!.latitude - 0.001, userLocation!.longitude - 0.001),
      ];
      _setMarkers();
    }
  }

  void _setMarkers() {
    final markers = <Marker>{};

    if (userLocation != null) {
      markers.add(Marker(
        markerId: const MarkerId('user'),
        position: userLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
    }

    for (int i = 0; i < nearbyDrivers.length; i++) {
      markers.add(Marker(
        markerId: MarkerId('driver_$i'),
        position: nearbyDrivers[i],
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      ));
    }

    setState(() {
      _markers = markers;
    });
  }

  void _handleRideSelection(String rideType) async {
    if (userLocation == null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Location Error"),
          content: const Text("Location not available."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    final requestDoc =
        await FirebaseFirestore.instance.collection('ride_requests').add({
      'RideType': rideType,
      'Status': 'pending',
      'Time': FieldValue.serverTimestamp(),
      'Pickup Location': _pickupController.text.trim(),
      'Destination': _destinationController.text.trim(),
      'userName': widget.userName,
      'DriverStatus': "driver_booked",
      'Code': "8492",
    });
    final rideId = requestDoc.id;

    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => SearchingScreen(
          rideId: rideId,
          rideType: rideType,
          pickupLocation: _pickupController.text.trim(),
          destination: _destinationController.text.trim(),
          onCancel: () async {
            Navigator.of(context).pop();
            await FirebaseFirestore.instance
                .collection('ride_requests')
                .doc(requestDoc.id)
                .update({'Status': 'cancelled'});

            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Ride Cancelled",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                content: const Text("You have cancelled the ride."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Getter to rebuild rides page reactively
  Widget get _ridesPage => SafeArea(
        child: Stack(
          children: [
            userLocation != null
                ? GoogleMap(
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                    initialCameraPosition:
                        CameraPosition(target: userLocation!, zoom: 16),
                    markers: _markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  )
                : const Center(child: CircularProgressIndicator()),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _pickupController,
                      focusNode: _pickupFocusNode,
                      decoration: InputDecoration(
                        hintText: 'Enter Pickup Location',
                        filled: true,
                        fillColor: Colors.grey[100],
                        prefixIcon: Icon(Icons.radio_button_checked,
                            color: Colors.grey[800]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _destinationController,
                      focusNode: _destinationFocusNode,
                      decoration: InputDecoration(
                        hintText: 'Enter Destination',
                        filled: true,
                        fillColor: Colors.grey[100],
                        prefixIcon:
                            Icon(Icons.location_on, color: Colors.green[800]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (_destinationController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Please Enter Your Destination!")),
                          );
                          return;
                        }
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) =>
                              RidePage(onSelect: _handleRideSelection),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Book Ride',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          DashboardPage(
            userName: widget.userName,
            onTabSelected: _onBottomNavTapped,
          ),

          UserOrdersListPage(), // 🔁 replaced _ridesPage
          const support(), // 🔁 replaced LogisticsPage
          const profile(), // 🔁 replaced TransportPage
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 70, // 👈 increase this (default is ~56–60)
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _selectedIndex,
          onTap: _onBottomNavTapped,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon:
                  Image.asset('assets/images/taxi.png', width: 25, height: 25),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/package.png',
                  width: 22, height: 22),
              label: 'Support',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/shuttle-service.png',
                  width: 22, height: 22),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class AutoScrollingBanners extends StatefulWidget {
  const AutoScrollingBanners({super.key});

  @override
  State<AutoScrollingBanners> createState() => _AutoScrollingBannersState();
}

class _AutoScrollingBannersState extends State<AutoScrollingBanners> {
  int _currentPage = 0;

  final List<Widget> _banners = const [
    _RideBanner(),
    _LogisticsBanner(),
    _FoodShopBanner(),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;

      setState(() {
        _currentPage = (_currentPage + 1) % _banners.length;
      });

      _startAutoScroll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),

        /// 🔥 THIS REMOVES SIDE SLIDE COMPLETELY
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween(begin: 0.95, end: 1.0).animate(animation),
              child: child,
            ),
          );
        },

        child: Container(
          key: ValueKey(_currentPage),
          child: _banners[_currentPage],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔥 COMMON BANNER STYLE (REDUCES DUPLICATION)
////////////////////////////////////////////////////////////

class _BannerContainer extends StatelessWidget {
  final List<Color> colors;
  final String image;
  final String text;

  const _BannerContainer({
    required this.colors,
    required this.image,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(8), // ✅ required
      ),
      child: Row(
        children: [
          Image.asset(
            image,
            width: 40, // 🔥 bigger icon
            height: 40,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                height: 1.4,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// RIDES
////////////////////////////////////////////////////////////

class _RideBanner extends StatelessWidget {
  const _RideBanner();

  @override
  Widget build(BuildContext context) {
    return const _BannerContainer(
      colors: [Color(0xff0c0925), Color(0xFF8E76FE)],
      image: 'assets/images/shopping-bag.png',
      text: "Skip the stress.\nShop in comfort anytime!",
    );
  }
}

////////////////////////////////////////////////////////////
/// LOGISTICS
////////////////////////////////////////////////////////////

class _LogisticsBanner extends StatelessWidget {
  const _LogisticsBanner();

  @override
  Widget build(BuildContext context) {
    return const _BannerContainer(
      colors: [Color(0xff34083d), Color(0xFF0288D1)],
      image: 'assets/images/courier-delivery.png',
      text: "Fast delivery.\nSend packages anywhere!",
    );
  }
}

////////////////////////////////////////////////////////////
/// FOOD & SHOP
////////////////////////////////////////////////////////////

class _FoodShopBanner extends StatelessWidget {
  const _FoodShopBanner();

  @override
  Widget build(BuildContext context) {
    return const _BannerContainer(
      colors: [Color(0xff702007), Color(0xFFFF8A65)],
      image: 'assets/images/take-away.png',
      text: "Craving something?\nGet food & essentials fast!",
    );
  }
}

class VendorOnboardingPage extends StatefulWidget {
  const VendorOnboardingPage({super.key});

  @override
  State<VendorOnboardingPage> createState() => _VendorOnboardingPageState();
}

class _VendorOnboardingPageState extends State<VendorOnboardingPage> {
  final _formKey = GlobalKey<FormState>();
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  XFile? _profileImage;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _businessNameController = TextEditingController();
  String? _selectedCategory;
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _storeLocationController =
      TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  String? _selectedBank;
  final TextEditingController _accountNameController = TextEditingController();

  final List<String> _categories = [
    'Food Vendor',
    'Grocery Vendor',
    'Pharmacy'
  ];
  final List<String> _banks = [
    'Access Bank',
    'GT Bank',
    'UBA',
    'Zenith',
    'First Bank'
  ];

  bool _isLoading = false;

  // ---------------- IMAGE PICKER ----------------
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = pickedFile;
      });
    }
  }

  // ---------------- UPLOAD IMAGE TO FIREBASE STORAGE ----------------
  Future<String?> _uploadProfileImage(XFile imageFile) async {
    try {
      final fileName = 'vendors/${DateTime.now().millisecondsSinceEpoch}.png';
      final ref = FirebaseStorage.instance.ref().child(fileName);

      if (kIsWeb) {
        final bytes = await imageFile.readAsBytes();
        await ref.putData(bytes);
      } else {
        await ref.putFile(File(imageFile.path));
      }

      final url = await ref.getDownloadURL();
      return url;
    } catch (e, stack) {
      print("UPLOAD ERROR → $e");
      print(stack);
      return null;
    }
  }

  // ---------------- SAVE TO FIRESTORE ----------------
  Future<void> _submitVendor() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null || _selectedBank == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select category and bank")),
      );
      return;
    }
    if (_profileImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload a profile image")),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final imageUrl = await _uploadProfileImage(_profileImage!);
      if (imageUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to upload image")),
        );
        setState(() => _isLoading = false);
        return;
      }

      final user = FirebaseAuth.instance.currentUser!;
      await FirebaseFirestore.instance
          .collection('Vendors')
          .doc(user.uid) // <-- Use UID as document ID
          .set({
        'businessName': _businessNameController.text.trim(),
        'category': _selectedCategory,
        'hours': _hoursController.text.trim(),
        'storeLocation': _storeLocationController.text.trim(),
        'accountNumber': _accountNumberController.text.trim(),
        'bank': _selectedBank,
        'accountName': _accountNameController.text.trim(),
        'profileImageUrl': imageUrl,
        'status': 'pending', // Vendor status
        'createdAt': Timestamp.now(),
        'uid': user.uid,
      });

      // Navigate to Vendor Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => VendorDashboardPage(vendorId: currentUserId)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ---------------- CHECK IF USER IS VENDOR ----------------
  static Future<void> checkVendorStatus(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must be logged in")),
      );
      return;
    }

    final doc = await FirebaseFirestore.instance
        .collection('Vendors')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => VendorDashboardPage(vendorId: user.uid),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VendorOnboardingPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Back Button + Title
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios),
                    ),
                    const Spacer(),
                    const Text(
                      "Vendor Onboarding",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
                const SizedBox(height: 24),

                // Profile Image Upload
                GestureDetector(
                  onTap: _pickImage,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                          image: _profileImage != null
                              ? DecorationImage(
                                  image: kIsWeb
                                      ? NetworkImage(_profileImage!.path)
                                      : FileImage(File(_profileImage!.path))
                                          as ImageProvider,
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _profileImage == null
                            ? const Icon(Icons.person,
                                size: 40, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Upload Profile Image",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Business Name
                TextFormField(
                  controller: _businessNameController,
                  decoration: InputDecoration(
                    hintText: "Business Name",
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (val) =>
                      val == null || val.isEmpty ? "Enter business name" : null,
                ),
                const SizedBox(height: 16),

                // Category Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: _categories
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedCategory = val;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Select Category",
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (val) => val == null ? "Select a category" : null,
                ),
                const SizedBox(height: 16),

                // Opening and Closing Hours
                TextFormField(
                  controller: _hoursController,
                  decoration: InputDecoration(
                    hintText: "Opening & Closing Hours (e.g. 8AM - 6PM)",
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (val) =>
                      val == null || val.isEmpty ? "Enter working hours" : null,
                ),
                const SizedBox(height: 16),

                // Store Location
                TextFormField(
                  controller: _storeLocationController,
                  decoration: InputDecoration(
                    hintText: "Store Location",
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (val) => val == null || val.isEmpty
                      ? "Enter store location"
                      : null,
                ),
                const SizedBox(height: 16),

                // Account Number
                TextFormField(
                  controller: _accountNumberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Account Number",
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (val) => val == null || val.isEmpty
                      ? "Enter account number"
                      : null,
                ),
                const SizedBox(height: 16),

                // Bank Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedBank,
                  items: _banks
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedBank = val;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Select Bank",
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (val) => val == null ? "Select a bank" : null,
                ),
                const SizedBox(height: 16),

                // Account Name
                TextFormField(
                  controller: _accountNameController,
                  decoration: InputDecoration(
                    hintText: "Account Name",
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (val) =>
                      val == null || val.isEmpty ? "Enter account name" : null,
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitVendor,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Get Onboard",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VendorOrderDetailsPage extends StatefulWidget {
  final String orderId;
  final Map<String, dynamic> orderData;

  const VendorOrderDetailsPage({
    super.key,
    required this.orderId,
    required this.orderData,
  });

  @override
  State<VendorOrderDetailsPage> createState() => _VendorOrderDetailsPageState();
}

class _VendorOrderDetailsPageState extends State<VendorOrderDetailsPage> {
  late Map<String, dynamic> _order; // Local copy to update UI
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _order = Map<String, dynamic>.from(widget.orderData);
  }

  Future<void> _acceptOrder() async {
    setState(() => _isUpdating = true);

    // Generate a 6-digit pickup code
    final pickupCode = Random().nextInt(900000) + 100000; // 100000 - 999999

    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderId)
          .update({
        'status': 'accepted',
        'pickupCode': pickupCode,
      });

      // Update local copy to reflect UI immediately
      setState(() {
        _order['status'] = 'accepted';
        _order['pickupCode'] = pickupCode;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Order accepted. Pickup code: $pickupCode"),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isUpdating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemsMap = _order['items'] as Map<String, dynamic>? ?? {};
    double totalPrice = 0;
    itemsMap.forEach((key, value) {
      final price = value['price'] ?? 0;
      final qty = value['qty'] ?? 1;
      totalPrice += price * qty;
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            'Order Details',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info
            Text(
              "Order from: ${_order['userName'] ?? 'Anonymous'}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Pickup code (if exists)
            if (_order['pickupCode'] != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  "Pickup Code: ${_order['pickupCode']}",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple),
                ),
              ),

            // List of Items
            Expanded(
              child: ListView.builder(
                itemCount: itemsMap.length,
                itemBuilder: (context, index) {
                  final key = itemsMap.keys.elementAt(index);
                  final item = itemsMap[key];
                  final qty = item['qty'] ?? 1;
                  final name = item['name'] ?? 'Unnamed';
                  final price = item['price'] ?? 0;

                  return ListTile(
                    title: Text(name),
                    subtitle: Text("Quantity: $qty"),
                    trailing: Text("₦${(price * qty).toStringAsFixed(2)}"),
                  );
                },
              ),
            ),

            const Divider(thickness: 1.5),

            // Total & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total: ₦${totalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _order['status'] ?? 'New',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Accept Order Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: (_order['status'] == 'accepted' || _isUpdating)
                    ? null
                    : _acceptOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                child: _isUpdating
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        _order['status'] == 'accepted'
                            ? "Order Accepted"
                            : "Accept Order",
                        style: const TextStyle(fontSize: 18),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VendorDashboardPage extends StatefulWidget {
  final String vendorId;

  const VendorDashboardPage({super.key, required this.vendorId});

  @override
  State<VendorDashboardPage> createState() => _VendorDashboardPageState();
}

class _VendorDashboardPageState extends State<VendorDashboardPage> {
  String selectedTab = "pending"; // default = New Orders
  bool isFoodVendor = false; // ✅ Added: tracks if vendor is a food vendor

  // 🔹 Convert tab title to firestore status
  String _tabToStatus(String tab) {
    switch (tab) {
      case "New":
        return "pending";
      case "Pending":
        return "accepted";
      case "Completed":
        return "completed";
      default:
        return "pending";
    }
  }

  @override
  Widget build(BuildContext context) {
    final vendorId = widget.vendorId;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// 🔹 BACK BUTTON
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                  const Spacer(),
                ],
              ),

              const SizedBox(height: 16),

              /// 🔹 VENDOR CARD
              _vendorCard(vendorId),

              const SizedBox(height: 16),

              /// 🔹 MANAGE PRODUCTS
              _manageProducts(vendorId),

              const SizedBox(height: 16),

              /// 🔹 ORDERS HEADER
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Orders",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700]),
                ),
              ),

              const SizedBox(height: 10),

              /// 🔹 TABS WITH COUNTS
              Row(
                children: [
                  Expanded(child: _orderTab("New", vendorId)),
                  const SizedBox(width: 8),
                  Expanded(child: _orderTab("Pending", vendorId)),
                  const SizedBox(width: 8),
                  Expanded(child: _orderTab("Completed", vendorId)),
                ],
              ),

              const SizedBox(height: 20),

              /// 🔹 ORDERS LIST
              _ordersList(vendorId),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // 🔹 Vendor Card
  // -------------------------------------------------------

  Widget _vendorCard(String vendorId) {
    return Center(
      child: Container(
        height: 120,
        width: 350,
        padding: const EdgeInsets.all(12),
        decoration: _cardDecoration(),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Vendors')
              .doc(vendorId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final vendorData = snapshot.data!.data() as Map<String, dynamic>?;

            if (vendorData == null) {
              return const Center(child: Text("Vendor not found"));
            }

            // ✅ Set isFoodVendor based on Firebase category
            final category = vendorData['category'] ?? '';
            isFoodVendor = category == "Food Vendor";

            final imageUrl = vendorData['profileImageUrl'];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          imageUrl != null ? NetworkImage(imageUrl) : null,
                      child: imageUrl == null ? const Icon(Icons.person) : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        vendorData['businessName'] ?? "Vendor",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "Today's Sale: ₦${vendorData['todaysSale'] ?? 0}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // 🔹 Manage Products
  // -------------------------------------------------------

  Widget _manageProducts(String vendorId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VendorProductsPage(
              vendorId: vendorId,
              isFoodVendor: isFoodVendor, // ✅ Pass isFoodVendor
            ),
          ),
        );
      },
      child: Container(
        height: 50,
        width: 350,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: _cardDecoration(),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Manage Products",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // 🔹 ORDER TAB WITH LIVE COUNT
  // -------------------------------------------------------

  Widget _orderTab(String title, String vendorId) {
    final status = _tabToStatus(title);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('vendorIds', arrayContains: vendorId)
          .where('status', isEqualTo: status)
          .snapshots(),
      builder: (context, snapshot) {
        int count = snapshot.data?.docs.length ?? 0;

        bool isSelected = selectedTab == status;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedTab = status;
            });
          },
          child: Container(
            height: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? Colors.deepPurple : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "$title ($count)",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }

  // -------------------------------------------------------
  // 🔹 ORDERS LIST FILTERED BY TAB
  // -------------------------------------------------------

  Widget _ordersList(String vendorId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('vendorIds', arrayContains: vendorId)
          .where('status', isEqualTo: selectedTab)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final orders = snapshot.data!.docs;

        if (orders.isEmpty) {
          return const Text("No orders found");
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index].data() as Map<String, dynamic>? ?? {};

            final userName = order['userName'] ?? "Anonymous";
            final itemsMap = order['items'] as Map<String, dynamic>? ?? {};

            final itemCount = itemsMap.length;

            double totalPrice = 0;
            itemsMap.forEach((key, value) {
              totalPrice += (value['price'] ?? 0) * (value['qty'] ?? 1);
            });

            final status = order['status'] ?? "";

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VendorOrderDetailsPage(
                      orderId: orders[index].id,
                      orderData: order,
                    ),
                  ),
                );
              },
              child: Container(
                height: 100,
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.all(12),
                decoration: _cardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Order from: $userName",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text("Items: $itemCount",
                        style: const TextStyle(color: Colors.grey)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("₦${totalPrice.toStringAsFixed(2)}",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text(status,
                            style: const TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold)),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // -------------------------------------------------------
  // 🔹 Shared Decoration
  // -------------------------------------------------------

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}

class AddProductPage extends StatefulWidget {
  final String vendorId;
  final bool isFoodVendor;

  const AddProductPage(
      {required this.vendorId, required this.isFoodVendor, super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  File? _imageFile;
  Uint8List? _imageBytes;
  final picker = ImagePicker();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  bool loading = false;

  /// NEW: fallback asset
  String? fallbackAsset;

  /// ADD YOUR ICON PATHS HERE
  final List<String> foodIcons = [
    "assets/images/bibimbap.png",
    "assets/images/coke.png",
    "assets/images/danwake.png",
    "assets/images/masa.png",
    "assets/images/party jollof rice.jpg",
    "assets/images/pizza.png",
    "assets/images/puff.png",
    "assets/images/shawarma.png",
  ];

  // Food-specific fields
  String? selectedCategory;

  final List<String> foodCategories = [
    'Drinks',
    'Spaghetti',
    'Rice',
    'Swallow',
    'Shawarma',
    'Pizza',
    'Small Chops',
    'Pastries'
  ];

  List<Map<String, dynamic>> addons = [];
  List<Map<String, dynamic>> sides = [];

  // ---------------- PICK IMAGE ----------------

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();

        setState(() {
          _imageBytes = bytes;
        });
      } else {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    }
  }

  // ---------------- SELECT FALLBACK ICON ----------------

  void selectFallbackIcon() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return GridView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: foodIcons.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (_, index) {
            final icon = foodIcons[index];

            return GestureDetector(
              onTap: () {
                setState(() {
                  fallbackAsset = icon;
                });

                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: fallbackAsset == icon
                          ? Colors.deepPurple
                          : Colors.grey.shade300),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(icon),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ---------------- ADD PRODUCT ----------------

  Future addProduct() async {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        descController.text.isEmpty ||
        (_imageFile == null && _imageBytes == null) ||
        (widget.isFoodVendor && selectedCategory == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please fill all fields and add an image")),
      );

      return;
    }

    setState(() {
      loading = true;
    });

    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      final ref =
          FirebaseStorage.instance.ref().child("products/$fileName.jpg");

      String imageUrl;

      if (kIsWeb) {
        await ref.putData(_imageBytes!);

        imageUrl = await ref.getDownloadURL();
      } else {
        await ref.putFile(_imageFile!);

        imageUrl = await ref.getDownloadURL();
      }

      await FirebaseFirestore.instance.collection("products").add({
        "vendorId": widget.vendorId,

        "name": nameController.text,

        "price": double.tryParse(priceController.text) ?? 0,

        "description": descController.text,

        "image": imageUrl,

        /// NEW FIELD
        "fallbackAsset": fallbackAsset ?? "assets/images/food.png",

        "createdAt": Timestamp.now(),

        "category": widget.isFoodVendor ? selectedCategory : null,

        "addons": widget.isFoodVendor ? addons : [],

        "sides": widget.isFoodVendor ? sides : [],
      });

      setState(() {
        loading = false;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Success"),
          content: const Text("Product added successfully"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                Navigator.pop(context);
              },
              child: const Text("OK"),
            )
          ],
        ),
      );
    } catch (e) {
      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding product: $e")),
      );
    }
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    ImageProvider? preview;

    if (_imageBytes != null)
      preview = MemoryImage(_imageBytes!);
    else if (_imageFile != null)
      preview = FileImage(_imageFile!);
    else if (fallbackAsset != null) preview = AssetImage(fallbackAsset!);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            '',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),

              /// IMAGE PREVIEW

              CircleAvatar(
                radius: 55,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: preview,
                child: preview == null
                    ? Icon(Icons.add_photo_alternate,
                        size: 35, color: Colors.grey[600])
                    : null,
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: pickImage,
                    icon: const Icon(Icons.image),
                  ),
                  IconButton(
                    onPressed: selectFallbackIcon,
                    icon: const Icon(Icons.fastfood),
                  ),
                ],
              ),

              const Text("Product Image"),

              const SizedBox(height: 20),

              buildInputField(nameController, "Product Name"),

              labelText("Product Name"),

              buildInputField(priceController, "Product Price",
                  keyboardType: TextInputType.number),

              labelText("Price"),

              buildInputField(descController, "Product Description",
                  height: 100, maxLines: 4),

              labelText("Description"),

              if (widget.isFoodVendor) ...[
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Select Food Category",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    value: selectedCategory,
                    items: foodCategories
                        .map((cat) =>
                            DropdownMenuItem(value: cat, child: Text(cat)))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedCategory = val;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                addonSideSection("Addons", addons),
                const SizedBox(height: 10),
                addonSideSection("Sides", sides),
              ],

              const SizedBox(height: 40),

              SizedBox(
                width: 250,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: loading ? null : addProduct,
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Add Product",
                          style: TextStyle(color: Colors.white)),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // KEEPING ALL YOUR ORIGINAL METHODS BELOW UNCHANGED

  Widget addonSideSection(String title, List<Map<String, dynamic>> list) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          ...list.asMap().entries.map((entry) {
            int idx = entry.key;
            Map<String, dynamic> item = entry.value;

            return ListTile(
              title: Text("${item['name']}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("₦${item['price']}"),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () {
                      nameController.text = item['name'];
                      priceController.text = item['price'].toString();

                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text("Edit $title"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: nameController,
                                      decoration: InputDecoration(
                                          hintText: "$title Name"),
                                    ),
                                    TextField(
                                      controller: priceController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          hintText: "$title Price"),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Cancel")),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (nameController.text.isEmpty ||
                                          priceController.text.isEmpty) return;
                                      setState(() {
                                        list[idx] = {
                                          "name": nameController.text,
                                          "price": double.tryParse(
                                                  priceController.text) ??
                                              0
                                        };
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Save"),
                                  )
                                ],
                              ));
                    },
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          list.removeAt(idx);
                        });
                      },
                      icon: const Icon(Icons.delete, color: Colors.red)),
                ],
              ),
            );
          }),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(hintText: "$title Name"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: "$title Price"),
                ),
              ),
              IconButton(
                  onPressed: () {
                    if (nameController.text.isEmpty ||
                        priceController.text.isEmpty) return;
                    setState(() {
                      list.add({
                        "name": nameController.text,
                        "price": double.tryParse(priceController.text) ?? 0
                      });
                      nameController.clear();
                      priceController.clear();
                    });
                  },
                  icon: const Icon(Icons.add, color: Colors.green))
            ],
          )
        ],
      ),
    );
  }

  Widget buildInputField(TextEditingController controller, String hint,
      {double height = 40,
      int maxLines = 1,
      TextInputType keyboardType = TextInputType.text}) {
    return Container(
      width: 350,
      height: height,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget labelText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text, style: const TextStyle(fontSize: 13)),
      ),
    );
  }
}

class VendorProductsPage extends StatelessWidget {
  final String vendorId;
  final bool isFoodVendor;
  const VendorProductsPage(
      {super.key, required this.vendorId, required this.isFoodVendor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            '',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Total Products
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .where('vendorId', isEqualTo: vendorId)
                    .snapshots(),
                builder: (context, snapshot) {
                  int total = snapshot.hasData ? snapshot.data!.docs.length : 0;
                  return SizedBox(
                    width: 350,
                    child: Row(
                      children: [
                        const Text("Total Products:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text("$total",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Add Product Button
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddProductPage(
                        vendorId: vendorId,
                        isFoodVendor: isFoodVendor,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  width: 350,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add, color: Colors.deepPurple),
                      SizedBox(width: 10),
                      Text("Add New Product",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Products List
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .where('vendorId', isEqualTo: vendorId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "Error fetching products: ${snapshot.error}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("No products yet"),
                    );
                  }
                  final products = snapshot.data!.docs;
                  return Column(
                    children: products.map((doc) {
                      final data = doc.data()! as Map<String, dynamic>;
                      final name = data['name'] ?? "Unnamed";
                      final price = data['price'] ?? 0;
                      final image = data['image'] ?? "";
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProductPage(
                                productId: doc.id,
                                vendorId: vendorId,
                                isFoodVendor: isFoodVendor,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          height: 65,
                          width: 350,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300],
                                ),
                                child: image.isNotEmpty
                                    ? ClipOval(
                                        child: Image.network(
                                          image,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : const Icon(Icons.image_not_supported,
                                        size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  name,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("₦$price",
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple)),
                                  GestureDetector(
                                    onTap: () async {
                                      await FirebaseFirestore.instance
                                          .collection('products')
                                          .doc(doc.id)
                                          .delete();
                                    },
                                    child: const Text(
                                      "Delete",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

/// ------------- EDIT PRODUCT PAGE ----------------
class EditProductPage extends StatefulWidget {
  final String productId;
  final String vendorId;
  final bool isFoodVendor;

  const EditProductPage({
    super.key,
    required this.productId,
    required this.vendorId,
    required this.isFoodVendor,
  });

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final picker = ImagePicker();
  File? _imageFile;
  Uint8List? _imageBytes;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  String? selectedCategory;
  final List<String> foodCategories = [
    'Drinks',
    'Spaghetti',
    'Rice',
    'Swallow',
    'Shawarma',
    'Pizza',
    'Small Chops',
    'Pastries'
  ];

  List<Map<String, dynamic>> addons = [];
  List<Map<String, dynamic>> sides = [];

  bool loading = false;
  String imageUrl = "";

  @override
  void initState() {
    super.initState();
    loadProductData();
  }

  Future loadProductData() async {
    final doc = await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.productId)
        .get();
    if (!doc.exists) return;
    final data = doc.data()!;
    setState(() {
      nameController.text = data['name'] ?? '';
      priceController.text = data['price']?.toString() ?? '';
      descController.text = data['description'] ?? '';
      imageUrl = data['image'] ?? '';
      if (widget.isFoodVendor) {
        selectedCategory = data['category'];
        addons = List<Map<String, dynamic>>.from(data['addons'] ?? []);
        sides = List<Map<String, dynamic>>.from(data['sides'] ?? []);
      }
    });
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageBytes = bytes;
        });
      } else {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    }
  }

  Future updateProduct() async {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        descController.text.isEmpty ||
        (imageUrl.isEmpty && _imageFile == null && _imageBytes == null)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please fill all fields and add image")));
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      String finalImageUrl = imageUrl;
      if (_imageFile != null || _imageBytes != null) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final ref =
            FirebaseStorage.instance.ref().child("products/$fileName.jpg");
        if (kIsWeb) {
          await ref.putData(_imageBytes!);
        } else {
          await ref.putFile(_imageFile!);
        }
        finalImageUrl = await ref.getDownloadURL();
      }

      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .update({
        "name": nameController.text,
        "price": priceController.text,
        "description": descController.text,
        "image": finalImageUrl,
        "category": widget.isFoodVendor ? selectedCategory : null,
        "addons": widget.isFoodVendor ? addons : [],
        "sides": widget.isFoodVendor ? sides : [],
      });

      setState(() {
        loading = false;
      });
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error updating product: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            'Edit Product',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: _imageBytes != null
                      ? MemoryImage(_imageBytes!)
                      : _imageFile != null
                          ? FileImage(_imageFile!) as ImageProvider
                          : (imageUrl.isNotEmpty
                              ? NetworkImage(imageUrl)
                              : null),
                  child: (_imageBytes == null &&
                          _imageFile == null &&
                          imageUrl.isEmpty)
                      ? const Icon(Icons.add_photo_alternate, size: 35)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Product Name")),
              const SizedBox(height: 10),
              TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Price")),
              const SizedBox(height: 10),
              TextField(
                  controller: descController,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: "Description")),
              const SizedBox(height: 10),
              if (widget.isFoodVendor) ...[
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(labelText: "Category"),
                  items: foodCategories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) {
                    setState(() => selectedCategory = val);
                  },
                ),
                const SizedBox(height: 10),
                AddProductPageStateHelper.addonSideSection(
                    "Addons", addons, setState),
                const SizedBox(height: 10),
                AddProductPageStateHelper.addonSideSection(
                    "Sides", sides, setState),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loading ? null : updateProduct,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper class to reuse addonSideSection logic
class AddProductPageStateHelper {
  static Widget addonSideSection(String title, List<Map<String, dynamic>> list,
      void Function(void Function()) setState) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ...list.asMap().entries.map((entry) {
          int idx = entry.key;
          Map<String, dynamic> item = entry.value;
          return ListTile(
            title: Text(item['name']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("₦${item['price']}"),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange),
                  onPressed: () {
                    nameController.text = item['name'];
                    priceController.text = item['price'].toString();
                    showDialog(
                        context: entry.value as BuildContext,
                        builder: (context) => AlertDialog(
                              title: Text("Edit $title"),
                              content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                        controller: nameController,
                                        decoration: InputDecoration(
                                            hintText: "$title Name")),
                                    TextField(
                                        controller: priceController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            hintText: "$title Price")),
                                  ]),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Cancel")),
                                ElevatedButton(
                                    onPressed: () {
                                      setState(() => list[idx] = {
                                            "name": nameController.text,
                                            "price": double.tryParse(
                                                    priceController.text) ??
                                                0
                                          });
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Save")),
                              ],
                            ));
                  },
                ),
                IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() => list.removeAt(idx));
                    }),
              ],
            ),
          );
        }).toList(),
        Row(
          children: [
            Expanded(
                child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(hintText: "$title Name"))),
            const SizedBox(width: 10),
            Expanded(
                child: TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: "$title Price"))),
            IconButton(
                icon: const Icon(Icons.add, color: Colors.green),
                onPressed: () {
                  if (nameController.text.isEmpty ||
                      priceController.text.isEmpty) return;
                  setState(() => list.add({
                        "name": nameController.text,
                        "price": double.tryParse(priceController.text) ?? 0
                      }));
                  nameController.clear();
                  priceController.clear();
                }),
          ],
        ),
      ],
    );
  }
}

/// ---------------- DYNAMIC ADDON/SIDES EDITOR ----------------
class AddonSidesEditor extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final Function(List<Map<String, dynamic>>) onUpdate;
  const AddonSidesEditor(
      {super.key,
      required this.title,
      required this.items,
      required this.onUpdate});

  @override
  State<AddonSidesEditor> createState() => _AddonSidesEditorState();
}

class _AddonSidesEditorState extends State<AddonSidesEditor> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          onReorder: (oldIndex, newIndex) {
            if (newIndex > oldIndex) newIndex--;
            final item = widget.items.removeAt(oldIndex);
            widget.items.insert(newIndex, item);
            widget.onUpdate(widget.items);
            setState(() {});
          },
          children: [
            for (int i = 0; i < widget.items.length; i++)
              Slidable(
                key: ValueKey(widget.items[i]),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  extentRatio: 0.25,
                  children: [
                    SlidableAction(
                      onPressed: (_) {
                        nameController.text = widget.items[i]['name'];
                        priceController.text =
                            widget.items[i]['price'].toString();
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text("Edit ${widget.title}"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                          controller: nameController,
                                          decoration: InputDecoration(
                                              hintText:
                                                  "${widget.title} Name")),
                                      TextField(
                                          controller: priceController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              hintText:
                                                  "${widget.title} Price")),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("Cancel")),
                                    ElevatedButton(
                                        onPressed: () {
                                          setState(() => widget.items[i] = {
                                                "name": nameController.text,
                                                "price": double.tryParse(
                                                        priceController.text) ??
                                                    0
                                              });
                                          widget.onUpdate(widget.items);
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Save"))
                                  ],
                                ));
                      },
                      backgroundColor: Colors.orange,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                    Slidable(
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        extentRatio: 0.25,
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              // Delete logic here
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: const Text("Your item here"),
                      ),
                    )
                  ],
                ),
                child: ListTile(
                  title: Text(widget.items[i]['name']),
                  trailing: Text("₦${widget.items[i]['price']}"),
                ),
              )
          ],
        ),
        const SizedBox(height: 5),
        Row(children: [
          Expanded(
              child: TextField(
                  controller: nameController,
                  decoration:
                      InputDecoration(hintText: "${widget.title} Name"))),
          const SizedBox(width: 10),
          Expanded(
              child: TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(hintText: "${widget.title} Price"))),
          IconButton(
              icon: const Icon(Icons.add, color: Colors.green),
              onPressed: () {
                if (nameController.text.isEmpty || priceController.text.isEmpty)
                  return;
                setState(() => widget.items.add({
                      "name": nameController.text,
                      "price": double.tryParse(priceController.text) ?? 0
                    }));
                widget.onUpdate(widget.items);
                nameController.clear();
                priceController.clear();
              }),
        ])
      ],
    );
  }
}

class UserActivityPage extends StatefulWidget {
  final String userId;
  UserActivityPage({required this.userId});

  @override
  _UserActivityPageState createState() => _UserActivityPageState();
}

class _UserActivityPageState extends State<UserActivityPage> {
  String selectedFilter = "All";

  List<String> filters = [
    "All",
    "Rides",
    "Logistics",
    "Transport",
    "Shuttle",
    "Orders"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Activities"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(child: _buildFilteredActivities()),
        ],
      ),
    );
  }

  // 🔘 FILTER BAR
  Widget _buildFilters() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          String option = filters[index];
          bool active = selectedFilter == option;

          return GestureDetector(
            onTap: () => setState(() => selectedFilter = option),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 6),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: active ? Colors.black : Colors.grey.shade200,
              ),
              child: Center(
                child: Text(option,
                    style: TextStyle(
                        color: active ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500)),
              ),
            ),
          );
        },
      ),
    );
  }

  // 📌 FETCH + FILTER DATA
  Widget _buildFilteredActivities() {
    return StreamBuilder(
      stream: _fetchActivities(),
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snap) {
        if (!snap.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        var items = snap.data!;
        if (items.isEmpty) {
          return Center(child: Text("No activities yet"));
        }

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, i) => _activityCard(items[i]),
        );
      },
    );
  }

  // 🔐 COMBINED STREAMS
  Stream<List<Map<String, dynamic>>> _fetchActivities() async* {
    List<Map<String, dynamic>> result = [];

    if (selectedFilter == "All" || selectedFilter == "Logistics") {
      var logistics = await FirebaseFirestore.instance
          .collection('logistics_requests')
          .where('senderName', isEqualTo: widget.userId)
          .get();
      result.addAll(logistics.docs
          .map((d) => {'type': 'Logistics', 'data': d.data(), 'id': d.id}));
    }

    if (selectedFilter == "All" || selectedFilter == "Orders") {
      var orders = await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: widget.userId)
          .get();
      result.addAll(orders.docs
          .map((d) => {'type': 'Orders', 'data': d.data(), 'id': d.id}));
    }

    if (selectedFilter == "All" || selectedFilter == "Rides") {
      var rides = await FirebaseFirestore.instance
          .collection('ride_requests')
          .where('userName', isEqualTo: widget.userId)
          .get();
      result.addAll(rides.docs
          .map((d) => {'type': 'Rides', 'data': d.data(), 'id': d.id}));
    }

    if (selectedFilter == "All" || selectedFilter == "Transport") {
      var transport = await FirebaseFirestore.instance
          .collection('transport_requests')
          .where('name', isEqualTo: widget.userId)
          .get();
      result.addAll(transport.docs
          .map((d) => {'type': 'Transport', 'data': d.data(), 'id': d.id}));
    }

    if (selectedFilter == "All" || selectedFilter == "Shuttle") {
      var shuttle = await FirebaseFirestore.instance
          .collection('shuttle_orders')
          .where('userId', isEqualTo: widget.userId)
          .get();
      result.addAll(shuttle.docs
          .map((d) => {'type': 'Shuttle', 'data': d.data(), 'id': d.id}));
    }

    yield result;
  }

  // 🎨 ACTIVITY CARD + TAP NAVIGATION
  Widget _activityCard(Map<String, dynamic> item) {
    var type = item['type'];
    var data = item['data'];
    var id = item['id'];

    return GestureDetector(
      onTap: () => _openDetail(type, id, data),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        padding: EdgeInsets.all(12),
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black12)],
        ),
        child: Row(
          children: [
            _iconForType(type),
            SizedBox(width: 12),
            Expanded(
                child: Text(
              _snippet(type, data),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )),
            Text(data['status']?.toString() ?? "",
                style: TextStyle(fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }

  // 🎭 ICON SELECTION
  Widget _iconForType(String type) {
    IconData icon;
    switch (type) {
      case "Rides":
        icon = Icons.local_taxi;
        break;
      case "Logistics":
        icon = Icons.delivery_dining;
        break;
      case "Transport":
        icon = Icons.directions_bus;
        break;
      case "Shuttle":
        icon = Icons.directions_transit;
        break;
      case "Orders":
        icon = Icons.shopping_bag;
        break;
      default:
        icon = Icons.info;
    }
    return CircleAvatar(
      backgroundColor: Colors.black,
      child: Icon(icon, color: Colors.white),
    );
  }

  // ✂ SNIPPET GENERATOR
  String _snippet(String type, Map<String, dynamic> data) {
    switch (type) {
      case "Rides":
        return "${data['Pickup Location']} ➜ ${data['Destination']}";
      case "Logistics":
        return "${data['packageName']} to ${data['deliveryAddress']}";
      case "Transport":
        return "${data['pickupCity']} ➜ ${data['destinationCity']}";
      case "Shuttle":
        return "${data['pickup']} ➜ ${data['destination']}";
      case "Orders":
        return "Food Order - ₦${data['grandTotal']}";
      default:
        return "Activity";
    }
  }

  // 🔀 TAP NAVIGATION HANDLER
  void _openDetail(String type, String id, Map data) {
    Widget page;

    switch (type) {
      case "Logistics":
        page = LogisticsDetailPage(id: id, data: data);
        break;
      case "Rides":
        page = RideDetailPage(id: id, data: data);
        break;
      case "Orders":
        page = OrderDetailPage(id: id, data: data);
        break;
      case "Transport":
        page = TransportDetailPage(id: id, data: data);
        break;
      case "Shuttle":
        page = ShuttleDetailPage(id: id, data: data);
        break;
      default:
        page = Scaffold(body: Center(child: Text("Unknown")));
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}

// 👇 PLACEHOLDER DETAIL PAGES 👇
class LogisticsDetailPage extends StatelessWidget {
  final String id;
  final Map data;
  LogisticsDetailPage({required this.id, required this.data});
  @override
  Widget build(BuildContext c) => Scaffold(
      appBar: AppBar(title: Text("Logistics Detail")),
      body: Text(data.toString()));
}

class RideDetailPage extends StatelessWidget {
  final String id;
  final Map data;
  RideDetailPage({required this.id, required this.data});
  @override
  Widget build(BuildContext c) => Scaffold(
      appBar: AppBar(title: Text("Ride Detail")), body: Text(data.toString()));
}

class OrderDetailPage extends StatelessWidget {
  final String id;
  final Map data;
  OrderDetailPage({required this.id, required this.data});
  @override
  Widget build(BuildContext c) => Scaffold(
      appBar: AppBar(title: Text("Order Detail")), body: Text(data.toString()));
}

class TransportDetailPage extends StatelessWidget {
  final String id;
  final Map data;
  TransportDetailPage({required this.id, required this.data});
  @override
  Widget build(BuildContext c) => Scaffold(
      appBar: AppBar(title: Text("Transport Detail")),
      body: Text(data.toString()));
}

class ShuttleDetailPage extends StatelessWidget {
  final String id;
  final Map data;
  ShuttleDetailPage({required this.id, required this.data});
  @override
  Widget build(BuildContext c) => Scaffold(
      appBar: AppBar(title: Text("Shuttle Detail")),
      body: Text(data.toString()));
}

const String googleApiKey = "AIzaSyAxmD8Gvtn1KGomBFy3pWXRFgvw0c4a-48";

class DashboardPage extends StatefulWidget {
  final String userName;
  final Function(int) onTabSelected;

  const DashboardPage({
    super.key,
    required this.userName,
    required this.onTabSelected,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String address = "Fetching location...";
  bool isLoadingLocation = true;
  bool locationFailed = false;

  void openMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.6,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              _menuItem(
                icon: 'assets/images/service.png',
                title: 'Become a Driver',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EarnPage()),
                  );
                },
              ),
              _menuItem(
                icon: 'assets/images/customer-service.png',
                title: 'Orders',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserOrdersListPage()),
                  );
                },
              ),
              _menuItem(
                icon: 'assets/images/help.png',
                title: 'Dispatch Riders',
                onTap: () async {
                  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

                  final vendorDoc = await FirebaseFirestore.instance
                      .collection('dispatch_riders')
                      .doc(currentUserId)
                      .get();

                  if (vendorDoc.exists) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DispatchDashboardPage(),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DispatchOnboarding()),
                    );
                  }
                },
              ),
              _menuItem(
                icon: 'assets/images/help.png',
                title: 'Vendors',
                onTap: () async {
                  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

                  final vendorDoc = await FirebaseFirestore.instance
                      .collection('Vendors')
                      .doc(currentUserId)
                      .get();

                  if (vendorDoc.exists) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              VendorDashboardPage(vendorId: currentUserId)),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const VendorOnboardingPage()),
                    );
                  }
                },
              ),
              _menuItem(
                icon: 'assets/images/help.png',
                title: 'Shuttle Drivers',
                onTap: () async {
                  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
                  if (currentUserId == null) return;

                  try {
                    final driverDoc = await FirebaseFirestore.instance
                        .collection('shuttle_drivers')
                        .doc(currentUserId)
                        .get();

                    if (driverDoc.exists) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ShuttleDriverDashboard()),
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ShuttleDriverOnboarding()),
                      );
                    }
                  } catch (e) {
                    print("Error checking shuttle driver doc: $e");
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Error: $e")));
                  }
                },
              ),
              _menuItem(
                icon: 'assets/images/help.png',
                title: 'Providers',
                onTap: () async {
                  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
                  if (currentUserId == null) return;

                  try {
                    final driverDoc = await FirebaseFirestore.instance
                        .collection('providers')
                        .doc(currentUserId)
                        .get();

                    if (driverDoc.exists) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => ProviderHomePage()),
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProviderOnboardingPage()),
                      );
                    }
                  } catch (e) {
                    print("Error checking provider doc: $e");
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Error: $e")));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 ADD THIS STATE
  List<Map<String, dynamic>> products = [];
  bool isLoadingProducts = true;

// 🔥 FETCH PRODUCTS
  Future<void> fetchProducts() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection("products").get();

      setState(() {
        products = snapshot.docs.map((doc) => doc.data()).toList();
        isLoadingProducts = false;
      });
    } catch (e) {
      debugPrint("FETCH PRODUCTS ERROR: $e");
      setState(() => isLoadingProducts = false);
    }
  }

// 🔥 OPEN VENDOR MODAL
  void openVendorModal(Map<String, dynamic> vendor) async {
    final vendorId = vendor["uid"];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.65, // ✅ 65% height
          child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection("products")
                .where("vendorId", isEqualTo: vendorId)
                .get(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final vendorProducts =
                  snapshot.data.docs.map((e) => e.data()).toList();

              // 🔥 RANDOM OPEN/CLOSE (for now)
              bool isOpen = DateTime.now().second % 2 == 0;
              final deliveryTime =
                  10 + (DateTime.now().millisecond % 26); // 10–35 mins
              final rating = (3.5 + (DateTime.now().millisecond % 15) / 10)
                  .toStringAsFixed(1); // 3.5 – 5.0

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    /// HANDLE
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// 🔥 UPDATED VENDOR CARD
                    /// 🔥 UPDATED VENDOR CARD
                    Container(
                      height: 130, // ✅ increased height
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white, // ✅ white background
                        borderRadius: BorderRadius.circular(14),
                        border:
                            Border.all(color: Colors.black), // ✅ black border
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// IMAGE
                          ClipOval(
                            child: Image.network(
                              vendor["profileImageUrl"] ?? "",
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),

                          const SizedBox(width: 12),

                          /// DETAILS
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                /// NAME
                                Text(
                                  vendor["businessName"] ?? "",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                /// LOCATION + STATUS
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        vendor["storeLocation"] ??
                                            "No location",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),

                                    /// STATUS CHIP
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isOpen
                                            ? Colors.green.withOpacity(0.1)
                                            : Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        isOpen ? "Open" : "Closed",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: isOpen
                                              ? Colors.green
                                              : Colors.red,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                /// 🔥 DELIVERY TIME + RATING
                                Row(
                                  children: [
                                    /// DELIVERY TIME
                                    Row(
                                      children: [
                                        Icon(Icons.access_time,
                                            size: 14, color: Colors.grey[600]),
                                        const SizedBox(width: 4),
                                        Text(
                                          "$deliveryTime mins",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(width: 12),

                                    /// RATING
                                    Row(
                                      children: [
                                        const Icon(Icons.star,
                                            size: 14, color: Colors.amber),
                                        const SizedBox(width: 4),
                                        Text(
                                          rating,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    Divider(
                      color: Colors.grey[300],
                      thickness: 1,
                    ),

                    const SizedBox(height: 10),

                    /// PRODUCTS TITLE
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Products",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// PRODUCTS LIST
                    Expanded(
                      child: ListView.builder(
                        itemCount: vendorProducts.length,
                        itemBuilder: (context, index) {
                          final product = vendorProducts[index];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                ClipOval(
                                  child: Image.network(
                                    product["image"] ?? "",
                                    width: 65,
                                    height: 65,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      width: 65,
                                      height: 65,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.image,
                                          color: Colors.grey),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product["name"] ?? "",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        product["description"] ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  "₦${product["price"]}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Position? userPosition;

  List<String> savedAddresses = [];
  bool useCurrentLocation = true;
  bool isSavingAddress = false;
  List<Map<String, dynamic>> vendors = [];
  bool isLoadingVendors = true;
  bool hasShownLocationPopup = false;

  String? selectedState;
  TextEditingController addressInputController = TextEditingController();

  List<String> nigeriaStates = [
    "Abia",
    "Adamawa",
    "Akwa Ibom",
    "Anambra",
    "Bauchi",
    "Bayelsa",
    "Benue",
    "Borno",
    "Cross River",
    "Delta",
    "Ebonyi",
    "Edo",
    "Ekiti",
    "Enugu",
    "Gombe",
    "Imo",
    "Jigawa",
    "Kaduna",
    "Kano",
    "Katsina",
    "Kebbi",
    "Kogi",
    "Kwara",
    "Lagos",
    "Nasarawa",
    "Niger",
    "Ogun",
    "Ondo",
    "Osun",
    "Oyo",
    "Plateau",
    "Rivers",
    "Sokoto",
    "Taraba",
    "Yobe",
    "Zamfara",
    "FCT"
  ];

  @override
  void initState() {
    super.initState();
    loadLocation();
    fetchSavedAddresses();
    fetchVendors();
    fetchVendors();
    fetchProducts();
  }

  // ====================== EXISTING METHODS (Unchanged) ======================
  Future<void> fetchSavedAddresses() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("addresses")
        .get();

    setState(() {
      savedAddresses =
          snapshot.docs.map((doc) => doc["fullAddress"].toString()).toList();
    });
  }

  Future<void> fetchVendors() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection("Vendors").get();

      setState(() {
        vendors = snapshot.docs.map((doc) => doc.data()).toList();
        isLoadingVendors = false;
      });
    } catch (e) {
      debugPrint("FETCH VENDORS ERROR: $e");
      setState(() => isLoadingVendors = false);
    }
  }

  String getCategoryLabel(String category) {
    final cat = category.trim();
    if (cat == "Food Vendor") return "Food";
    if (cat == "Grocery Vendor") return "Grocery";
    if (cat == "Pharmacy") return "Pharma";
    return "Store";
  }

  Future<void> saveAddress(String addr, {String? state}) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception("User not logged in");

      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("addresses")
          .add({
        "state": state ?? "",
        "address": addr,
        "fullAddress": state != null ? "$addr, $state" : addr,
        "createdAt": Timestamp.now(),
      });
    } catch (e) {
      debugPrint("SAVE ADDRESS ERROR: $e");
      rethrow;
    }
  }

  Future<void> loadLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permission denied forever");
      }

      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      userPosition = pos;

      List<Placemark> placemarks =
          await placemarkFromCoordinates(pos.latitude, pos.longitude);

      Placemark place = placemarks[0];

      setState(() {
        address =
            "${place.street ?? ""}, ${place.locality ?? ""}, ${place.country ?? ""}";
        isLoadingLocation = false;
      });
    } catch (e) {
      setState(() {
        address = "Location unavailable";
        isLoadingLocation = false;
        locationFailed = true;
      });

      // 👇 trigger popup AFTER UI builds
      if (!hasShownLocationPopup) {
        hasShownLocationPopup = true;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showLocationPopup();
        });
      }
    }
  }

  void showLocationPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.black12), // border
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Unable to find your accurate location address, please add location manually.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // close popup
                      openLocationModal(); // open your modal
                    },
                    child: const Text(
                      "Add Location",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void openAddLocationForm() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Add Location",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedState,
                    hint: const Text("Select City"),
                    items: nigeriaStates
                        .map((state) =>
                            DropdownMenuItem(value: state, child: Text(state)))
                        .toList(),
                    onChanged: (val) =>
                        setModalState(() => selectedState = val),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: addressInputController,
                    decoration: InputDecoration(
                      hintText: "Enter address",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black),
                      onPressed: isSavingAddress
                          ? null
                          : () async {
                              if (selectedState == null ||
                                  addressInputController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Please fill all fields")));
                                return;
                              }
                              setModalState(() => isSavingAddress = true);
                              try {
                                String full =
                                    "${addressInputController.text}, $selectedState";
                                await saveAddress(addressInputController.text,
                                    state: selectedState);
                                await fetchSavedAddresses();
                                setState(() => address = full);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Failed to save address")));
                              } finally {
                                setModalState(() => isSavingAddress = false);
                              }
                            },
                      child: isSavingAddress
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Text("Add Address",
                              style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void openLocationModal() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Addresses",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: openAddLocationForm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: const [
                          Icon(Icons.add, color: Colors.black),
                          SizedBox(width: 10),
                          Text("Add Location",
                              style: TextStyle(color: Colors.black))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Use my current location",
                          style: TextStyle(color: Colors.grey[500])),
                      Transform.scale(
                        scale: 0.85,
                        child: Switch(
                          value: useCurrentLocation,
                          activeColor: Colors.white,
                          activeTrackColor: Colors.black,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey.shade300,
                          trackOutlineColor:
                              MaterialStateProperty.all(Colors.transparent),
                          onChanged: (val) {
                            setModalState(() => useCurrentLocation = val);
                            if (val && !isLoadingLocation) {
                              Navigator.pop(context);
                            }
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (savedAddresses.isNotEmpty) const Text("Saved Addresses"),
                  ...savedAddresses.map((addr) => ListTile(
                        leading:
                            const Icon(Icons.location_on, color: Colors.black),
                        title: Text(addr),
                        onTap: () {
                          setState(() => address = addr);
                          Navigator.pop(context);
                        },
                      )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ====================== REALISTIC VENDOR CARD SHIMMER ======================
  Widget _buildVendorCardShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image shimmer
            ClipOval(
              child: Container(
                width: 70,
                height: 70,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),

            // Text content shimmer
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 140, height: 14, color: Colors.white),
                  const SizedBox(height: 12),
                  Container(
                      width: 70, height: 22, color: Colors.white), // status box
                ],
              ),
            ),

            // Category tag shimmer
            Container(
              width: 60,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ====================== MAIN UI ======================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ==================== STATIC HEADER (Location + Notification) ====================
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: openLocationModal,
                        child: Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 18, color: Colors.green[500]),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      isLoadingLocation
                                          ? "Fetching location..."
                                          : address,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  const Icon(Icons.keyboard_arrow_down,
                                      size: 18),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => openMenu(context),
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            color: Colors.grey[100], shape: BoxShape.circle),
                        child: const Icon(Icons.notifications_none,
                            color: Colors.black),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text('Hello ,', style: GoogleFonts.caveat(fontSize: 15)),
                    const SizedBox(width: 8),
                    Text('${widget.userName} 👋',
                        style: GoogleFonts.caveat(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                ),
              ],
            ),
          ),

          // ==================== SCROLLABLE CONTENT ====================
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const AutoScrollingBanners(),
                  const SizedBox(height: 10),

                  // Services Grid
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _serviceCard('assets/images/cab (1).png', "Rides",
                          () => widget.onTabSelected(1), Colors.blue),
                      _serviceCard(
                          'assets/images/package (2).png',
                          "Logistics",
                          () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LogisticsPage())),
                          Colors.orange),
                      _serviceCard(
                          'assets/images/shuttle-bus.png',
                          "Transport",
                          () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const TransportPage())),
                          Colors.purple),
                      _serviceCard(
                          'assets/images/delivery-man.png',
                          "Food",
                          () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => FoodSectionPage())),
                          Colors.green),
                      _serviceCard(
                          'assets/images/school-bus.png',
                          "Shuttle",
                          () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ShuttleBookingPage())),
                          Colors.teal),
                      _serviceCard(
                          'assets/images/shopping-cart.png',
                          "Shop",
                          () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const ShoppingSectionPage())),
                          Colors.brown),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Image.asset(icon, width: 24, height: 24),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
    );
  }

  Widget _serviceCard(
      String image, String label, VoidCallback onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, height: 28),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class ProviderOnboardingPage extends StatefulWidget {
  const ProviderOnboardingPage({super.key});

  @override
  State<ProviderOnboardingPage> createState() => _ProviderOnboardingPageState();
}

class _ProviderOnboardingPageState extends State<ProviderOnboardingPage> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();

  String? selectedState;
  File? _image;
  // File? _image;
  Uint8List? _imageData; // for web
  bool isLoading = false;

  final user = FirebaseAuth.instance.currentUser;

  final List<String> nigerianStates = [
    "Abia",
    "Adamawa",
    "Akwa Ibom",
    "Anambra",
    "Bauchi",
    "Bayelsa",
    "Benue",
    "Borno",
    "Cross River",
    "Delta",
    "Ebonyi",
    "Edo",
    "Ekiti",
    "Enugu",
    "FCT",
    "Gombe",
    "Imo",
    "Jigawa",
    "Kaduna",
    "Kano",
    "Katsina",
    "Kebbi",
    "Kogi",
    "Kwara",
    "Lagos",
    "Nasarawa",
    "Niger",
    "Ogun",
    "Ondo",
    "Osun",
    "Oyo",
    "Plateau",
    "Rivers",
    "Sokoto",
    "Taraba",
    "Yobe",
    "Zamfara"
  ];

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      if (kIsWeb) {
        // For Web
        final bytes = await picked.readAsBytes();
        setState(() {
          _imageData = bytes;
        });
      } else {
        // For Mobile
        setState(() {
          _imageData = null; // keep File for mobile if you want
          _image = File(picked.path);
        });
      }
    }
  }

  /// 🔥 Upload Image to Firebase Storage
  Future<String> uploadImage() async {
    final ref = FirebaseStorage.instance
        .ref()
        .child("provider_images")
        .child("${user!.uid}.jpg");

    if (kIsWeb && _imageData != null) {
      await ref.putData(_imageData!);
    } else if (_image != null) {
      await ref.putFile(_image!);
    }

    return await ref.getDownloadURL();
  }

  /// 🔥 Check if provider already exists
  Future<bool> providerExists() async {
    final doc = await FirebaseFirestore.instance
        .collection('providers')
        .doc(user!.uid)
        .get();

    return doc.exists;
  }

  Future<void> submit() async {
    if (_nameController.text.isEmpty ||
        selectedState == null ||
        _locationController.text.isEmpty ||
        (_image == null && _imageData == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Complete all fields + image")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      if (await providerExists()) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const ProviderHomePage(),
          ),
        );
        return;
      }

      final imageUrl = await uploadImage(); // handles web & mobile

      await FirebaseFirestore.instance
          .collection('providers')
          .doc(user!.uid)
          .set({
        "uid": user!.uid,
        "name": _nameController.text.trim(),
        "state": selectedState,
        "location": _locationController.text.trim(),
        "imageUrl": imageUrl,
        "createdAt": Timestamp.now(),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const ProviderHomePage(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            'Onboarding',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// IMAGE
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[200],
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : _imageData != null
                        ? MemoryImage(_imageData!) as ImageProvider
                        : null,
                child: _image == null && _imageData == null
                    ? const Icon(Icons.camera_alt, size: 30)
                    : null,
              ),
            ),

            const SizedBox(height: 20),

            /// NAME
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Provider Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// STATE
            DropdownButtonFormField<String>(
              value: selectedState,
              hint: const Text("Select State"),
              items: nigerianStates.map((state) {
                return DropdownMenuItem(
                  value: state,
                  child: Text(state),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => selectedState = value);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// LOCATION
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: "Location",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProviderHomePage extends StatefulWidget {
  const ProviderHomePage({super.key});

  @override
  State<ProviderHomePage> createState() => _ProviderHomePageState();
}

class _ProviderHomePageState extends State<ProviderHomePage> {
  final user = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot> getProvider() async {
    return await FirebaseFirestore.instance
        .collection('providers')
        .doc(user!.uid)
        .get();
  }

  Widget buildStatCard(String title, String value) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontSize: 13)),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget buildMenuButton(String title, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 15)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: getProvider(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data.data();

          if (data == null) {
            return const Center(child: Text("No provider data found"));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// 🔥 MAIN CARD
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ROW 1 → IMAGE + NAME
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(data['imageUrl']),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              data['name'] ?? "No Name",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      /// ROW 2 → BALANCE + TICKETS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildStatCard("Balance", "₦0"),
                          buildStatCard("Tickets", "0"),
                        ],
                      ),

                      const SizedBox(height: 15),

                      /// ROW 3 → BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("Manage Profile"),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔥 MENU BUTTONS
                buildMenuButton("Manage Routes", "0", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ManageRoutesPage()),
                  );
                }),
                buildMenuButton("Transaction History", "-", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const TransactionHistoryPage()),
                  );
                }),
                buildMenuButton("Manage Tickets", "0", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ManageTicketsPage()),
                  );
                }),
                buildMenuButton("Manage Vehicles", "0", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ManageVehiclesPage()),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ManageRoutesPage extends StatelessWidget {
  const ManageRoutesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final routesStream = FirebaseFirestore.instance
        .collection('routes')
        .where('providerId', isEqualTo: user!.uid)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            'Manage Routes',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: routesStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final routes = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// 🔥 TOP CARDS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// TOTAL ROUTES CARD
                    Container(
                      height: 120,
                      width: MediaQuery.of(context).size.width * 0.42,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Total Routes"),
                          const SizedBox(height: 10),
                          Text(
                            routes.length.toString(),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// ADD ROUTE CARD (MODAL NOW)
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (_) => const AddRouteBottomSheet(),
                        );
                      },
                      child: Container(
                        height: 120,
                        width: MediaQuery.of(context).size.width * 0.42,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("Add Route"),
                            SizedBox(height: 10),
                            Icon(Icons.add, size: 30),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// 🔥 ROUTES LIST
                Expanded(
                  child: routes.isEmpty
                      ? const Center(child: Text("No routes added yet 🚏"))
                      : ListView.builder(
                          itemCount: routes.length,
                          itemBuilder: (context, index) {
                            final route = routes[index];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// FROM → TO
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, size: 18),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          "${route['from']} → ${route['to']}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),

                                  /// PRICE
                                  Row(
                                    children: [
                                      const Icon(Icons.attach_money, size: 18),
                                      const SizedBox(width: 6),
                                      Text("₦${route['price']}"),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// 🔥 MODAL BOTTOM SHEET
class AddRouteBottomSheet extends StatefulWidget {
  const AddRouteBottomSheet({super.key});

  @override
  State<AddRouteBottomSheet> createState() => _AddRouteBottomSheetState();
}

class _AddRouteBottomSheetState extends State<AddRouteBottomSheet> {
  final user = FirebaseAuth.instance.currentUser;

  String? fromState;
  String? toState;

  final distanceController = TextEditingController();
  final timeController = TextEditingController();
  final priceController = TextEditingController();

  bool isLoading = false;

  final List<String> states = [
    "Abia",
    "Adamawa",
    "Akwa Ibom",
    "Anambra",
    "Bauchi",
    "Bayelsa",
    "Benue",
    "Borno",
    "Cross River",
    "Delta",
    "Ebonyi",
    "Edo",
    "Ekiti",
    "Enugu",
    "FCT",
    "Gombe",
    "Imo",
    "Jigawa",
    "Kaduna",
    "Kano",
    "Katsina",
    "Kebbi",
    "Kogi",
    "Kwara",
    "Lagos",
    "Nasarawa",
    "Niger",
    "Ogun",
    "Ondo",
    "Osun",
    "Oyo",
    "Plateau",
    "Rivers",
    "Sokoto",
    "Taraba",
    "Yobe",
    "Zamfara"
  ];

  Future<void> submit() async {
    if (fromState == null ||
        toState == null ||
        distanceController.text.isEmpty ||
        timeController.text.isEmpty ||
        priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Complete all fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('routes').add({
        "providerId": user!.uid,
        "from": fromState,
        "to": toState,
        "distance": distanceController.text.trim(),
        "travelTime": timeController.text.trim(),
        "price": priceController.text.trim(),
        "createdAt": Timestamp.now(),
      });

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final filteredStates = states.where((s) => s != fromState).toList();

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "Add New Route",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            /// FROM
            DropdownButtonFormField<String>(
              value: fromState,
              hint: const Text("From (State)"),
              items: states.map((state) {
                return DropdownMenuItem(
                  value: state,
                  child: Text(state),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  fromState = value;
                  toState = null;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// TO
            DropdownButtonFormField<String>(
              value: toState,
              hint: const Text("To (State)"),
              items: filteredStates.map((state) {
                return DropdownMenuItem(
                  value: state,
                  child: Text(state),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => toState = value);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// DISTANCE
            TextField(
              controller: distanceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Distance (km)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// TIME
            TextField(
              controller: timeController,
              decoration: InputDecoration(
                labelText: "Travel Time",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// PRICE
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Price (₦)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Add Route"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            'Transaction History',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: const Center(
        child: Text("Transaction history coming soon 💳"),
      ),
    );
  }
}

class ManageTicketsPage extends StatelessWidget {
  const ManageTicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            'Manage Tickets',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: const Center(
        child: Text("Tickets management coming soon 🎟"),
      ),
    );
  }
}

class ManageVehiclesPage extends StatelessWidget {
  const ManageVehiclesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            'Manage Vehicles',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: const Center(
        child: Text("Vehicle management coming soon 🚗"),
      ),
    );
  }
}

class TransportPage extends StatefulWidget {
  const TransportPage({super.key});

  @override
  State<TransportPage> createState() => _TransportPageState();
}

class _TransportPageState extends State<TransportPage> {
  String? fromState;
  String? toState;

  final List<String> states = [
    "Abia",
    "Adamawa",
    "Akwa Ibom",
    "Anambra",
    "Bauchi",
    "Bayelsa",
    "Benue",
    "Borno",
    "Cross River",
    "Delta",
    "Ebonyi",
    "Edo",
    "Ekiti",
    "Enugu",
    "FCT",
    "Gombe",
    "Imo",
    "Jigawa",
    "Kaduna",
    "Kano",
    "Katsina",
    "Kebbi",
    "Kogi",
    "Kwara",
    "Lagos",
    "Nasarawa",
    "Niger",
    "Ogun",
    "Ondo",
    "Osun",
    "Oyo",
    "Plateau",
    "Rivers",
    "Sokoto",
    "Taraba",
    "Yobe",
    "Zamfara"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            'Transport',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔍 SEARCH BAR
            Center(
              child: Container(
                height: 50,
                width: 350,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Search providers",
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// SERVICE CARDS
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _openMassTransitModal,
                    child: _serviceCard(
                      icon: Image.asset(
                        'assets/images/bus.png',
                        width: 26,
                        height: 26,
                        fit: BoxFit.contain,
                      ),
                      title: "Mass Transit",
                      subtitle: "Book intercity bus transits.",
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _serviceCard(
                    icon: Image.asset(
                      'assets/images/plane.png',
                      width: 26,
                      height: 26,
                      fit: BoxFit.contain,
                    ),
                    title: "Flights",
                    subtitle: "Book flight tickets.",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            /// 🔥 PROVIDERS
            const Text(
              "Explore Providers",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 130,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('providers')
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final providers = snapshot.data.docs;

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: providers.length,
                    itemBuilder: (context, index) {
                      final p = providers[index];

                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => _openProviderModal(p),
                        child: Container(
                          width: 300,
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(p['imageUrl']),
                              ),
                              const SizedBox(width: 10),

                              /// NAME + LOCATION
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      p['name'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(p['location']),
                                  ],
                                ),
                              ),

                              /// STATE BADGE
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(p['state']),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Recents",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 12),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('transport_tickets')
                  .where('userId',
                      isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  // .orderBy('createdAt', descending: true)
                  .limit(10)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("No recent tickets yet"),
                  );
                }

                return Column(
                  children: docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;

                    final from = data['from'] ?? 'Unknown';
                    final to = data['to'] ?? 'Unknown';
                    final price = data['price'] ?? 0;
                    final provider = data['providerName'] ?? 'Provider';
                    final location = data['providerLocation'] ?? '';
                    final status = data['status'] ?? 'pending';
                    final ticketId = data['ticketId'] ?? '';

                    final departure = data['departure'] as Timestamp?;
                    final createdAt = data['createdAt'] as Timestamp?;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        // border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// TOP ROW (route + status)
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Icon(
                                  Icons.directions_bus,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "$from → $to",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      provider,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: status == "valid"
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  status.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: status == "valid"
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          /// SECOND ROW (details)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "₦$price",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "ID: $ticketId",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          /// FOOTER (dates)
                          Row(
                            children: [
                              Icon(Icons.schedule,
                                  size: 14, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                departure != null
                                    ? "Dep: ${DateTime.fromMillisecondsSinceEpoch(departure.millisecondsSinceEpoch).toString().split('.')[0]}"
                                    : "No departure",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _serviceCard({
    required Widget icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      height: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ICON + TITLE
          Row(
            children: [
              /// 🌈 Gradient Circular Icon
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[50],
                ),
                child: Center(
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: icon,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),

          /// ⬇️ spacing pushes description lower
          const SizedBox(height: 20),

          /// DESCRIPTION
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12.5,
              height: 1.4,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _openProviderModal(dynamic provider) async {
    final providerId = provider.id;

    /// 🔥 Fetch ALL routes for this provider
    final routesSnap = await FirebaseFirestore.instance
        .collection('routes')
        .where('providerId', isEqualTo: providerId)
        .get();

    final routes = routesSnap.docs;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, controller) => Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            controller: controller,
            children: [
              /// 🔹 HANDLE
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// 🔹 PROVIDER INFO CARD
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(provider['imageUrl']),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            provider['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            provider['location'],
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// 🔹 ROUTES TITLE
              const Text(
                "Routes",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 12),

              /// 🔥 ROUTES LIST (CLICKABLE)
              ...routes.map((r) {
                final data = r.data();

                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.pop(context); // close modal

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TicketBookingPage(
                          routeData: r,
                          providerData: provider,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// ROUTE INFO
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${data['from']} → ${data['to']}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Tap to book",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),

                        /// PRICE
                        Text(
                          "₦${data['price']}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),

              /// 🔥 EMPTY STATE
              if (routes.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text("No routes available"),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🚀 STEP 1 MODAL
  void _openMassTransitModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// HANDLE
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Select Route",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔵 FROM BUTTON
                _stateSelector(
                  label: "From",
                  value: fromState,
                  onTap: () async {
                    final result = await _openStatePicker(states);
                    if (result != null) {
                      setState(() {
                        fromState = result;
                        toState = null;
                      });
                    }
                  },
                ),

                const SizedBox(height: 12),

                /// 🔵 TO BUTTON
                _stateSelector(
                  label: "To",
                  value: toState,
                  onTap: () async {
                    final filtered =
                        states.where((s) => s != fromState).toList();

                    final result = await _openStatePicker(filtered);
                    if (result != null) {
                      setState(() {
                        toState = result;
                      });
                    }
                  },
                ),

                const SizedBox(height: 20),

                /// SEARCH BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.all(14),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _openResultsModal();
                    },
                    child: const Text(
                      "Search Providers",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _stateSelector({
    required String label,
    required String? value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                value ?? "",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: value == null ? Colors.grey : Colors.black,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }

  Future<String?> _openStatePicker(List<String> list) async {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final state = list[index];

            return ListTile(
              title: Text(state),
              onTap: () => Navigator.pop(context, state),
            );
          },
        );
      },
    );
  }

  void _openResultsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "$fromState → $toState",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Available Providers",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('routes')
                      .where('from', isEqualTo: fromState)
                      .where('to', isEqualTo: toState)
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final routes = snapshot.data.docs;

                    if (routes.isEmpty) {
                      return const Center(
                          child: Text("No providers available"));
                    }

                    final providerIds = routes
                        .map((r) => r['providerId'] as String)
                        .toSet()
                        .toList();

                    return FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('providers')
                          .where(FieldPath.documentId, whereIn: providerIds)
                          .get(),
                      builder: (context, AsyncSnapshot providersSnap) {
                        if (!providersSnap.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final providersMap = {
                          for (var doc in providersSnap.data!.docs) doc.id: doc
                        };

                        return ListView.builder(
                          controller: scrollController,
                          itemCount: routes.length,
                          itemBuilder: (context, index) {
                            final r = routes[index];
                            final provider = providersMap[r['providerId']];

                            if (provider == null) return const SizedBox();

                            return GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TicketBookingPage(
                                      routeData: r,
                                      providerData: provider,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    )
                                  ],
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 28,
                                      backgroundImage:
                                          NetworkImage(provider['imageUrl']),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            provider['name'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "${r['from']} → ${r['to']}",
                                            style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.green.withOpacity(0.1),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        "₦${r['price']}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TransportTicketsPage extends StatefulWidget {
  const TransportTicketsPage({super.key});

  @override
  State<TransportTicketsPage> createState() => _TransportTicketsPageState();
}

class _TransportTicketsPageState extends State<TransportTicketsPage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Please log in to view your tickets.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Transport Tickets',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("transport_tickets")
              .where("userId", isEqualTo: user!.uid)
              //.orderBy("createdAt", descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final tickets = snapshot.data.docs;

            if (tickets.isEmpty) {
              return const Center(child: Text("No tickets booked yet."));
            }

            return ListView.builder(
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                final departure = ticket['departure'] != null
                    ? (ticket['departure'] as Timestamp).toDate()
                    : null;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      )
                    ],
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// PROVIDER
                      Row(
                        children: [
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              ticket['providerName'] ?? "Provider",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "₦${ticket['price']}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      /// ROUTE
                      Text(
                        "${ticket['from']} → ${ticket['to']}",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700),
                      ),

                      if (departure != null)
                        Text(
                          "Departure: ${departure.toLocal()}",
                          style: const TextStyle(color: Colors.black87),
                        ),
                      const SizedBox(height: 6),

                      /// TICKET COUNT
                      Text("Tickets: ${ticket['ticketCount']}"),

                      /// STATUS
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: ticket['status'] == "valid"
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          ticket['status'] ?? "Unknown",
                          style: TextStyle(
                              color: ticket['status'] == "valid"
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class TicketBookingPage extends StatefulWidget {
  final dynamic routeData;
  final dynamic providerData;

  const TicketBookingPage({
    required this.routeData,
    required this.providerData,
    super.key,
  });

  @override
  _TicketBookingPageState createState() => _TicketBookingPageState();
}

class _TicketBookingPageState extends State<TicketBookingPage> {
  DateTime? departureDateTime;
  int ticketCount = 1;

  double get totalPrice =>
      ticketCount * double.parse(widget.routeData['price']);

  bool loading = false;

  Future<void> _selectDepartureDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    setState(() {
      departureDateTime =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _payWithPaystack() async {
    if (departureDateTime == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Select departure time")));
      return;
    }

    final user = FirebaseAuth.instance.currentUser!;
    setState(() => loading = true);

    try {
      const String paystackSecretKey =
          'sk_test_661490bf9dc0914e122c2c043ab3aaf3a307d658';

      final int amount = (totalPrice * 100).toInt(); // in kobo
      final String reference =
          "transport_${DateTime.now().millisecondsSinceEpoch}";

      final response = await http.post(
        Uri.parse('https://api.paystack.co/transaction/initialize'),
        headers: {
          'Authorization': 'Bearer $paystackSecretKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': user.email,
          'amount': amount,
          'reference': reference,
        }),
      );

      if (response.statusCode != 200) throw "Unable to initialize payment";

      final data = jsonDecode(response.body);
      final checkoutUrl = data['data']['authorization_url'];

      if (!await canLaunchUrl(Uri.parse(checkoutUrl))) {
        throw "Could not launch payment page";
      }

      await launchUrl(Uri.parse(checkoutUrl),
          mode: LaunchMode.externalApplication);

      // Save ticket after payment (temporary assume success)
      await _saveTicket(reference);

      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Payment successful")));

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => TransportTicketsPage()),
          (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Payment failed: $e")));
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _saveTicket(String reference) async {
    final user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance.collection("transport_tickets").add({
      "ticketId": "TR${Random().nextInt(90000) + 10000}",
      "providerId": widget.providerData.id,
      "providerName": widget.providerData['name'],
      "providerLocation": widget.providerData['location'],
      "from": widget.routeData['from'],
      "to": widget.routeData['to'],
      "departure": departureDateTime,
      "ticketCount": ticketCount,
      "price": totalPrice,
      "status": "valid",
      "userId": user.uid,
      "createdAt": FieldValue.serverTimestamp(),
      "paymentReference": reference,
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = widget.providerData;
    final route = widget.routeData;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            'Book Ticket',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// FROM → TO CARDS WITH LINE
            Column(
              children: [
                _locationCard(route['from'], top: true),
                _locationLine(),
                _locationCard(route['to'], top: false),
              ],
            ),
            const SizedBox(height: 20),

            /// Departure time
            GestureDetector(
              onTap: _selectDepartureDateTime,
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: departureDateTime == null
                        ? "Select Departure Time"
                        : departureDateTime.toString(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    suffixIcon: const Icon(Icons.calendar_month),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// Provider card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3))
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(provider['imageUrl']),
                  ),
                  const SizedBox(width: 12),
                  Text(provider['name'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 12),

            /// Visit branch card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12)),
              child: Text(
                "Visit our branch at: ${provider['location']}\n to board.",
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 20),

            /// Tickets selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Number of tickets",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (ticketCount > 1) setState(() => ticketCount--);
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text("$ticketCount", style: const TextStyle(fontSize: 16)),
                    IconButton(
                      onPressed: () => setState(() => ticketCount++),
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            /// Price card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12)),
              child: Text(
                "₦${totalPrice.toStringAsFixed(0)}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.green),
              ),
            ),
            const SizedBox(height: 20),

            /// Book button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: loading ? null : _payWithPaystack,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Book Ticket"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _locationCard(String location, {bool top = true}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: Colors.black,
            child: const Icon(Icons.location_on, size: 14, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Text(location, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _locationLine() {
    return Container(
      height: 20,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: 2,
      color: Colors.black26,
    );
  }
}

class AdminInstitutionsPage extends StatefulWidget {
  @override
  _AdminInstitutionsPageState createState() => _AdminInstitutionsPageState();
}

class _AdminInstitutionsPageState extends State<AdminInstitutionsPage> {
  TextEditingController institutionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  List<String> locations = [];
  bool loading = false;

  void addLocation() {
    final loc = locationController.text.trim();
    if (loc.isNotEmpty && !locations.contains(loc)) {
      setState(() {
        locations.add(loc);
        locationController.clear();
      });
    }
  }

  void saveInstitution() async {
    final name = institutionController.text.trim();
    final price = double.tryParse(priceController.text.trim());

    if (name.isEmpty || locations.isEmpty || price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Please enter institution, price and locations")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      await FirebaseFirestore.instance.collection("institutions").add({
        "name": name,
        "price": price,
        "locations": locations,
        "createdAt": FieldValue.serverTimestamp(),
      });

      setState(() {
        loading = false;
        institutionController.clear();
        priceController.clear();
        locations.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Institution added successfully")),
      );
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            '',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: institutionController,
              decoration: InputDecoration(
                labelText: "Institution Name",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Shuttle Price",
                prefixText: "₦ ",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: locationController,
                    decoration: InputDecoration(
                      labelText: "Add Pickup/Destination Point",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: addLocation,
                  child: Text("Add"),
                ),
              ],
            ),
            SizedBox(height: 15),
            Wrap(
              spacing: 8,
              children: locations
                  .map((loc) => Chip(
                        label: Text(loc),
                        onDeleted: () {
                          setState(() {
                            locations.remove(loc);
                          });
                        },
                      ))
                  .toList(),
            ),
            SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.black,
              ),
              onPressed: loading ? null : saveInstitution,
              child: loading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Save Institution"),
            ),
          ],
        ),
      ),
    );
  }
}

class ShuttleBookingPage extends StatefulWidget {
  const ShuttleBookingPage({super.key});

  @override
  State<ShuttleBookingPage> createState() => _ShuttleBookingPageState();
}

class _ShuttleBookingPageState extends State<ShuttleBookingPage> {
  final TextEditingController _searchController = TextEditingController();

  // ─────────────────────────────────────────────
  //  INSTITUTIONS MODAL
  // ─────────────────────────────────────────────
  void _openInstitutionsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Select Institution",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('institutions')
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _institutionShimmer();
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                            child: Text("No institutions found."));
                      }

                      final institutions = snapshot.data!.docs;

                      return ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: institutions.length,
                        itemBuilder: (context, index) {
                          final data = institutions[index].data()
                              as Map<String, dynamic>;
                          final name = data['name'] ?? 'Unknown';
                          final locations =
                              List<String>.from(data['locations'] ?? []);

                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              _openDriversModal(name);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.grey.shade200),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.school_rounded,
                                      color: Colors.blue,
                                      size: 26,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        if (locations.isNotEmpty) ...[
                                          const SizedBox(height: 6),
                                          Wrap(
                                            spacing: 6,
                                            runSpacing: 4,
                                            children: locations
                                                .map(
                                                  (loc) => Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8,
                                                        vertical: 3),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[100],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Text(
                                                      loc,
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.grey[700],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 14,
                                    color: Colors.grey,
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
            );
          },
        );
      },
    );
  }

  // ─────────────────────────────────────────────
  //  DRIVERS MODAL
  // ─────────────────────────────────────────────
  void _openDriversModal(String institutionName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 12),

                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 16),

                /// HEADER
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          _openInstitutionsModal();
                        },
                        child: const Icon(CupertinoIcons.back, size: 22),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          institutionName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Available Drivers",
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                /// 🔥 STREAM BUILDER (FIXED)
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('shuttle_drivers')
                        .where('activeInstitution', isEqualTo: institutionName)
                        .where('status', isEqualTo: 'online')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _driverShimmer();
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            "No active shuttles",
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        );
                      }

                      final drivers = snapshot.data!.docs;

                      return ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: drivers.length,
                        itemBuilder: (context, index) {
                          final doc = drivers[index];
                          final data = doc.data() as Map<String, dynamic>;

                          /// 🔥 IMPORTANT: attach doc ID
                          data['id'] = doc.id;

                          final vehicleImage = data['vehicleImage'] ?? '';
                          final vehicleName = data['vehicleName'] ?? '';
                          final driverCode = data['driverCode'] ?? '';
                          final vehicleCapacity = data['vehicleCapacity'] ?? 0;
                          final boardedPassengers =
                              data['boardedPassengers'] ?? 0;

                          final seatsLeft = vehicleCapacity - boardedPassengers;
                          final safeSeats = seatsLeft < 0 ? 0 : seatsLeft;
                          final isFull = safeSeats <= 0;

                          return _driverCard(
                            data: data,
                            vehicleImage: vehicleImage,
                            vehicleName: vehicleName,
                            driverCode: driverCode,
                            vehicleCapacity: vehicleCapacity,
                            boardedPassengers: boardedPassengers,
                            seatsLeft: safeSeats,
                            isFull: isFull,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _avatarFallback() {
    return Container(
      width: 52,
      height: 52,
      color: Colors.grey[200],
      child: const Icon(Icons.person, color: Colors.grey),
    );
  }

  Widget _infoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _driverCard({
    required Map<String, dynamic> data,
    required String vehicleImage,
    required String vehicleName,
    required String driverCode,
    required int vehicleCapacity,
    required int boardedPassengers,
    required int seatsLeft,
    required bool isFull,
  }) {
    return GestureDetector(
      onTap: (!isFull)
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ShuttlePaymentPage(driverData: data),
                ),
              );
            }
          : null,
      child: Container(
        height: 70,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            /// 🚐 Vehicle Image
            ClipOval(
              child: vehicleImage.isNotEmpty
                  ? Image.network(
                      vehicleImage,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 48,
                      height: 48,
                      color: Colors.grey[200],
                      child: const Icon(Icons.directions_bus),
                    ),
            ),

            const SizedBox(width: 10),

            /// INFO
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$driverCode • $vehicleName",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "$boardedPassengers/$vehicleCapacity",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isFull ? "Full" : "Seats: $seatsLeft",
                        style: TextStyle(
                          fontSize: 11,
                          color: isFull ? Colors.red : Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// PRICE / FULL
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isFull ? Colors.grey : Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isFull ? "Full" : "₦${data['price'] ?? 0}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Padding(
            padding: EdgeInsets.only(left: 8),
            child: Icon(
              CupertinoIcons.back,
              color: Colors.black,
              size: 26,
            ),
          ),
        ),
        title: const Text(
          "Shuttle",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Search Bar ──────────────────────
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search shuttles",
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  prefixIcon:
                      Icon(Icons.search, color: Colors.grey[400], size: 20),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "What are you looking for?",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // ── Two Category Cards ───────────────
            Row(
              children: [
                GestureDetector(
                  onTap: _openInstitutionsModal,
                  child: _categoryCard(
                    icon: Icons.directions_bus_rounded,
                    iconColor: Colors.blue,
                    bgColor: Colors.blue.withOpacity(0.08),
                    title: "Shuttle",
                    description: "Book shuttle bus tickets",
                  ),
                ),
                const SizedBox(width: 14),
                GestureDetector(
                  onTap: () {
                    // TODO: Commute flow
                  },
                  child: _categoryCard(
                    icon: Icons.commute_rounded,
                    iconColor: Colors.teal,
                    bgColor: Colors.teal.withOpacity(0.08),
                    title: "Commute",
                    description: "Book shuttle tickets in your city",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String description,
  }) {
    return Container(
      height: 130,
      width: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style:
                TextStyle(fontSize: 10, color: Colors.grey[500], height: 1.4),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _shimmerBox({double height = 16, double width = double.infinity}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _institutionShimmer() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        child: Row(
          children: [
            _shimmerBox(height: 50, width: 50),
            const SizedBox(width: 12),
            Expanded(child: _shimmerBox(height: 14)),
          ],
        ),
      ),
    );
  }

  Widget _driverShimmer() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        child: Container(
          height: 70,
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              _shimmerBox(height: 50, width: 50),
              const SizedBox(width: 10),
              Expanded(child: _shimmerBox(height: 14)),
              const SizedBox(width: 10),
              _shimmerBox(height: 20, width: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class MyTicketsPage extends StatefulWidget {
  const MyTicketsPage({Key? key}) : super(key: key);

  @override
  _MyTicketsPageState createState() => _MyTicketsPageState();
}

class _MyTicketsPageState extends State<MyTicketsPage> {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  /// SHIMMER TICKET
  Widget _shimmerTicket() {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      child: Stack(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Positioned(
            left: -12,
            top: 45,
            child: Container(
              height: 24,
              width: 24,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: -12,
            top: 45,
            child: Container(
              height: 24,
              width: 24,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text("You are not logged in.")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            'Shuttle Tickets',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("shuttle_tickets")
            .where("userId", isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          /// SHIMMER LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 6,
              itemBuilder: (_, __) => _shimmerTicket(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No tickets booked yet."));
          }

          final tickets = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final doc = tickets[index];
              final data = doc.data() as Map<String, dynamic>;

              final ticketId = data["ticketId"] ?? "N/A";
              final status = data["status"] ?? "pending";
              final price = data["price"] ?? 0.0;
              final timestamp = data["createdAt"] as Timestamp?;
              final date = timestamp != null
                  ? DateFormat('dd MMM, hh:mm a').format(timestamp.toDate())
                  : "Unknown";

              Color statusColor = status == "used"
                  ? Colors.grey
                  : status == "paid"
                      ? Colors.green
                      : Colors.orange;

              return InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ShuttleTicketDetailsPage(ticketDoc: doc),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  child: Stack(
                    children: [
                      /// MAIN CARD
                      Container(
                        height: 120,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Colors.white,
                              Colors.amberAccent,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            /// TOP ROW
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Ticket ID: $ticketId",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      date,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      status.toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: statusColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            /// PRICE
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "₦${price.toString()}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// LEFT CUTOUT
                      Positioned(
                        left: -12,
                        top: 45,
                        child: Container(
                          height: 24,
                          width: 24,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),

                      /// RIGHT CUTOUT
                      Positioned(
                        right: -12,
                        top: 45,
                        child: Container(
                          height: 24,
                          width: 24,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
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
    );
  }
}

class ShuttleTicketDetailsPage extends StatefulWidget {
  final QueryDocumentSnapshot ticketDoc;

  const ShuttleTicketDetailsPage({Key? key, required this.ticketDoc})
      : super(key: key);

  @override
  State<ShuttleTicketDetailsPage> createState() =>
      _ShuttleTicketDetailsPageState();
}

class _ShuttleTicketDetailsPageState extends State<ShuttleTicketDetailsPage> {
  bool boarding = false;
  Map<String, dynamic>? driverData;
  DateTime? boardedAt;

  Stream<DocumentSnapshot>? driverStream;

  @override
  void initState() {
    super.initState();
    _setupDriverListener();
  }

  void _setupDriverListener() async {
    final ticketData = widget.ticketDoc.data() as Map<String, dynamic>;
    final driverCode = ticketData['driverCode'];

    if (driverCode != null && driverCode.isNotEmpty) {
      final query = await FirebaseFirestore.instance
          .collection("shuttle_drivers")
          .where("driverCode", isEqualTo: driverCode)
          .get();

      if (query.docs.isNotEmpty) {
        final driverDoc = query.docs.first;

        driverStream = FirebaseFirestore.instance
            .collection("shuttle_drivers")
            .doc(driverDoc.id)
            .snapshots();

        driverStream!.listen((snapshot) {
          if (!snapshot.exists) return;

          setState(() {
            driverData = snapshot.data() as Map<String, dynamic>?;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.ticketDoc.data() as Map<String, dynamic>;

    final institution = data["institution"];
    final pickup = data["pickup"];
    final destination = data["destination"];
    final price = data["price"];
    final ticketId = data["ticketId"];
    final status = data["status"];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            '',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🎫 TICKET CARD WITH CUTOUT
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.amberAccent,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "$institution Shuttle",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text("From"),
                      const SizedBox(height: 6),
                      _infoBox(pickup),
                      const SizedBox(height: 12),
                      const Text("To"),
                      const SizedBox(height: 6),
                      _infoBox(destination),
                      const SizedBox(height: 12),
                      _infoBox("₦$price", highlight: true),
                      const SizedBox(height: 12),
                      _infoBox("Ticket ID: $ticketId", highlight: true),
                    ],
                  ),
                ),

                /// LEFT CUT
                Positioned(
                  left: -14,
                  top: 90,
                  child: Container(
                    height: 28,
                    width: 28,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                /// RIGHT CUT
                Positioned(
                  right: -14,
                  top: 90,
                  child: Container(
                    height: 28,
                    width: 28,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// DRIVER CARD (unchanged logic, improved UI)

            if (driverData != null)
              Card(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Driver & Bus Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage:
                                NetworkImage(driverData!['driverImage']),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                driverData!['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(driverData!['vehicleName']),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Boarded: ${driverData!['boardedPassengers']} / ${driverData!['vehicleCapacity']}",
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Amount Collected: ₦${driverData!['amountCollected']}",
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 30),

            /// BOARD BUTTON

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed:
                    status == "used" || boarding ? null : _handleBoarding,
                child: boarding
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Board",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoBox(String text, {bool highlight = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: highlight ? Colors.white : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
          )
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  /// 🚀 UPDATED BOARDING DIALOG

  Future<void> _handleBoarding() async {
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Enter Shuttle Code",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),

              const SizedBox(height: 20),

              /// CODE FIELD

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                    )
                  ],
                ),
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter shuttle code",
                  ),
                ),
              ),

              const SizedBox(height: 15),

              /// SCAN QR BUTTON

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    "Scan QR",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// CONFIRM BUTTON

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () =>
                      Navigator.pop(context, controller.text.trim()),
                  child: const Text(
                    "Confirm",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );

    if (result == null || result.isEmpty) return;

    /// KEEP YOUR EXISTING BOARDING LOGIC

    setState(() => boarding = false);

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Boarding logic continues")));
  }
}

class ShuttlePaymentPage extends StatefulWidget {
  final Map<String, dynamic> driverData;

  const ShuttlePaymentPage({
    super.key,
    required this.driverData,
  });

  @override
  State<ShuttlePaymentPage> createState() => _ShuttlePaymentPageState();
}

class _ShuttlePaymentPageState extends State<ShuttlePaymentPage> {
  bool loading = false;

  late String institution;
  late String pickup;
  late String destination;
  late int price;
  late String driverId;

  @override
  void initState() {
    super.initState();

    final data = widget.driverData;

    institution = data['activeInstitution'] ?? '';
    pickup = data['pickupLocation'] ?? '';
    destination = data['destinationLocation'] ?? '';
    price = (data['price'] ?? 0);
    driverId = data['id'] ?? '';
  }

  Future<void> _payWithPaystack() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => loading = true);

    try {
      const String paystackSecretKey =
          'sk_test_661490bf9dc0914e122c2c043ab3aaf3a307d658';

      final int amount = (price * 100).toInt();
      final String reference =
          "shuttle_${DateTime.now().millisecondsSinceEpoch}";

      final response = await http.post(
        Uri.parse('https://api.paystack.co/transaction/initialize'),
        headers: {
          'Authorization': 'Bearer $paystackSecretKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': user.email,
          'amount': amount,
          'reference': reference,
        }),
      );

      if (response.statusCode != 200) {
        throw "Unable to initialize payment";
      }

      final data = jsonDecode(response.body);
      final String checkoutUrl = data['data']['authorization_url'];

      await launchUrl(
        Uri.parse(checkoutUrl),
        mode: LaunchMode.externalApplication,
      );

      await _completeBooking(reference);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment successful! Ticket booked.")),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => MyTicketsPage()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment failed: $e")),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _completeBooking(String paymentReference) async {
    final user = FirebaseAuth.instance.currentUser!;
    final driverRef =
        FirebaseFirestore.instance.collection("shuttle_drivers").doc(driverId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(driverRef);

      if (!snapshot.exists) {
        throw Exception("Driver not found");
      }

      final data = snapshot.data()!;
      int boarded = data['boardedPassengers'] ?? 0;
      int capacity = data['vehicleCapacity'] ?? 0;
      int currentEarnings = data['amountCollected'] ?? 0;

      if (boarded >= capacity) {
        throw Exception("Bus is full");
      }

      transaction.update(driverRef, {
        "boardedPassengers": boarded + 1,
        "amountCollected": currentEarnings + price,
      });

      String ticketId = "ST${Random().nextInt(90000) + 10000}";

      final ticketRef =
          FirebaseFirestore.instance.collection("shuttle_tickets").doc();

      transaction.set(ticketRef, {
        "ticketId": ticketId,
        "driverId": driverId,
        "institution": institution,
        "pickup": pickup,
        "destination": destination,
        "price": price,
        "status": "paid",
        "userId": user.uid,
        "userName": user.displayName ?? "User",
        "paymentReference": paymentReference,
        "createdAt": FieldValue.serverTimestamp(),
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),
        title: const Text(
          'Shuttle Payment',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.white, Colors.amberAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 24,
                horizontal: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Confirm your Shuttle Ticket",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _ticketField("Institution", institution),
                  _ticketField("Pickup", pickup),
                  _ticketField("Destination", destination),
                  _ticketField(
                    "Price",
                    "₦$price",
                    isBold: true,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: loading ? null : _payWithPaystack,
                      child: loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Pay",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _ticketField(String title, String value, {bool isBold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        const Divider(thickness: 1, color: Colors.black12),
        const SizedBox(height: 12),
      ],
    );
  }
}

class ExploreAutoScrollCards extends StatefulWidget {
  const ExploreAutoScrollCards({super.key});

  @override
  State<ExploreAutoScrollCards> createState() => _ExploreAutoScrollCardsState();
}

class _ExploreAutoScrollCardsState extends State<ExploreAutoScrollCards> {
  final PageController _pageController = PageController(viewportFraction: 0.45);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    // Auto scroll every 5 seconds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer.periodic(const Duration(seconds: 5), (timer) {
        if (!mounted) return;

        _currentPage++;
        if (_currentPage > 4) _currentPage = 0;

        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: 5,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 6,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Center(
            child: Text(
              "Card ${index + 1}",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }
}

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  // ------------------- FETCH MOCK ACTIVITIES -------------------
  Future<List<Map<String, dynamic>>> _fetchRecentActivities() async {
    await Future.delayed(const Duration(seconds: 1)); // simulate load

    return [
      {
        "type": "Ride",
        "pickup": "Airport Road",
        "destination": "Wuse 2",
        "status": "Completed",
        "time": DateTime.now().subtract(const Duration(hours: 1)),
      },
      {
        "type": "Logistics",
        "pickup": "Garki",
        "destination": "Lugbe",
        "status": "Pending",
        "time": DateTime.now().subtract(const Duration(hours: 3)),
      },
      {
        "type": "Transport",
        "pickup": "Abuja",
        "destination": "Lagos",
        "status": "In Transit",
        "time": DateTime.now().subtract(const Duration(days: 1)),
      },
    ];
  }

  // ------------------- STATUS COLOR -------------------
  Color _statusColor(String status) {
    switch (status) {
      case "Completed":
        return Colors.green;
      case "Pending":
        return Colors.orange;
      case "In Transit":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  // ------------------- FORMAT TIME -------------------
  String _formatTime(dynamic time) {
    if (time is DateTime) {
      return "${time.hour}:${time.minute.toString().padLeft(2, '0')}  ·  ${time.day}/${time.month}/${time.year}";
    }
    return time.toString();
  }

  // ------------------- BUILD UI -------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            'Orders',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchRecentActivities(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No recent activities."));
            }

            final activities = snapshot.data!;

            return ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // LEFT — ICON
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          activity["type"] == "Ride"
                              ? Icons.directions_bike
                              : activity["type"] == "Logistics"
                                  ? Icons.local_shipping
                                  : Icons.directions_bus,
                          size: 22,
                          color: Colors.deepPurple,
                        ),
                      ),

                      const SizedBox(width: 16),

                      // MIDDLE COLUMN — PICKUP → DESTINATION + DATE
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${activity["pickup"]} → ${activity["destination"]}",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.access_time,
                                    size: 12, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  _formatTime(activity["time"]),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // RIGHT COLUMN — TYPE + STATUS BADGE
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            activity["type"],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: _statusColor(activity["status"])
                                  .withOpacity(0.15),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              activity["status"],
                              style: TextStyle(
                                fontSize: 11,
                                color: _statusColor(activity["status"]),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ShoppingSectionPage extends StatefulWidget {
  const ShoppingSectionPage({super.key});

  @override
  State<ShoppingSectionPage> createState() => _ShoppingSectionPageState();
}

class _ShoppingSectionPageState extends State<ShoppingSectionPage>
    with SingleTickerProviderStateMixin {
  final Map<String, int> _selectedItems = {};
  final Map<String, Map<String, dynamic>> _productDetails = {};

  final GlobalKey _cartKey = GlobalKey();

  late AnimationController _animationController;

  OverlayEntry? _overlayEntry;

  late Offset _startPosition;
  late Offset _endPosition;
  late Offset _controlPoint;

  List<String> _ShoppingVendorIds = [];

  String selectedCategory = "All";

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));

    _fetchShoppingVendors();
  }

  Future<void> _fetchShoppingVendors() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Vendors')
          .where('category', whereIn: ['Grocery Vendor', 'Pharmacy']).get();

      setState(() {
        _ShoppingVendorIds = snapshot.docs.map((doc) => doc.id).toList();
      });
    } catch (e) {
      print("Error fetching vendors: $e");
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double _parsePrice(dynamic price) {
    if (price == null) return 0;

    if (price is num) return price.toDouble();

    if (price is String) return double.tryParse(price) ?? 0;

    return 0;
  }

  // ---------------- SHIMMER ----------------

  Widget _shimmerBox({
    double? width,
    double? height,
    ShapeBorder? shape,
  }) {
    return TweenAnimationBuilder(
      tween: Tween(begin: -1.0, end: 2.0),
      duration: const Duration(seconds: 2),
      builder: (context, value, child) {
        return ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment(-1, -0.3),
              end: Alignment(1, 0.3),
              colors: [
                Colors.grey.shade300,
                Colors.grey.shade100,
                Colors.grey.shade300,
              ],
              stops: [
                value - 1,
                value,
                value + 1,
              ],
            ).createShader(rect);
          },
          child: child,
        );
      },
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: Colors.grey[300]!,
          shape: shape ??
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
        ),
      ),
    );
  }

  Widget _shimmerProductCard() {
    return Container(
      width: double.infinity,
      height: 85,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          _shimmerBox(width: 60, height: 60, shape: const CircleBorder()),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(width: 120, height: 14),
                const SizedBox(height: 8),
                _shimmerBox(width: 160, height: 10),
              ],
            ),
          ),
          _shimmerBox(width: 40, height: 14),
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (_, __) => _shimmerProductCard(),
    );
  }

  // ---------------- CART ANIMATION ----------------

  void _flyToCart(GlobalKey imageKey, Map<String, dynamic> product) {
    final RenderBox renderBox =
        imageKey.currentContext!.findRenderObject() as RenderBox;

    _startPosition = renderBox.localToGlobal(Offset.zero);

    final RenderBox cartBox =
        _cartKey.currentContext!.findRenderObject() as RenderBox;

    _endPosition = cartBox.localToGlobal(Offset.zero);

    _controlPoint = Offset(
      (_startPosition.dx + _endPosition.dx) / 2,
      _startPosition.dy - 150,
    );

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            double t = _animationController.value;

            double x = (1 - t) * (1 - t) * _startPosition.dx +
                2 * (1 - t) * t * _controlPoint.dx +
                t * t * _endPosition.dx;

            double y = (1 - t) * (1 - t) * _startPosition.dy +
                2 * (1 - t) * t * _controlPoint.dy +
                t * t * _endPosition.dy;

            return Positioned(
              left: x,
              top: y,
              child: child!,
            );
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.purple),
            child: const Icon(Icons.fastfood, color: Colors.white),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);

    _animationController.forward(from: 0).whenComplete(() {
      _overlayEntry!.remove();

      setState(() {
        final productId = product['id'];

        _selectedItems[productId] = (_selectedItems[productId] ?? 0) + 1;

        _productDetails[productId] = product;
      });
    });
  }

  void _goToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutPage(
          cartItems: _selectedItems,
          productDetails: _productDetails,
        ),
      ),
    );
  }

  bool _shouldShowProduct(Map<String, dynamic> data) {
    if (selectedCategory == "All") return true;

    if (selectedCategory == "Groceries" &&
        data["vendorType"] == "Grocery Vendor") return true;

    if (selectedCategory == "Pharma" && data["vendorType"] == "Pharmacy")
      return true;

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                  const Spacer(),
                  const Text(
                    'Shop Essentials',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(flex: 2),
                ],
              ),

              const SizedBox(height: 10),

              /// SEARCH BAR

              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "Categories",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),

              const SizedBox(height: 6),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ["All", "Groceries", "Pharma"].map((cat) {
                  bool isSelected = selectedCategory == cat;

                  return GestureDetector(
                    onTap: () => setState(() => selectedCategory = cat),
                    child: Container(
                      height: 28,
                      width: 90,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black : Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                            color:
                                isSelected ? Colors.white : Colors.grey[600]),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 10),

              /// PRODUCTS
              Expanded(
                child: _ShoppingVendorIds.isEmpty
                    ? _buildShimmerList()
                    : StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('products')
                            .where('vendorId', whereIn: _ShoppingVendorIds)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return _buildShimmerList();
                          }

                          final docs = snapshot.data!.docs;

                          return ListView.builder(
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              final doc = docs[index];

                              final data = doc.data() as Map<String, dynamic>;

                              final imageKey = GlobalKey();

                              return GestureDetector(
                                onTap: () => _flyToCart(imageKey, data),
                                child: Container(
                                  height: 85,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: Row(
                                    children: [
                                      Container(
                                        key: imageKey,
                                        width: 60,
                                        height: 60,
                                        child: ClipOval(
                                          child: Image.network(
                                            data['image'] ?? '',
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) {
                                              return Image.asset(
                                                data['fallbackAsset'] ??
                                                    "assets/images/food.png",
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              data['name'] ?? '',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "₦${data['price']}",
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
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: _cartKey,
        onPressed: _goToCart,
        icon: const Icon(Icons.shopping_cart),
        label: Text('${_selectedItems.length}'),
        backgroundColor: Colors.black,
      ),
    );
  }
}

class UserOrdersPage extends StatelessWidget {
  final String orderId;

  const UserOrdersPage({super.key, required this.orderId});

  Future<void> _generateDeliveryCode(String orderId) async {
    final docRef = FirebaseFirestore.instance.collection('orders').doc(orderId);
    final snapshot = await docRef.get();
    if (!snapshot.exists) return;

    final data = snapshot.data() as Map<String, dynamic>? ?? {};

    if (data['deliveryCode'] == null) {
      final deliveryCode = Random().nextInt(900000) + 100000;
      await docRef.update({'deliveryCode': deliveryCode});
    }
  }

  bool _isReached(String currentStatus, String step) {
    const order = ['pending', 'accepted', 'picked_up', 'completed'];
    return order.indexOf(currentStatus) >= order.indexOf(step);
  }

  String _formatTime(Timestamp? ts) {
    if (ts == null) return "--";
    final dt = ts.toDate();
    return "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
  }

  Widget _timelineStep({
    required bool reached,
    required bool isLast,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: reached ? Colors.green : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: reached
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            if (!isLast)
              AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                width: 3,
                height: 60,
                color: reached ? Colors.green : Colors.grey.shade300,
              )
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Opacity(
            opacity: reached ? 1 : 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(time,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 3),
                Text(subtitle, style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 20),
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            '',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(orderId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orderData =
              snapshot.data!.data() as Map<String, dynamic>? ?? {};

          if (orderData['deliveryCode'] == null) {
            _generateDeliveryCode(orderId);
          }

          // Handle items as Map or List
          List<Map<String, dynamic>> items = [];
          final itemsData = orderData['items'];
          if (itemsData is List) {
            items = List<Map<String, dynamic>>.from(itemsData);
          } else if (itemsData is Map) {
            items = itemsData.entries
                .map((e) => Map<String, dynamic>.from(e.value as Map))
                .toList();
          }

          final status = orderData['status'] ?? 'pending';
          final deliveryCode = orderData['deliveryCode'];
          final createdAt = orderData['createdAt'] as Timestamp?;
          final pickupConfirmedAt =
              orderData['pickupConfirmedAt'] as Timestamp?;
          final deliveredAt = orderData['deliveredAt'] as Timestamp?;

          double totalPrice = 0;
          for (var item in items) {
            final price = item['price'] ?? 0;
            final qty = item['qty'] ?? 1;
            totalPrice += (price is num ? price.toDouble() : 0) *
                (qty is num ? qty.toDouble() : 1);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text("Order Id",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 10),
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: Text("$orderId",
                            style: const TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                const Text("Delivery Confirmation",
                    style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        const Text(
                            "Show this code to the delivery agent to confirm delivery"),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            deliveryCode?.toString() ?? "Generating...",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                _timelineStep(
                  reached: _isReached(status, 'pending'),
                  isLast: false,
                  title: "Order Placed",
                  subtitle: "Processing your order",
                  time: _formatTime(createdAt),
                ),
                _timelineStep(
                  reached: _isReached(status, 'accepted'),
                  isLast: false,
                  title: "Order Accepted",
                  subtitle: "Vendor is preparing your order",
                  time: "--",
                ),
                _timelineStep(
                  reached: _isReached(status, 'picked_up'),
                  isLast: false,
                  title: "Order Pickup",
                  subtitle: "Rider is on the way",
                  time: _formatTime(pickupConfirmedAt),
                ),
                _timelineStep(
                  reached: _isReached(status, 'completed'),
                  isLast: true,
                  title: "Order Delivered",
                  subtitle: "Completed",
                  time: _formatTime(deliveredAt),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 0,
                  color: Colors.transparent,
                  margin: EdgeInsets.zero,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Order Details Title
                        const Center(
                          child: Text(
                            "Order Details",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// Items List
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];

                            final price =
                                ((item['price'] ?? 0) * (item['qty'] ?? 1))
                                    .toDouble();

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  /// Name + Qty
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'] ?? 'Unnamed',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "Qty: ${item['qty'] ?? 1}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ),

                                  /// Price
                                  Text(
                                    "₦${price.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 14),

                        /// Divider
                        Divider(
                          color: Colors.grey.shade300,
                          thickness: 0.8,
                        ),

                        const SizedBox(height: 10),

                        /// Total Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "₦${totalPrice.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

class UserOrdersListPage extends StatelessWidget {
  const UserOrdersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text("User not logged in"));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            'My Orders',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!.docs;

          if (orders.isEmpty) {
            return const Center(child: Text("You have no orders yet"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>? ?? {};

              // Handle items as Map or List
              List<Map<String, dynamic>> items = [];
              final itemsData = order['items'];
              if (itemsData is List) {
                items = List<Map<String, dynamic>>.from(itemsData);
              } else if (itemsData is Map) {
                items = itemsData.entries
                    .map((e) => Map<String, dynamic>.from(e.value as Map))
                    .toList();
              }

              double totalPrice = 0;
              for (var item in items) {
                final price = item['price'] ?? 0;
                final qty = item['qty'] ?? 1;
                totalPrice += (price is num ? price.toDouble() : 0) *
                    (qty is num ? qty.toDouble() : 1);
              }

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UserOrdersPage(orderId: orders[index].id),
                    ),
                  );
                },
                child: Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Order : ${orders[index].id}",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Number of items: ${items.length}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Total: ₦${totalPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                " ${order['status'] ?? 'pending'}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple),
                              ),
                            ),
                          ],
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
    );
  }
}

class CheckoutPage extends StatefulWidget {
  final Map<String, int> cartItems; // compositeKey → quantity
  final Map<String, Map<String, dynamic>>
      productDetails; // compositeKey → enhanced product

  const CheckoutPage({
    super.key,
    required this.cartItems,
    required this.productDetails,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late Map<String, int> _cartItems;
  late Map<String, Map<String, dynamic>> _productDetails;

  double deliveryFee = 500;
  double additionalFee = 0;
  bool _isLoading = false;

  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cartItems = Map.from(widget.cartItems);
    _productDetails = Map.from(widget.productDetails);
  }

  double _parsePrice(dynamic p) {
    if (p == null) return 0.0;
    if (p is num) return p.toDouble();
    if (p is String) return double.tryParse(p) ?? 0.0;
    return 0.0;
  }

  void _removeItem(String key) {
    setState(() {
      _cartItems.remove(key);
      _productDetails.remove(key);
    });
  }

  double get subtotal {
    double total = 0;
    _cartItems.forEach((key, qty) {
      final item = _productDetails[key];
      if (item != null) {
        total += _parsePrice(item['price']) * qty;
      }
    });
    return total;
  }

  double get grandTotal => subtotal + deliveryFee + additionalFee;

  Future<List<Map<String, dynamic>>> _getVendorPickups() async {
    final pickups = <Map<String, dynamic>>[];
    final seen = <String>{};

    for (var key in _cartItems.keys) {
      final item = _productDetails[key];
      if (item == null) continue;
      final vendorId = item['vendorId'] as String?;
      if (vendorId == null || seen.contains(vendorId)) continue;
      seen.add(vendorId);

      final vendorDoc = await FirebaseFirestore.instance
          .collection('Vendors')
          .doc(vendorId)
          .get();
      if (vendorDoc.exists) {
        final data = vendorDoc.data()!;
        pickups.add({
          'vendorId': vendorId,
          'vendorName': data['businessName'] ?? 'Vendor',
          'address': data['storeLocation'] ?? 'No address',
        });
      }
    }
    return pickups;
  }

  Future<void> _pay() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please sign in")));
      return;
    }

    if (_addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Enter delivery address")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      const paystackSecretKey =
          'sk_test_661490bf9dc0914e122c2c043ab3aaf3a307d658';
      final amountInKobo = (grandTotal * 100).round();
      final reference = "chow_${DateTime.now().millisecondsSinceEpoch}";

      final response = await http.post(
        Uri.parse('https://api.paystack.co/transaction/initialize'),
        headers: {
          'Authorization': 'Bearer $paystackSecretKey',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'email': user.email,
          'amount': amountInKobo,
          'reference': reference,
          'currency': 'NGN',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final checkoutUrl = data['data']['authorization_url'] as String;

        if (await canLaunchUrl(Uri.parse(checkoutUrl))) {
          await launchUrl(Uri.parse(checkoutUrl),
              mode: LaunchMode.externalApplication);

          final pickups = await _getVendorPickups();
          final vendorIds = pickups.map((v) => v['vendorId']).toList();

          final orderItems = <String, dynamic>{};
          _cartItems.forEach((key, qty) {
            final item = _productDetails[key]!;
            orderItems[key] = {
              'qty': qty,
              'productId': item['id'],
              'name': item['name'],
              'basePrice': item['basePrice'],
              'selectedAddons': item['selectedAddons'],
              'selectedSides': item['selectedSides'],
              'price': item['price'],
              'vendorId': item['vendorId'],
            };
          });

          final orderRef =
              await FirebaseFirestore.instance.collection('orders').add({
            'userId': user.uid,
            'userName': user.displayName ?? 'Guest',
            'items': orderItems,
            'pickupLocations': pickups,
            'vendorIds': vendorIds,
            'deliveryAddress': _addressController.text.trim(),
            'subtotal': subtotal,
            'additionalFee': additionalFee,
            'deliveryFee': deliveryFee,
            'grandTotal': grandTotal,
            'status': 'pending',
            'createdAt': Timestamp.now(),
            'paymentReference': reference,
          });

          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UserOrdersPage(orderId: orderRef.id),
              ),
            );

            // optional slight delay ensures navigation completes smoothly
            Future.delayed(const Duration(milliseconds: 300), () {
              _cartItems.clear();
              _productDetails.clear();
              setState(() {});
            });
          }
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Payment failed")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            'Checkout',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: "Delivery Address",
                hintText: "Enter full delivery address",
                prefixIcon: const Icon(Icons.location_on),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _cartItems.isEmpty
                  ? const Center(
                      child: Text('Your cart is empty',
                          style: TextStyle(fontSize: 18)))
                  : ListView.builder(
                      itemCount: _cartItems.length,
                      itemBuilder: (context, index) {
                        final key = _cartItems.keys.elementAt(index);
                        final qty = _cartItems[key]!;
                        final item = _productDetails[key]!;

                        final lineTotal = _parsePrice(item['price']) * qty;

                        final addons =
                            item['selectedAddons'] as List<dynamic>? ?? [];
                        final sides =
                            item['selectedSides'] as List<dynamic>? ?? [];

                        return Card(
                          color: Colors.white,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: item['image'] != ''
                                          ? Image.network(item['image'],
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover)
                                          : const Icon(Icons.fastfood,
                                              size: 60),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(item['name'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                          const SizedBox(height: 4),
                                          Text(
                                              'x $qty  •  ₦${lineTotal.toStringAsFixed(0)}',
                                              style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 15)),
                                          if (addons.isNotEmpty ||
                                              sides.isNotEmpty) ...[
                                            const SizedBox(height: 8),
                                            const Text("Customizations:",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey)),
                                            ...addons.map((a) => Text(
                                                "• ${a['name']} (+₦${_parsePrice(a['price']).toStringAsFixed(0)})",
                                                style: const TextStyle(
                                                    fontSize: 13))),
                                            ...sides.map((s) => Text(
                                                "• ${s['name']} (+₦${_parsePrice(s['price']).toStringAsFixed(0)})",
                                                style: const TextStyle(
                                                    fontSize: 13))),
                                          ],
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          color: Colors.red),
                                      onPressed: () => _removeItem(key),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const Divider(height: 32, thickness: 1),
            _buildPriceRow('Subtotal', subtotal),
            _buildPriceRow('Delivery Fee', deliveryFee),
            _buildPriceRow('Additional Fee', additionalFee),
            const Divider(height: 32, thickness: 1.5),
            _buildPriceRow('Grand Total', grandTotal,
                isBold: true, large: true),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _cartItems.isEmpty || _isLoading ? null : _pay,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Pay Now',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double value,
      {bool isBold = false, bool large = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: large ? 18 : 16,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500),
          ),
          Text(
            '₦${value.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: large ? 20 : 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: large ? Colors.deepPurple : null,
            ),
          ),
        ],
      ),
    );
  }
}

class FoodSectionPage extends StatefulWidget {
  const FoodSectionPage({super.key});

  @override
  State<FoodSectionPage> createState() => _FoodSectionPageState();
}

class _FoodSectionPageState extends State<FoodSectionPage>
    with SingleTickerProviderStateMixin {
  final Map<String, int> _selectedItems = {};
  final Map<String, Map<String, dynamic>> _productDetails = {};

  final GlobalKey _cartKey = GlobalKey();

  late AnimationController _animationController;
  OverlayEntry? _overlayEntry;

  late Offset _startPosition;
  late Offset _endPosition;
  late Offset _controlPoint;

  List<Map<String, dynamic>> _foodVendors = [];

  String? selectedVendorId;

  /// CATEGORY FILTER
  final Set<String> _selectedCategories = {};
  final List<String> _allCategories = [
    'Drinks',
    'Spaghetti',
    'Rice',
    'Swallow',
    'Shawarma',
    'Pizza',
    'Small Chops',
    'Pastries'
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fetchFoodVendors();
  }

  int get _totalItems {
    return _selectedItems.values.fold(0, (sum, qty) => sum + qty);
  }

  Future<void> _fetchFoodVendors() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Vendors')
        .where('category', isEqualTo: 'Food Vendor')
        .get();

    setState(() {
      _foodVendors = snapshot.docs
          .map((doc) => {
                'id': doc.id,
                'name': doc['businessName'] ?? 'Unnamed',
                'image': doc['profileImageUrl'] ?? '',
              })
          .toList();
    });
  }

  double _parsePrice(dynamic price) {
    if (price == null) return 0;
    if (price is num) return price.toDouble();
    if (price is String) return double.tryParse(price) ?? 0;
    return 0;
  }

  void openVendorModal(Map<String, dynamic> vendor) async {
    final vendorId = vendor["uid"];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.65, // ✅ 65% height
          child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection("products")
                .where("vendorId", isEqualTo: vendorId)
                .get(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final vendorProducts =
                  snapshot.data.docs.map((e) => e.data()).toList();

              // 🔥 RANDOM OPEN/CLOSE (for now)
              bool isOpen = DateTime.now().second % 2 == 0;
              final deliveryTime =
                  10 + (DateTime.now().millisecond % 26); // 10–35 mins
              final rating = (3.5 + (DateTime.now().millisecond % 15) / 10)
                  .toStringAsFixed(1); // 3.5 – 5.0

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    /// HANDLE
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// 🔥 UPDATED VENDOR CARD
                    /// 🔥 UPDATED VENDOR CARD
                    Container(
                      height: 130, // ✅ increased height
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white, // ✅ white background
                        borderRadius: BorderRadius.circular(14),
                        border:
                            Border.all(color: Colors.black), // ✅ black border
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// IMAGE
                          ClipOval(
                            child: Image.network(
                              vendor["profileImageUrl"] ?? "",
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),

                          const SizedBox(width: 12),

                          /// DETAILS
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                /// NAME
                                Text(
                                  vendor["businessName"] ?? "",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                /// LOCATION + STATUS
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        vendor["storeLocation"] ??
                                            "No location",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),

                                    /// STATUS CHIP
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isOpen
                                            ? Colors.green.withOpacity(0.1)
                                            : Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        isOpen ? "Open" : "Closed",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: isOpen
                                              ? Colors.green
                                              : Colors.red,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                /// 🔥 DELIVERY TIME + RATING
                                Row(
                                  children: [
                                    /// DELIVERY TIME
                                    Row(
                                      children: [
                                        Icon(Icons.access_time,
                                            size: 14, color: Colors.grey[600]),
                                        const SizedBox(width: 4),
                                        Text(
                                          "$deliveryTime mins",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(width: 12),

                                    /// RATING
                                    Row(
                                      children: [
                                        const Icon(Icons.star,
                                            size: 14, color: Colors.amber),
                                        const SizedBox(width: 4),
                                        Text(
                                          rating,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    Divider(
                      color: Colors.grey[300],
                      thickness: 1,
                    ),

                    const SizedBox(height: 10),

                    /// PRODUCTS TITLE
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Products",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// PRODUCTS LIST
                    Expanded(
                      child: ListView.builder(
                        itemCount: vendorProducts.length,
                        itemBuilder: (context, index) {
                          final product = vendorProducts[index];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                ClipOval(
                                  child: Image.network(
                                    product["image"] ?? "",
                                    width: 65,
                                    height: 65,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      width: 65,
                                      height: 65,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.image,
                                          color: Colors.grey),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product["name"] ?? "",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        product["description"] ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  "₦${product["price"]}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// ================= CUSTOMIZATION MODAL =================
  void _openCustomizationModal(
      Map<String, dynamic> product, GlobalKey imageKey) {
    int quantity = 1;
    final List selectedAddons = [];
    final List selectedSides = [];

    double basePrice = _parsePrice(product['price']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(builder: (context, setModalState) {
          double total = basePrice;

          for (var a in selectedAddons) {
            total += _parsePrice(a['price']);
          }
          for (var s in selectedSides) {
            total += _parsePrice(s['price']);
          }

          total *= quantity;

          Widget buildOptionCard({
            required String title,
            required List items,
            required List selectedList,
          }) {
            if (items.isEmpty) return const SizedBox();

            return Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  ...List.generate(items.length, (index) {
                    final item = items[index];
                    final isSelected = selectedList.contains(item);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'],
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "₦${item['price']}",
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setModalState(() {
                                if (isSelected) {
                                  selectedList.remove(item);
                                } else {
                                  selectedList.add(item);
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
                ],
              ),
            );
          }

          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                /// CONTENT
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// IMAGE + NAME
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipOval(
                              child: product['image'] != null &&
                                      product['image'].toString().isNotEmpty
                                  ? Image.network(
                                      product['image'],
                                      height: 70,
                                      width: 70,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      height: 70,
                                      width: 70,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.fastfood),
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 6),

                                  /// DESCRIPTION MOVED HERE
                                  if (product['description'] != null)
                                    Text(
                                      product['description'],
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                ],
                              ),
                            )
                          ],
                        ),

                        const SizedBox(height: 10),
                        const Divider(),

                        /// SIDES CARD
                        buildOptionCard(
                          title: "Sides",
                          items: product['sides'] ?? [],
                          selectedList: selectedSides,
                        ),

                        /// ADDONS CARD
                        buildOptionCard(
                          title: "Addons",
                          items: product['addons'] ?? [],
                          selectedList: selectedAddons,
                        ),

                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),

                /// BOTTOM BAR
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 5)
                    ],
                  ),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                if (quantity > 1)
                                  setModalState(() => quantity--);
                              },
                              icon: const Icon(Icons.remove_circle)),
                          Text(quantity.toString(),
                              style: const TextStyle(fontSize: 18)),
                          IconButton(
                              onPressed: () => setModalState(() => quantity++),
                              icon: const Icon(Icons.add_circle)),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            Navigator.pop(context);

                            final cartKey =
                                "${product['id']}-${selectedAddons.hashCode}-${selectedSides.hashCode}";

                            final cartProduct = {
                              ...product,
                              'addonsSelected': selectedAddons,
                              'sidesSelected': selectedSides,
                              'quantity': quantity,
                              'price': total,
                            };

                            setState(() {
                              _selectedItems.update(
                                cartKey,
                                (value) => value + quantity,
                                ifAbsent: () => quantity,
                              );

                              _productDetails[cartKey] = cartProduct;
                            });

                            _flyToCart(
                                imageKey, cartProduct, cartKey, quantity);
                          },
                          child: Text(
                            "Add ₦$total",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
      },
    );
  }

  /// ================= FLY TO CART =================
  void _flyToCart(GlobalKey imageKey, Map<String, dynamic> product,
      String cartKey, int quantity) {
    final RenderBox renderBox =
        imageKey.currentContext!.findRenderObject() as RenderBox;

    _startPosition = renderBox.localToGlobal(Offset.zero);

    final RenderBox cartBox =
        _cartKey.currentContext!.findRenderObject() as RenderBox;

    _endPosition = cartBox.localToGlobal(Offset.zero);

    _controlPoint = Offset(
        (_startPosition.dx + _endPosition.dx) / 2, _startPosition.dy - 150);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return AnimatedBuilder(
          animation: _animationController,
          builder: (_, child) {
            double t = _animationController.value;

            double x = (1 - t) * (1 - t) * _startPosition.dx +
                2 * (1 - t) * t * _controlPoint.dx +
                t * t * _endPosition.dx;

            double y = (1 - t) * (1 - t) * _startPosition.dy +
                2 * (1 - t) * t * _controlPoint.dy +
                t * t * _endPosition.dy;

            return Positioned(left: x, top: y, child: child!);
          },
          child: const CircleAvatar(
            radius: 25,
            backgroundColor: Colors.black,
            child: Icon(Icons.fastfood, color: Colors.white),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);

    _animationController.forward(from: 0).whenComplete(() {
      _overlayEntry!.remove();

      setState(() {
        _selectedItems[cartKey] = (_selectedItems[cartKey] ?? 0) + quantity;

        _productDetails[cartKey] = product;
      });
    });
  }

  void _goToCart() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CheckoutPage(
          cartItems: _selectedItems,
          productDetails: _productDetails,
        ),
      ),
    );

    setState(() {});
  }

  /// ================= SKELETON =================
  Widget _skeletonTile() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 85,
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _totalItems == 0
            ? FloatingActionButton(
                key: const ValueKey("collapsed"),
                onPressed: _goToCart,
                backgroundColor: Colors.black,
                child: const Icon(Icons.shopping_cart, color: Colors.white),
              )
            : FloatingActionButton.extended(
                key: const ValueKey("expanded"),
                onPressed: _goToCart,
                backgroundColor: Colors.black,
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                label: Text(
                  "Checkout ($_totalItems)",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// STICKY SEARCH + CATEGORIES
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.grey[100], // ✅ grey 50 look
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios,
                            size: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      //const Spacer(),
                      SizedBox(height: 10),
                      const Text("Order Food",
                          style: TextStyle(
                              // fontWeight: FontWeight.bold
                              )),
                      const Spacer(flex: 2),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: const TextField(
                      decoration: InputDecoration(
                          hintText: "Search food",
                          border: InputBorder.none,
                          icon: Icon(Icons.search)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        // 🔹 ALL CHIP
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: FilterChip(
                            label: const Text("All"),
                            selected: _selectedCategories.isEmpty,
                            onSelected: (_) {
                              setState(() {
                                _selectedCategories.clear();
                              });
                            },
                            selectedColor: Colors.black,
                            backgroundColor: Colors.grey[100],
                            checkmarkColor: Colors.white,
                            labelStyle: TextStyle(
                              color: _selectedCategories.isEmpty
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),

                        // 🔹 CATEGORY CHIPS
                        ..._allCategories.map((cat) {
                          final isSelected = _selectedCategories.contains(cat);
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: FilterChip(
                              label: Text(cat),
                              selected: isSelected,
                              onSelected: (v) {
                                setState(() {
                                  if (v) {
                                    _selectedCategories.clear();
                                    _selectedCategories.add(cat);
                                  } else {
                                    _selectedCategories.remove(cat);
                                  }
                                });
                              },
                              selectedColor: Colors.black,
                              backgroundColor: Colors.grey[100],
                              checkmarkColor: Colors.white,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 8),

            /// SWIPABLE VENDORS + PRODUCTS
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Explore Vendors',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),

                  /// VENDORS (horizontally scrollable)
                  SizedBox(
                    height: 120, // 🔥 increased from 100 → 120
                    child: _foodVendors.isEmpty
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 4,
                            itemBuilder: (_, __) => _skeletonTile())
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.zero,
                            itemCount: _foodVendors.length,
                            itemBuilder: (_, i) {
                              final vendor = _foodVendors[i];

                              bool selected = vendor['id'] == selectedVendorId;

                              final bool isOpen = (i % 2 == 0);

                              return GestureDetector(
                                onTap: () => openVendorModal(vendor),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        width: 350,
                                        height:
                                            120, // 🔥 FORCE HEIGHT HERE (important)
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: selected
                                              ? Colors.purple.withOpacity(0.2)
                                              : Colors.grey[100],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Stack(
                                          children: [
                                            // 🔥 MAIN CONTENT CENTERED
                                            Align(
                                              alignment: Alignment.center,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 75,
                                                    height: 75,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.grey[300],
                                                    ),
                                                    child: ClipOval(
                                                      child: (() {
                                                        final raw =
                                                            vendor['image'];

                                                        final imageUrl =
                                                            (raw ?? '')
                                                                .toString()
                                                                .trim()
                                                                .replaceAll(
                                                                    '"', '');

                                                        if (imageUrl.isEmpty) {
                                                          return const Icon(
                                                              Icons.person,
                                                              size: 30);
                                                        }

                                                        return Image.network(
                                                          imageUrl,
                                                          fit: BoxFit.cover,
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return const Icon(
                                                                Icons
                                                                    .broken_image,
                                                                size: 30);
                                                          },
                                                        );
                                                      })(),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Text(
                                                      vendor['name'],
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // 🔥 STATUS BADGE (TOP RIGHT, PROPERLY ALIGNED)
                                            Positioned(
                                              top: 8,
                                              right: 8,
                                              child: Container(
                                                padding: const EdgeInsets
                                                        .symmetric(
                                                    horizontal: 8,
                                                    vertical:
                                                        3), // 🔥 tighter padding
                                                decoration: BoxDecoration(
                                                  color: isOpen
                                                      ? Colors.green
                                                      : Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.12),
                                                      blurRadius: 4,
                                                      offset:
                                                          const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      width: 5,
                                                      height: 5,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      isOpen
                                                          ? "Open"
                                                          : "Closed",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            9, // 🔥 smaller for balance
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                  ),
                  const SizedBox(height: 8),

                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .snapshots(),
                    builder: (_, snapshot) {
                      if (!snapshot.hasData) {
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 6,
                            itemBuilder: (_, __) => _skeletonTile());
                      }

                      var products = snapshot.data!.docs;

                      // Only products from food vendors
                      final foodVendorIds =
                          _foodVendors.map((v) => v['id']).toSet();
                      products = products.where((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        if (!data.containsKey('vendorId')) return false;
                        return foodVendorIds.contains(data['vendorId']);
                      }).toList();

                      // Safe vendor filter if any vendor selected
                      if (selectedVendorId != null) {
                        products = products
                            .where((doc) =>
                                doc.data().toString().contains('vendorId') &&
                                doc['vendorId'] == selectedVendorId)
                            .toList();
                      }

                      // Safe category filter
                      if (_selectedCategories.isNotEmpty) {
                        products = products.where((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          if (!data.containsKey('category')) return false;
                          return _selectedCategories.contains(data['category']);
                        }).toList();
                      }

                      if (products.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(20),
                          child:
                              Center(child: Text("No items in this category")),
                        );
                      }

                      return Column(
                        children: products.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          final product = {'id': doc.id, ...data};
                          final GlobalKey imageKey = GlobalKey();

                          return GestureDetector(
                            onTap: () =>
                                _openCustomizationModal(product, imageKey),
                            child: Container(
                              height: 110, // slightly increased
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 5,
                                  )
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                child: Row(
                                  children: [
                                    // 🔥 UPDATED IMAGE (rounded card + bigger)
                                    Container(
                                      key: imageKey,
                                      width: 75,
                                      height: 75,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey[200],
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          )
                                        ],
                                      ),
                                      child: ClipOval(
                                        child: (() {
                                          final imageUrl =
                                              data['image'] as String?;

                                          if (imageUrl == null ||
                                              imageUrl.trim().isEmpty) {
                                            return const Icon(Icons.image);
                                          }

                                          final cleanUrl = imageUrl.trim();

                                          debugPrint(
                                              "IMAGE URL USED: $cleanUrl");

                                          return Image.network(
                                            cleanUrl,
                                            fit: BoxFit.cover,
                                            loadingBuilder:
                                                (context, child, progress) {
                                              if (progress == null)
                                                return child;
                                              return const Center(
                                                child: SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                          strokeWidth: 2),
                                                ),
                                              );
                                            },
                                            errorBuilder: (_, __, ___) {
                                              debugPrint(
                                                  "FAILED URL: $cleanUrl");
                                              return const Icon(
                                                  Icons.broken_image);
                                            },
                                          );
                                        })(),
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    // Product Name & Description
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data['name'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            data['description'] ?? '',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // 🔥 PRICE + ORDER COUNT
                                    Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: Builder(
                                        builder: (_) {
                                          final int orders =
                                              (data['name'].hashCode % 30) + 1;

                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "₦${_parsePrice(data['price'])}",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),

                                              const SizedBox(height: 10),

                                              // 🔢 Orders

                                              // 🔥 Popular Badge
                                              if (orders > 15) ...[
                                                const SizedBox(height: 4),
                                                Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 6,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.orange
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  child: const Text(
                                                    "🔥",
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.orange,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ]
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DriverBookedScreen extends StatefulWidget {
  final String riderName;
  final String pickup;
  final String destination;
  final double price;
  final String paymentMethod;
  final String rideId;

  const DriverBookedScreen({
    Key? key,
    required this.rideId,
    required this.riderName,
    required this.pickup,
    required this.destination,
    required this.price,
    required this.paymentMethod,
  }) : super(key: key);

  @override
  State<DriverBookedScreen> createState() => _DriverBookedScreenState();
}

class _DriverBookedScreenState extends State<DriverBookedScreen> {
  bool hasStartedPickup = false;
  bool hasArrivedAtPickup = false;

  LatLng _defaultCenter = const LatLng(6.5244, 3.3792); // Lagos fallback
  LatLng? userLocation;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _listenToRideStatus(); // 🔥 Start Firestore listener
  }

  /// 🔥 LISTEN TO FIRESTORE FOR STATUS CHANGE
  void _listenToRideStatus() {
    FirebaseFirestore.instance
        .collection('ride_requests')
        .doc(widget.rideId)
        .snapshots()
        .listen((snapshot) {
      if (!snapshot.exists) return;

      final data = snapshot.data() as Map<String, dynamic>;
      final String? status = data['status'];

      if (status == 'completed' && mounted) {
        _showRideCompletedDialog();
      }
    });
  }

  void _showRideCompletedDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Ride Completed"),
        content:
            const Text("The passenger has paid and the trip is completed."),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop(); // close dialog
              Navigator.of(context).pop(); // close driver screen
            },
          ),
        ],
      ),
    );
  }

  /// 📍 Get Driver Location
  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        userLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌍 GOOGLE MAP BACKGROUND
          userLocation == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: userLocation ?? _defaultCenter,
                    zoom: 15,
                  ),
                  onMapCreated: (controller) => _mapController = controller,
                  markers: {
                    Marker(
                      markerId: const MarkerId("driver_location"),
                      position: userLocation ?? _defaultCenter,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueAzure),
                    ),
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),

          // 🎉 DETAILS BOTTOM SHEET
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    icon: Icons.person,
                    label: 'Client',
                    content: widget.riderName,
                    context: context,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    icon: Icons.my_location,
                    label: 'Pickup',
                    content: widget.pickup,
                    context: context,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    icon: Icons.location_on,
                    label: 'Destination',
                    content: widget.destination,
                    context: context,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    icon: Icons.payment,
                    label: 'Payment Method',
                    content: widget.paymentMethod,
                    context: context,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "You will receive ₦${widget.price.toStringAsFixed(2)} in cash at the end of the trip.",
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 🚕 STATUS BUTTONS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hasStartedPickup
                              ? Colors.grey
                              : Colors.purple[900],
                          foregroundColor: Colors.white,
                          elevation: 4,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: hasStartedPickup
                            ? null
                            : () async {
                                await FirebaseFirestore.instance
                                    .collection('ride_requests')
                                    .doc(widget.rideId)
                                    .update({
                                  'DriverStatus': 'en_route',
                                  'DriverStatus_updates':
                                      FieldValue.arrayUnion([
                                    {
                                      'DriverStatus': 'en_route',
                                      'timestamp': Timestamp.now()
                                    }
                                  ])
                                });

                                setState(() {
                                  hasStartedPickup = true;
                                });
                              },
                        child: const Text('Start Pickup'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hasArrivedAtPickup
                              ? Colors.grey
                              : Colors.purple[900],
                          foregroundColor: Colors.white,
                          elevation: 4,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: hasArrivedAtPickup
                            ? null
                            : () async {
                                await FirebaseFirestore.instance
                                    .collection('ride_requests')
                                    .doc(widget.rideId)
                                    .update({
                                  'DriverStatus': 'arrived',
                                  'DriverStatus_updates':
                                      FieldValue.arrayUnion([
                                    {
                                      'DriverStatus': 'arrived',
                                      'timestamp': Timestamp.now()
                                    }
                                  ])
                                });

                                setState(() {
                                  hasArrivedAtPickup = true;
                                });
                              },
                        child: const Text('Arrived at Pickup'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // 🏁 COMPLETE BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Complete Ride',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// UI Helper for Info Rows
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String content,
    required BuildContext context,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey[400], size: 18),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: MediaQuery.of(context).size.width - 100,
              child: Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            'Admin Dashboard',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildSummaryCard(),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Drivers')
                  .where('status', isEqualTo: 'pending')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading data'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No drivers found'));
                }

                final drivers = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: drivers.length,
                  itemBuilder: (context, index) {
                    final driver = drivers[index];
                    final driverData = driver.data() as Map<String, dynamic>;

                    final fullName = driverData['name'] ?? 'No Name';
                    final phoneNumber = driverData['phone'] ?? 'No Phone';
                    final vehicleType = driverData['vehicle'] ?? 'No Vehicle';
                    final status = driverData['status'] ?? 'No Status';

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(fullName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Phone: $phoneNumber'),
                            Text('Vehicle: $vehicleType'),
                            Text('Status: $status'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon:
                                  const Icon(Icons.check, color: Colors.green),
                              onPressed: () {
                                _updateDriverStatus(
                                    driver.id, 'verified', context);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                _updateDriverStatus(
                                    driver.id, 'rejected', context);
                              },
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

  /// Summary card showing stats
  Widget _buildSummaryCard() {
    return FutureBuilder<Map<String, int>>(
      future: _fetchSummaryCounts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Text('Failed to load summary (error)');
        }

        final data = snapshot.data!;
        return Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  _summaryItem('Drivers', data['drivers'] ?? 0),
                  const SizedBox(width: 16),
                  _summaryItem('Rides', data['rides'] ?? 0),
                  const SizedBox(width: 16),
                  _summaryItem('Logistics', data['logistics'] ?? 0),
                  const SizedBox(width: 16),
                  _summaryItem('Transport', data['transport'] ?? 0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Individual summary item
  Widget _summaryItem(String title, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$count',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  /// Fetches summary counts from Firestore
  Future<Map<String, int>> _fetchSummaryCounts() async {
    try {
      final driversSnapshot =
          await FirebaseFirestore.instance.collection('Drivers').get();
      final ridesSnapshot = await FirebaseFirestore.instance
          .collection('ride_requests')
          .where('Status', isEqualTo: 'driver_accepted')
          .get();
      final logisticsSnapshot = await FirebaseFirestore.instance
          .collection('logistics_requests')
          .where('status', isEqualTo: 'accepted')
          .get();
      final transportSnapshot = await FirebaseFirestore.instance
          .collection('transport_requests')
          .where('status', isEqualTo: 'accepted')
          .get();

      return {
        'drivers': driversSnapshot.size,
        'rides': ridesSnapshot.size,
        'logistics': logisticsSnapshot.size,
        'transport': transportSnapshot.size,
      };
    } catch (e) {
      print('Error fetching summary counts: $e');
      return {}; // Still return empty map so widget doesn't crash
    }
  }

  /// Updates driver status
  void _updateDriverStatus(String docId, String status, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    FirebaseFirestore.instance
        .collection('Drivers')
        .doc(docId)
        .update({'status': status}).then((_) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Driver $status successfully!'),
          duration: const Duration(seconds: 2),
        ),
      );
    }).catchError((error) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating driver status: $error'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneNumberController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> SignUp(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(strokeWidth: 6, color: Colors.black),
      ),
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateDisplayName(
            "${firstNameController.text.trim()} ${lastNameController.text.trim()}");
      }

      Navigator.pop(context); // close loading

      // Show success dialog with animation
      await showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: "",
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => const SizedBox.shrink(),
        transitionBuilder: (context, animation, secAnimation, child) {
          return ScaleTransition(
            scale:
                CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 60),
                  const SizedBox(height: 16),
                  const Text(
                    'Registered Successfully',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Login'),
                  )
                ],
              ),
            ),
          );
        },
      );

      _animationController.forward();
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error during registration: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            'SignUp',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 20),
                buildTextField(firstNameController, 'First Name'),
                const SizedBox(height: 10),
                buildTextField(lastNameController, 'Last Name'),
                const SizedBox(height: 10),
                buildTextField(emailController, 'Email',
                    keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 10),
                buildTextField(passwordController, 'Password',
                    obscureText: true),
                const SizedBox(height: 10),
                buildTextField(confirmPasswordController, 'Confirm Password',
                    obscureText: true),
                const SizedBox(height: 10),
                buildTextField(phoneNumberController, 'Phone Number',
                    keyboardType: TextInputType.phone),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => SignUp(context),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black,
                    ),
                    child: const Text('REGISTER',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        if (label == 'Email' &&
            !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        if (label == 'Password' && value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        if (label == 'Confirm Password' && value != passwordController.text) {
          return 'Passwords do not match';
        }
        if (label == 'Phone Number' && !RegExp(r'^\d{11}$').hasMatch(value)) {
          return 'Please enter a valid phone number';
        }

        return null;
      },
    );
  }
}

class RidePage extends StatefulWidget {
  final void Function(String)? onSelect;

  const RidePage({Key? key, this.onSelect}) : super(key: key);

  @override
  State<RidePage> createState() => _RidePageState();
}

class _RidePageState extends State<RidePage> {
  bool isLoading = false;

  void _handleSelection(String rideType) async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2)); // simulate loading

    if (widget.onSelect != null) {
      widget.onSelect!(rideType);
    }

    if (mounted) {
      Navigator.pop(context); // close the bottom sheet
      Navigator.pushNamed(context, '/searching'); // navigate to next screen
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> rideOptions = [
      {
        'icon': 'assets/images/man.png',
        'title': 'Bike (Okada)',
        'description': 'Quick and affordable for short distances.',
      },
      {
        'icon': 'assets/images/taxi.png',
        'title': 'Cab',
        'description': 'Comfortable rides with air conditioning.',
      },
      {
        'icon': 'assets/images/tricycle.png',
        'title': 'Tricycle',
        'description': 'Local rides for inner-city commutes.',
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: isLoading
          ? const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[500],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const Text(
                  'Choose a Ride Option',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: rideOptions.length,
                    itemBuilder: (context, index) {
                      final option = rideOptions[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        color: Colors.grey[100],
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[100],
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(
                              option['icon'],
                              fit: BoxFit.contain,
                              color: Colors.grey[700],
                            ),
                          ),
                          title: Text(
                            option['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            option['description'],
                            style: const TextStyle(color: Colors.black),
                          ),
                          onTap: () => _handleSelection(option['title']),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class SearchingScreen extends StatefulWidget {
  final String rideId;
  final String rideType;
  final String pickupLocation;
  final String destination;
  final VoidCallback onCancel;

  const SearchingScreen({
    Key? key,
    required this.rideId,
    required this.rideType,
    required this.pickupLocation,
    required this.destination,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<SearchingScreen> createState() => _SearchingScreenState();
}

class _SearchingScreenState extends State<SearchingScreen> {
  late Stream<DocumentSnapshot> rideStream;
  Timer? timer;
  double progress = 0.0;
  int cycleCount = 0;

  LatLng? userLocation;
  List<LatLng> nearbyDrivers = [];

  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  String getRideTypeImage(String rideType) {
    switch (rideType.toLowerCase()) {
      case 'cab':
        return 'assets/images/taxi.png';
      case 'bike':
        return 'assets/images/man.png';
      case 'tricycle':
        return 'assets/images/tricycle.png';
      default:
        return 'assets/images/man.png';
    }
  }

  void startTimerLoop() {
    progress = 0;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        progress += 1 / 120;
        if (progress >= 1) {
          timer.cancel();
          cycleCount++;

          if (cycleCount < 2) {
            startTimerLoop(); // Retry one more time
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Unable to find a driver. Please try again.')),
            );
            widget.onCancel();
          }
        }
      });
    });
  }

  Future<void> fetchUserLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
      _setMarkers();
    });
  }

  void loadNearbyDrivers() {
    if (userLocation != null) {
      nearbyDrivers = [
        LatLng(userLocation!.latitude + 0.001, userLocation!.longitude + 0.001),
        LatLng(userLocation!.latitude - 0.001, userLocation!.longitude - 0.001),
      ];
      _setMarkers();
    }
  }

  void _setMarkers() {
    final markers = <Marker>{};

    if (userLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('user'),
          position: userLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    for (int i = 0; i < nearbyDrivers.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId('driver_$i'),
          position: nearbyDrivers[i],
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        ),
      );
    }

    setState(() {
      _markers = markers;
    });
  }

  @override
  void initState() {
    super.initState();

    fetchUserLocation().then((_) => setState(() {
          loadNearbyDrivers();
        }));

    rideStream = FirebaseFirestore.instance
        .collection('ride_requests')
        .doc(widget.rideId)
        .snapshots();

    rideStream.listen((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>?;
      if (data != null && data['Status'] == 'driver_accepted') {
        timer?.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DriverOfferScreen(
              rideId: widget.rideId,
              driverName: data['driverId'],
              price: data['price'],
              vehicleType: data['vehicleType'],
              vehicleDescription: data['vehicleType'],
              pickup: data['Pickup Location'],
              destination: data['Destination'],
              rideType: data['RideType'],
            ),
          ),
        );
      }
    });

    startTimerLoop();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          if (userLocation != null)
            GoogleMap(
              onMapCreated: (controller) {
                _mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: userLocation!,
                zoom: 16,
              ),
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            )
          else
            const Center(child: CircularProgressIndicator()),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, -4),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Searching for a ${widget.rideType}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 8),
                      const SizedBox(
                        height: 10,
                        width: 10,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation(Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pickup Location',
                              style: TextStyle(color: Colors.grey[500])),
                          const SizedBox(height: 2),
                          Container(
                            height: 55,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.radio_button_checked,
                                      color: Colors.black, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      widget.pickupLocation,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text('Destination',
                              style: TextStyle(color: Colors.grey[500])),
                          const SizedBox(height: 2),
                          Container(
                            height: 55,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on_outlined,
                                      color: Colors.green[700], size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      widget.destination,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.black, Colors.black],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        timer?.cancel();
                        widget.onCancel();
                      },
                      child: const Text(
                        "Cancel Ride",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RideStartedScreen extends StatefulWidget {
  final String rideId;
  final String pickup;
  final String destination;
  final String rideType;
  final double price;
  final String driverName;
  final String vehicleType;
  final String vehicleDescription;
  //final String driverPhone;

  RideStartedScreen({
    //required this.driverPhone,
    required this.rideId,
    required this.pickup,
    required this.destination,
    required this.rideType,
    required this.price,
    required this.driverName,
    required this.vehicleType,
    required this.vehicleDescription,
  });

  @override
  State<RideStartedScreen> createState() => _RideStartedScreenState();
}

class _RideStartedScreenState extends State<RideStartedScreen> {
  final LatLng _defaultCenter = const LatLng(6.5244, 3.3792); // Lagos
  final String? email =
      FirebaseAuth.instance.currentUser?.email ?? 'default@deck.com';

  LatLng? userLocation;
  GoogleMapController? _mapController;

  Future<void> _initiatePaystackPayment(BuildContext context) async {
    const String paystackSecretKey =
        'sk_test_661490bf9dc0914e122c2c043ab3aaf3a307d658';
    final String email =
        FirebaseAuth.instance.currentUser?.email ?? "user@deck.com";
    final int amount = (widget.price * 100).toInt();
    final String reference = "deck_${DateTime.now().millisecondsSinceEpoch}";

    final Uri url = Uri.parse('https://api.paystack.co/transaction/initialize');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $paystackSecretKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
          {'email': email, 'amount': amount, 'reference': reference}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final String checkoutUrl = responseData['data']['authorization_url'];

      if (await canLaunchUrl(Uri.parse(checkoutUrl))) {
        await launchUrl(Uri.parse(checkoutUrl),
            mode: LaunchMode.externalApplication);

        // After payment redirect, give user time to return to app then update status
        Future.delayed(const Duration(seconds: 8), () {
          FirebaseFirestore.instance
              .collection('ride_requests')
              .doc(widget.rideId)
              .update({'status': 'completed'}).then((_) {
            _showRideCompletedDialog(context);
          });
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open payment page')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment initiation failed')));
    }
  }

  void _showRideCompletedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ride Completed 🎉"),
        content: const Text("Thank you for riding with Deck Mobility!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Exit Ride Page
            },
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    FirebaseFirestore.instance
        .collection('ride_requests')
        .doc(widget.rideId)
        .update({'DriverStatus': 'awaiting_pickup'});
  }

  Future<void> _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // MAP BACKGROUND
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: userLocation ?? _defaultCenter,
              zoom: 15,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),

          // APP BAR OVERLAY
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            right: 16,
            child: const Row(
              children: [
                SizedBox(width: 12),
                Center(
                  child: Text(
                    "",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // DETAILS AT THE BOTTOM
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pickup Location',
                          style: TextStyle(color: Colors.grey[400])),
                      Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(Icons.radio_button_checked,
                                  color: Colors.green, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(widget.pickup,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text('Destination',
                          style: TextStyle(
                            color: Colors.grey[400],
                          )),
                      Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: Colors.red, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(widget.destination,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Driver Details
                  const Center(
                    child: Text(
                      "Driver Details",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),

                  // Driver Info
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 3,
                    color: Colors.grey[100],
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey.shade300,
                                child: const Icon(Icons.person,
                                    color: Colors.black),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                widget.driverName,
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey.shade300,
                                child: const Icon(Icons.directions_car,
                                    color: Colors.black),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                widget.vehicleType,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Center(
                            child: Row(
                              children: [
                                Text('Status',
                                    style: TextStyle(
                                      color: Colors.black,
                                    )),
                                Spacer(),
                                Icon(Icons.verified,
                                    color: Colors.green, size: 18),
                                SizedBox(width: 6),
                                Text("Verified",
                                    style: TextStyle(color: Colors.green)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Driver Status
                  // Driver Status
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('ride_requests')
                        .doc(widget.rideId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      final status = data['DriverStatus'];

                      String statusText = "Awaiting Pickup";
                      if (status == 'en_route')
                        statusText = "Driver On His Way";
                      if (status == 'arrived')
                        statusText = "Your Driver Arrived";

                      return Container(
                        height: 30,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[500],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            statusText,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  // Pay Button
                  ElevatedButton(
                    onPressed: () => _initiatePaystackPayment(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text("Pay ₦${widget.price.toStringAsFixed(2)}"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// WebView widget to load Paystack payment page
class PaystackWebView extends StatelessWidget {
  final String checkoutUrl;

  PaystackWebView({required this.checkoutUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complete Payment")),
      body: WebViewWidget(
        controller: WebViewController()
          ..loadRequest(Uri.parse(checkoutUrl))
          ..setJavaScriptMode(JavaScriptMode.unrestricted),
      ),
    );
  }
}

class DriverOfferScreen extends StatelessWidget {
  final String rideId;
  final String driverName;
  final double price;
  final String vehicleType;
  final String vehicleDescription;
  final String pickup;
  final String destination;
  final String rideType;

  const DriverOfferScreen({
    Key? key,
    required this.rideId,
    required this.driverName,
    required this.price,
    required this.vehicleType,
    required this.vehicleDescription,
    required this.pickup,
    required this.destination,
    required this.rideType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            '',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Padding(
        // backgroundColor: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('You Got An Offer',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.purple[900],
                  )),
              const SizedBox(height: 10),
              Image.asset(
                'assets/images/accept.png',
                width: 35,
                height: 35,
              ),
            ]),
            const SizedBox(height: 8),
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Center(
                        child: Text('Offer Details',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 15,
                            ))),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          child: const Icon(Icons.person, color: Colors.black),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${driverName}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          child: const Icon(Icons.directions_car,
                              color: Colors.black),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "$vehicleDescription",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child:
                            Text("Price Offered  ₦${price.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.purple[900],
                                )),
                      ),
                    ),
                    //SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              width: 320,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to RideStartedScreen with full details
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RideStartedScreen(
                        rideId: rideId,
                        pickup: pickup,
                        destination: destination,
                        rideType: rideType,
                        price: price,
                        driverName: driverName,
                        vehicleType: vehicleType,
                        vehicleDescription: vehicleDescription,
                      ),
                    ),
                  );
                },
                child: const Text("Accept",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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

class TransportDriverPage extends StatelessWidget {
  const TransportDriverPage({super.key});

  void _updateRequestStatus(String docId, String status) {
    FirebaseFirestore.instance
        .collection('transport_requests')
        .doc(docId)
        .update({
      'status': status,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            'Transport Requests',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('transport_requests')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error fetching requests"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.purple));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No transport requests available"));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Name: ${data['name']}",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(
                          "From: ${data['pickupCity']} → To: ${data['destinationCity']}"),
                      const SizedBox(height: 6),
                      Text("Vehicle Type: ${data['vehicleType']}"),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () =>
                                _updateRequestStatus(doc.id, 'Accepted'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Accept"),
                          ),
                          OutlinedButton(
                            onPressed: () =>
                                _updateRequestStatus(doc.id, 'Declined'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black,
                            ),
                            child: const Text("Decline"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class PackageTrackingViewPage extends StatelessWidget {
  final Map<String, dynamic> packageData;

  const PackageTrackingViewPage({Key? key, required this.packageData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            'Track Package',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              const BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              const Text("Package Information",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildInfo("Service Type", packageData['serviceType']),
              _buildInfo("Package Name", packageData['packageName']),
              _buildInfo("Category", packageData['category']),
              _buildInfo("Pickup Address", packageData['pickupAddress']),
              _buildInfo("Delivery Address", packageData['deliveryAddress']),
              _buildInfo("Sender Name", packageData['senderName']),
              _buildInfo("Sender Contact", packageData['senderContact']),
              _buildInfo("Receiver Name", packageData['receiverName']),
              _buildInfo("Receiver Contact", packageData['receiverContact']),
              _buildInfo("Status", packageData['status']),
              if (packageData.containsKey('trackingId'))
                _buildInfo("Tracking ID", packageData['trackingId']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, softWrap: true)),
        ],
      ),
    );
  }
}

class LogisticsPage extends StatefulWidget {
  const LogisticsPage({super.key});
  @override
  State<LogisticsPage> createState() => _LogisticsPageState();
}

class _LogisticsPageState extends State<LogisticsPage> {
  final TextEditingController _trackingIdController = TextEditingController();
  String _selectedTab = "pending"; // pending | completed

  void _searchTrackingId() async {
    final trackingId = _trackingIdController.text.trim();

    if (trackingId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a tracking ID')),
      );
      return;
    }

    try {
      final query = await FirebaseFirestore.instance
          .collection('logistics_requests')
          .where('trackingId', isEqualTo: trackingId)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final doc = query.docs.first;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PackageTrackingViewPage(packageData: doc.data()!),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No shipment found with that ID')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Stream<QuerySnapshot> _userLogisticsRequests() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('logistics_requests')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            'Logistics',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Search Field
            const Text("Track Order",
                style: TextStyle(
                    //fontWeight: FontWeight.bold,
                    fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              controller: _trackingIdController,
              decoration: InputDecoration(
                hintText: "Enter Tracking ID",
                filled: true,
                fillColor: Colors.white,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchTrackingId,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  // borderSide: const BorderSide(color: Colors.black12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Redesigned Service Cards (Instant & Waybills)
            Row(
              children: [
                Expanded(
                  child: _ServiceCard(
                    title: "Instant",
                    description: "Send packages within your city.",
                    iconPath: "assets/images/transport (1).png",
                    onTap: () => _openService("Lastmile Delivery"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _ServiceCard(
                    title: "Waybills",
                    description: "Send packages nationwide safely.",
                    iconPath: "assets/images/waybill (2).png",
                    onTap: () => _openService("Waybills"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            /// 🔹 Tabs (Pending / Completed)
            StreamBuilder<QuerySnapshot>(
              stream: _userLogisticsRequests(),
              builder: (context, snapshot) { 
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No activity here"));
                }

                final docs = snapshot.data?.docs ?? [];

                /// 🔥 COUNTS
                final pendingCount = docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final status =
                      (data['status'] ?? '').toString().toLowerCase();
                  return status != "completed";
                }).length;

                final completedCount = docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final status =
                      (data['status'] ?? '').toString().toLowerCase();
                  return status == "completed";
                }).length;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🔹 Tabs NOW HAVE ACCESS TO COUNTS
                    _buildSegmentedTabs(
                      pendingCount: pendingCount,
                      completedCount: completedCount,
                    ),
                    const SizedBox(height: 15),

                    /// 🔥 FILTER LOGIC
                    ...docs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final status =
                          (data['status'] ?? '').toString().toLowerCase();

                      if (_selectedTab == "completed") {
                        return status == "completed";
                      } else {
                        return status != "completed";
                      }
                    }).map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final packageName = data['packageName'] ?? '';
                      final price = data['proposedCost'] ?? '';
                      final status = data['status'] ?? '';
                      final createdAt =
                          (data['createdAt'] as Timestamp).toDate();

                      Color statusColor;
                      switch (status.toLowerCase()) {
                        case 'awaiting_pickup':
                        case 'picked_up':
                          statusColor = Colors.orange;
                          break;
                        case 'completed':
                          statusColor = Colors.green;
                          break;
                        default:
                          statusColor = Colors.blueGrey;
                      }

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OrderPlacedPage(orderId: doc.id),
                            ),
                          );
                        },
                        child: Container(
                          height: 75,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/up-right.png",
                                height: 25,
                                width: 25,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      packageName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "₦$price",
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      status,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: statusColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    DateFormat('dd/MM/yyyy').format(createdAt),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentedTabs({
    required int pendingCount,
    required int completedCount,
  }) {
    final isPending = _selectedTab == "pending";

    return Container(
      height: 50,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth / 2;

          return Stack(
            children: [
              /// 🔥 SLIDING BACKGROUND
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                left: isPending ? 0 : width,
                top: 0,
                bottom: 0,
                child: Container(
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),

              /// 🔥 TAB BUTTONS
              Row(
                children: [
                  Expanded(
                    child: _segmentItem(
                      label: "Pending",
                      value: "pending",
                      count: pendingCount,
                    ),
                  ),
                  Expanded(
                    child: _segmentItem(
                      label: "Completed",
                      value: "completed",
                      count: completedCount,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _segmentItem({
    required String label,
    required String value,
    required int count,
  }) {
    final isSelected = _selectedTab == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = value;
        });
      },
      child: Container(
        color: Colors.transparent,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              child: Text(label),
            ),
            const SizedBox(width: 6),

            /// 🔥 BADGE
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openService(String serviceType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PackageDetailsPage(serviceType: serviceType),
      ),
    );
  }

  // 🔹 New Service Card Widget
  Widget _ServiceCard({
    required String title,
    required String description,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 160,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /// 🔥 ROW 1 → ICON + TITLE
            Row(
              children: [
                Container(
                  height: 43,
                  width: 43,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[100], // keeps icon visible
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(iconPath),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black, // ✅ PURE WHITE
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// 🔥 ROW 2 → DESCRIPTION
            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey[700], // softer white
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PackageDetailsPage extends StatefulWidget {
  final String serviceType;
  const PackageDetailsPage({Key? key, required this.serviceType})
      : super(key: key);

  @override
  State<PackageDetailsPage> createState() => _PackageDetailsPageState();
}

class _PackageDetailsPageState extends State<PackageDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  final _packageNameController = TextEditingController();
  final _pickupAddressController = TextEditingController();
  final _deliveryAddressController = TextEditingController();
  final _senderNameController = TextEditingController();
  final _senderContactController = TextEditingController();
  final _receiverNameController = TextEditingController();
  final _receiverContactController = TextEditingController();

  bool _useSavedSender = false;
  int _currentStep = 0;
  String? _selectedCategory;

  final List<String> _categories = [
    'Document',
    'Electronics',
    'Clothing',
    'Food',
    'Other'
  ];

  // ================= LOGISTICS ROUTES =================
  List<Map<String, dynamic>> _routes = [];

  String? _selectedFromCity;
  String? _selectedToCity;
  int? _calculatedPrice;

  @override
  void initState() {
    super.initState();
    _fetchRoutes();
  }

  Future<void> _fetchRoutes() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('logistics_routes').get();

    setState(() {
      _routes = snapshot.docs.map((e) => e.data()).toList();
    });
  }

  List<String> _getCities() {
    return _routes.map((e) => e['city'].toString()).toSet().toList();
  }

  List<Map<String, dynamic>> _getDestinations(String city) {
    final route = _routes.firstWhere(
      (r) => r['city'] == city,
      orElse: () => {},
    );

    if (route.isEmpty) return [];

    return List<Map<String, dynamic>>.from(route['destinations'] ?? []);
  }

  void _calculatePrice() {
    if (_selectedFromCity == null || _selectedToCity == null) return;

    final dests = _getDestinations(_selectedFromCity!);

    final match = dests.firstWhere(
      (d) => d['name'] == _selectedToCity,
      orElse: () => {},
    );

    setState(() {
      _calculatedPrice =
          match.isNotEmpty ? (match['price'] as num).toInt() : null;
    });
  }

  // ================= LOAD SAVED SENDER =================
  Future<void> _loadSavedSender() async {
    final prefs = await SharedPreferences.getInstance();

    if (!_useSavedSender) return;

    setState(() {
      _senderNameController.text = prefs.getString('senderName') ?? '';
      _senderContactController.text = prefs.getString('senderContact') ?? '';
      _pickupAddressController.text = prefs.getString('pickupAddress') ?? '';
    });
  }

  Future<void> _saveSenderDetails() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('senderName', _senderNameController.text.trim());
    await prefs.setString(
        'senderContact', _senderContactController.text.trim());
    await prefs.setString(
        'pickupAddress', _pickupAddressController.text.trim());
  }

  // ================= VALIDATION =================
  bool _validateStep(int step) {
    switch (step) {
      case 0:
        return _packageNameController.text.isNotEmpty &&
            _selectedCategory != null;
      case 1:
        return _senderNameController.text.isNotEmpty &&
            _senderContactController.text.isNotEmpty &&
            _pickupAddressController.text.isNotEmpty;
      default:
        return false;
    }
  }

  void _updateStepProgress() {
    if (_currentStep == 0 && _validateStep(0)) {
      setState(() => _currentStep = 1);
    } else if (_currentStep == 1 && _validateStep(1)) {
      _saveSenderDetails();
      setState(() => _currentStep = 2);
    }
  }

  // ================= PREVIEW =================
  void _goToPreview() {
    if (!_formKey.currentState!.validate() || _selectedCategory == null) return;

    final trackingId = 'TRK-${const Uuid().v4().substring(0, 8).toUpperCase()}';

    final userId = FirebaseAuth.instance.currentUser!.uid;

    final data = {
      'serviceType': widget.serviceType,
      'packageName': _packageNameController.text.trim(),
      'category': _selectedCategory!,
      'pickupAddress': _pickupAddressController.text.trim(),
      'deliveryAddress': _deliveryAddressController.text.trim(),
      'senderName': _senderNameController.text.trim(),
      'senderContact': _senderContactController.text.trim(),
      'receiverName': _receiverNameController.text.trim(),
      'receiverContact': _receiverContactController.text.trim(),
      'trackingId': trackingId,
      'userId': userId,

      // 🔥 LOGISTICS DATA ADDED
      'fromCity': _selectedFromCity,
      'toCity': _selectedToCity,
      'price': _calculatedPrice,
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PackagePreviewPage(packageData: data),
      ),
    );
  }

  // ================= CITY DROPDOWN =================
  Widget _cityDropdown() {
    final cities = _getCities();

    return DropdownButtonFormField<String>(
      value: _selectedFromCity,
      decoration: _inputDecoration("Pickup City"),
      items: cities
          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
          .toList(),
      onChanged: (val) {
        setState(() {
          _selectedFromCity = val;
          _selectedToCity = null;
          _calculatedPrice = null;
        });
        _updateStepProgress();
      },
    );
  }

  Widget _destinationDropdown() {
    if (_selectedFromCity == null) {
      return const Text("Select pickup city first");
    }

    final dests = _getDestinations(_selectedFromCity!);

    return DropdownButtonFormField<String>(
      value: _selectedToCity,
      decoration: _inputDecoration("Delivery Destination"),
      items: dests.map<DropdownMenuItem<String>>((d) {
        final name = d['name'];

        if (name == null) {
          return const DropdownMenuItem<String>(
            value: "",
            child: Text("Invalid destination"),
          );
        }

        return DropdownMenuItem<String>(
          value: name.toString(),
          child: Text(name.toString()),
        );
      }).toList(),
      onChanged: (val) {
        setState(() {
          _selectedToCity = val;
          _calculatePrice();
        });
        _updateStepProgress();
      },
    );
  }

  // ================= SECTION CARD (UNCHANGED) =================
  Widget _sectionCard({
    required int step,
    required Widget child,
    Widget? iconWidget,
    IconData? icon,
    required String title,
    required String subtitle,
  }) {
    bool enabled = _currentStep >= step;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: enabled ? 1 : 0.4,
      child: AbsorbPointer(
        absorbing: !enabled,
        child: Container(
          margin: const EdgeInsets.only(bottom: 18),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (iconWidget != null)
                    iconWidget
                  else if (icon != null)
                    Icon(icon),
                  const SizedBox(width: 8),
                  Text(title,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text("${step + 1} of 3",
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[900]))
                ],
              ),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              const SizedBox(height: 16),
              child
            ],
          ),
        ),
      ),
    );
  }

  // ================= SECTIONS =================
  Widget _packageSection() {
    return Column(
      children: [
        _buildTextField(_packageNameController, 'Package Name',
            onChanged: (_) => _updateStepProgress()),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          decoration: _inputDecoration('Category'),
          items: _categories
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) {
            setState(() => _selectedCategory = val);
            _updateStepProgress(); // 🔥 THIS WAS MISSING
          },
        ),
        const SizedBox(height: 12),
        _cityDropdown(),
        const SizedBox(height: 12),
        _destinationDropdown(),
      ],
    );
  }

  Widget _senderSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            setState(() => _useSavedSender = !_useSavedSender);
            if (_useSavedSender) await _loadSavedSender();
          },
          child: Row(
            children: [
              // Spacer(),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 1),
                  color: _useSavedSender ? Colors.black : Colors.transparent,
                ),
                child: _useSavedSender
                    ? const Icon(Icons.check, size: 10, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 8),
              const Text("Use my details", style: TextStyle(fontSize: 10)),
            ],
          ),
        ),
        SizedBox(height: 8),
        _buildTextField(
          _senderNameController,
          "Sender Name",
          onChanged: (_) => _updateStepProgress(),
        ),
        const SizedBox(height: 12),
        _buildTextField(
          _senderContactController,
          "Phone",
          keyboardType: TextInputType.phone,
          onChanged: (_) => _updateStepProgress(),
        ),
        SizedBox(height: 12),
        _buildTextField(
          _pickupAddressController,
          "Pickup Location",
          onChanged: (_) => _updateStepProgress(),
        ),
      ],
    );
  }

  Widget _receiverSection() {
    return Column(
      children: [
        _buildTextField(_receiverNameController, "Receiver Name"),
        const SizedBox(height: 12),
        _buildTextField(_receiverContactController, "Phone",
            keyboardType: TextInputType.phone),
        const SizedBox(height: 12),
        _buildTextField(_deliveryAddressController, "Delivery Location"),
      ],
    );
  }

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            '',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                Center(
                  child: Container(
                    height: 70,
                    width: 350,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'Fill out the details below to send packages instantly.',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                ),
                _sectionCard(
                  step: 0,
                  iconWidget: Image.asset('assets/images/package.png',
                      width: 24, height: 24),
                  title: "Package Details",
                  subtitle: "Tell us what you are sending",
                  child: _packageSection(),
                ),
                _sectionCard(
                  step: 1,
                  iconWidget: Image.asset('assets/images/supplier.png',
                      width: 24, height: 24),
                  title: "Sender Details",
                  subtitle: "Where should we pickup this package ?",
                  child: _senderSection(),
                ),
                _sectionCard(
                  step: 2,
                  iconWidget: Image.asset('assets/images/traveling.png',
                      width: 24, height: 24),
                  title: "Receiver Details",
                  subtitle: "Where should we deliver this package ?",
                  child: _receiverSection(),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _goToPreview,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      );

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text,
      Function(String)? onChanged}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: _inputDecoration(label),
    );
  }
}

class PackagePreviewPage extends StatelessWidget {
  final Map<String, dynamic> packageData;

  const PackagePreviewPage({Key? key, required this.packageData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serviceType = packageData['serviceType'] ?? 'Package Details';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),
        title: const Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text(
            'Package Preview',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              elevation: 4,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "Confirm Details",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// 🔹 EXISTING UI
                    _buildServicePreviewUI(serviceType),

                    /// 🔥 NEW: FROM / TO
                    if (packageData['fromCity'] != null)
                      _buildDetail("From", packageData['fromCity']),
                    if (packageData['toCity'] != null)
                      _buildDetail("To", packageData['toCity']),

                    const SizedBox(height: 10),

                    /// 🔥 NEW: PRICE DISPLAY
                    if (packageData['price'] != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "₦${packageData['price']}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              //side: const BorderSide(color: Colors.black),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text("Go Back",
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () =>
                                _payAndCreateOrder(context), // 🔥 UPDATED
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Pay",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 🔥 PAYSTACK + ORDER CREATION
  Future<void> _payAndCreateOrder(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    const String paystackKey =
        'sk_test_661490bf9dc0914e122c2c043ab3aaf3a307d658';

    final int amount =
        (double.parse(packageData['price'].toString()) * 100).toInt();

    final String reference = "log_${DateTime.now().millisecondsSinceEpoch}";

    final Uri url = Uri.parse('https://api.paystack.co/transaction/initialize');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Processing payment..."),
          ],
        ),
      ),
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $paystackKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': user.email,
          'amount': amount,
          'reference': reference,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception("Payment initialization failed");
      }

      final checkoutUrl =
          jsonDecode(response.body)['data']['authorization_url'];

      if (await canLaunchUrl(Uri.parse(checkoutUrl))) {
        await launchUrl(Uri.parse(checkoutUrl),
            mode: LaunchMode.externalApplication);
      }

      /// ⚠️ TEMP: Assume payment success
      final trackingId = packageData['trackingId'];
      final pickupCode = _generateCode();
      final deliveryCode = _generateCode();

      await FirebaseFirestore.instance
          .collection('logistics_requests')
          .doc(trackingId)
          .set({
        ...packageData,
        'status': 'pending',
        'paymentStatus': 'paid',
        'paymentReference': reference,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'assignedAgent': null,
        'pickupCode': pickupCode,
        'deliveryCode': deliveryCode,
      });

      Navigator.pop(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrderPlacedPage(orderId: trackingId),
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // 🔹 UNTOUCHED
  Widget _buildServicePreviewUI(String serviceType) {
    switch (serviceType) {
      case "Instant pickup and delivery":
        return _instantDeliveryPreview();
      case "Waybills":
        return _waybillsPreview();
    }
    return _defaultPreview();
  }

  String _generateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rand = Random();

    return String.fromCharCodes(
      Iterable.generate(
        5,
        (_) => chars.codeUnitAt(rand.nextInt(chars.length)),
      ),
    );
  }

  Widget _instantDeliveryPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetail("Service Type", "Instant pickup and delivery"),
        _buildDetail("Package Name", packageData['packageName']),
        _buildDetail("Category", packageData['category']),
        _buildDetail("Pickup Address", packageData['pickupAddress']),
        _buildDetail("Delivery Address", packageData['deliveryAddress']),
        _buildDetail("Sender Name", packageData['senderName']),
        _buildDetail("Sender Contact", packageData['senderContact']),
        _buildDetail("Receiver Name", packageData['receiverName']),
        _buildDetail("Receiver Contact", packageData['receiverContact']),
        _buildDetail("Expected Pickup Time", packageData['extraField']),
        const SizedBox(height: 10),
        Text("Tracking ID: ${packageData['trackingId']}",
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.deepPurple)),
      ],
    );
  }

  Widget _waybillsPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetail("Service Type", "Waybills"),
        _buildDetail("Item Name", packageData['packageName']),
        _buildDetail("Invoice/Waybill", packageData['extraField']),
        _buildDetail("Sender Name", packageData['senderName']),
        _buildDetail("Receiver Name", packageData['receiverName']),
        const SizedBox(height: 10),
        Text("Tracking ID: ${packageData['trackingId']}",
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.deepPurple)),
      ],
    );
  }

  Widget _defaultPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetail("Package Name", packageData['packageName']),
        _buildDetail("Pickup Address", packageData['pickupAddress']),
        _buildDetail("Delivery Address", packageData['deliveryAddress']),
        const SizedBox(height: 10),
        Text("Tracking ID: ${packageData['trackingId']}",
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.deepPurple)),
      ],
    );
  }

  Widget _buildDetail(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$title: ", style: const TextStyle(color: Colors.black87)),
          Expanded(
            child: Text(
              value ?? '-',
              style: const TextStyle(
                  color: Colors.black54, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderPlacedPage extends StatelessWidget {
  final String orderId;
  const OrderPlacedPage({super.key, required this.orderId});

  /// ✅ Automatically format Nigerian numbers
  String formatNigerianNumber(String phone) {
    phone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    if (phone.startsWith('0')) return '234${phone.substring(1)}';
    if (phone.startsWith('+234')) return phone.substring(1);
    if (phone.startsWith('234')) return phone;
    return phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            '',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('logistics_requests')
            .doc(orderId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final order = snapshot.data!.data() as Map<String, dynamic>? ?? {};

          String getSafe(String key, [String fallback = 'N/A']) {
            final value = order[key];
            if (value == null) return fallback;
            return value.toString();
          }

          final trackingId = getSafe('trackingId');
          final status = getSafe('status', 'pending');

          final packageName = getSafe('packageName');
          final pickupCode = getSafe('pickupCode');
          final deliveryCode = getSafe('deliveryCode');

          final pickupAddress = getSafe('pickupAddress');
          final deliveryAddress = getSafe('deliveryAddress');

          final senderName = getSafe('senderName');
          final receiverName = getSafe('receiverName');
          final receiverContact = getSafe('receiverContact');
          final price = getSafe('price', '0');

          Color getStatusColor(String status) {
            switch (status.toLowerCase()) {
              case 'pending':
                return Colors.grey;
              case 'accepted':
                return Colors.orange;
              case 'pickedup':
                return Colors.blue;
              case 'completed':
                return Colors.green;
              default:
                return Colors.grey;
            }
          }

          bool isStepCompleted(String step, String status) {
            final s = status.toLowerCase();

            switch (step) {
              case 'pending':
                return true;

              case 'accepted':
                return s == 'accepted' || s == 'pickedup' || s == 'completed';

              case 'pickedup':
                return s == 'pickedup' || s == 'completed';

              case 'completed':
                return s == 'completed';

              default:
                return false;
            }
          }

          Widget _codeCard(String code) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                code,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔹 ORDER ID
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Package ID",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Flexible(
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 160),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              trackingId,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: trackingId));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Order ID copied")),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.copy, size: 14),
                              SizedBox(width: 6),
                              Text(
                                "Copy",
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  /// 🔹 STATUS
                  Center(
                      child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// 🔥 DYNAMIC STATUS TEXT
                          Text(
                            status == "pending"
                                ? "Delivery agent is on his way to pickup this order."
                                : status == "pickedup"
                                    ? "Package picked up, on its way to $receiverName."
                                    : "Package delivered successfully.",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),

                          const SizedBox(height: 12),

                          /// 🔥 CODE CARD
                          if (status == "pending") _codeCard(pickupCode),

                          if (status == "pickedup")
                            Row(
                              children: [
                                Expanded(child: _codeCard(deliveryCode)),

                                const SizedBox(width: 10),

                                /// SHARE BUTTON
                                GestureDetector(
                                  onTap: () async {
                                    final formattedNumber = receiverContact
                                        .replaceAll(RegExp(r'[^\d+]'), '');

                                    final url = Uri.parse(
                                      "https://wa.me/$formattedNumber?text=${Uri.encodeComponent("Hey $receiverName, you have a package coming your way from $senderName. Delivery code: $deliveryCode")}",
                                    );

                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url,
                                          mode: LaunchMode.externalApplication);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.send,
                                        color: Colors.white, size: 18),
                                  ),
                                )
                              ],
                            ),
                        ],
                      ),
                    ),
                  )),

                  const SizedBox(height: 20),

                  /// 🔹 DELIVERY TIMELINE
                  const Text("Delivery Progress",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  _VerticalTimeline(
                    steps: [
                      _TimelineData(
                        title: "Order Placed",
                        subtitle: "Assigning agent to pickup package.",
                        completed: isStepCompleted('pending', status),
                        color: Colors.grey,
                      ),
                      _TimelineData(
                        title: "Agent Assigned",
                        subtitle: "Agent on his way.",
                        completed: isStepCompleted('accepted', status),
                        color: Colors.orange,
                      ),
                      _TimelineData(
                        title: "Picked Up",
                        subtitle:
                            "Package pickedup, will shortly be delivered.",
                        completed: isStepCompleted('pickedup', status),
                        color: Colors.blue,
                      ),
                      _TimelineData(
                        title: "Delivered",
                        subtitle: "Package delivered successfully.",
                        completed: isStepCompleted('completed', status),
                        color: Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  /// 🔹 ORDER DETAILS
                  const Text("Order Details",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          infoRow("Package:", packageName),
                          infoRow("Pickup Address:", pickupAddress),
                          infoRow("Delivery Address:", deliveryAddress),
                          infoRow("Sender:", senderName),
                          infoRow(
                              "Receiver:", "$receiverName ($receiverContact)"),
                          const Divider(),
                          infoRow("Delivery Fee", "₦$price", highlight: true),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget infoRow(String title, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
          Text(
            value,
            style: TextStyle(
              fontWeight: highlight ? FontWeight.bold : FontWeight.w400,
              fontSize: 15,
              color: highlight ? Colors.green[700] : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

/// 🔹 VERTICAL TIMELINE
class _VerticalTimeline extends StatelessWidget {
  final List<_TimelineData> steps;
  const _VerticalTimeline({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: steps.asMap().entries.map((entry) {
        int index = entry.key;
        _TimelineData step = entry.value;
        bool isLast = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Circle + Line
            Column(
              children: [
                _TimelineCircle(step: step),
                if (!isLast)
                  Container(
                    width: 4,
                    height: 50,
                    color: step.completed ? step.color : Colors.grey[300],
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(child: _TimelineContent(step: step)),
          ],
        );
      }).toList(),
    );
  }
}

class _TimelineCircle extends StatelessWidget {
  final _TimelineData step;
  const _TimelineCircle({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: step.completed ? step.color : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: step.color, width: 2),
      ),
      child: Center(
        child: step.completed
            ? const Icon(Icons.check, color: Colors.white, size: 12)
            : null,
      ),
    );
  }
}

class _TimelineContent extends StatelessWidget {
  final _TimelineData step;
  const _TimelineContent({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: step.completed ? 1 : 0.4, // 🔥 shadowed effect
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            step.title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            step.subtitle,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _TimelineData {
  final String title;
  final String subtitle;
  final bool completed;
  final Color color;

  _TimelineData({
    required this.title,
    required this.subtitle,
    required this.completed,
    required this.color,
  });
}

class LogisticsAdminDashboard extends StatefulWidget {
  const LogisticsAdminDashboard({Key? key}) : super(key: key);

  @override
  State<LogisticsAdminDashboard> createState() =>
      _LogisticsAdminDashboardState();
}

class _LogisticsAdminDashboardState extends State<LogisticsAdminDashboard> {
  String selectedFilter = "new";

  Stream<QuerySnapshot> _getRequests() {
    return FirebaseFirestore.instance
        .collection('logistics_requests')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Color _statusColor(String status) {
    switch (status) {
      case "pending":
        return Colors.orange;
      case "completed":
        return Colors.green;
      case "assigned":
        return Colors.blue;
      default:
        return Colors.red;
    }
  }

  bool _filterMatch(String status) {
    if (selectedFilter == "new") return status == "new";
    if (selectedFilter == "pending") return status == "pending";
    if (selectedFilter == "completed") return status == "completed";
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child:
              const Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
        ),
        title: const Text(
          "Logistics Admin",
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 10),

          // ================= MANAGE ROUTES BUTTON =================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: navigate to your existing routes page
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => AddRoutePage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Manage Routes",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ================= FILTER CHIPS =================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _chip("New"),
                _chip("Pending"),
                _chip("Completed"),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ================= REQUEST LIST =================
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getRequests(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Center(child: Text("No requests yet"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;

                    final status = data['status'] ?? 'new';

                    if (!_filterMatch(status)) {
                      return const SizedBox.shrink();
                    }

                    return _requestCard(data, docs[index].id);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================= CHIP =================
  Widget _chip(String label) {
    final isSelected = selectedFilter == label.toLowerCase();

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label.toLowerCase();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ================= REQUEST CARD =================
  Widget _requestCard(Map<String, dynamic> data, String docId) {
    final status = data['status'] ?? 'new';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOP ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data['packageName'] ?? 'Package',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: _statusColor(status),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 10),

            Text("From: ${data['pickupAddress'] ?? '-'}"),
            Text("To: ${data['deliveryAddress'] ?? '-'}"),
            Text("Sender: ${data['senderName'] ?? '-'}"),
            Text("Receiver: ${data['receiverName'] ?? '-'}"),

            const SizedBox(height: 10),

            Text(
              "Tracking ID: ${data['trackingId'] ?? '-'}",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 12),

            // ================= ACTION BUTTONS =================
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('logistics_requests')
                          .doc(docId)
                          .update({'status': 'completed'});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text("Mark Done"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('logistics_requests')
                          .doc(docId)
                          .update({'status': 'pending'});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text("Pending"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AddRoutePage extends StatefulWidget {
  const AddRoutePage({super.key});

  @override
  State<AddRoutePage> createState() => _AddRoutePageState();
}

class _AddRoutePageState extends State<AddRoutePage> {
  bool showManageRoutes = false;
  bool _isSaving = false;

  final TextEditingController cityController = TextEditingController();

  List<TextEditingController> destinationControllers = [];
  List<TextEditingController> priceControllers = [];

  @override
  void initState() {
    super.initState();
    _addDestinationField();
  }

  void _addDestinationField() {
    destinationControllers.add(TextEditingController());
    priceControllers.add(TextEditingController());
    setState(() {});
  }

  void _removeDestinationField(int index) {
    destinationControllers[index].dispose();
    priceControllers[index].dispose();

    destinationControllers.removeAt(index);
    priceControllers.removeAt(index);

    setState(() {});
  }

  Future<void> _saveRoute() async {
    if (cityController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("City name is required")),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      List<Map<String, dynamic>> destinations = [];

      for (int i = 0; i < destinationControllers.length; i++) {
        final dest = destinationControllers[i].text.trim();
        final priceText = priceControllers[i].text.trim();

        if (dest.isNotEmpty && priceText.isNotEmpty) {
          destinations.add({
            "name": dest,
            "price": double.tryParse(priceText) ?? 0,
          });
        }
      }

      if (destinations.isEmpty) {
        setState(() => _isSaving = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Add at least one destination")),
        );
        return;
      }

      await FirebaseFirestore.instance
          .collection("logistics_routes")
          .doc(cityController.text.trim())
          .set({
        "city": cityController.text.trim(),
        "destinations": destinations,
        "updatedAt": FieldValue.serverTimestamp(),
      });

      // reset UI
      cityController.clear();
      destinationControllers.clear();
      priceControllers.clear();
      _addDestinationField();

      setState(() => _isSaving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Route saved successfully ✅")),
      );
    } catch (e) {
      setState(() => _isSaving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving route: $e")),
      );
    }
  }

  Widget _buildAddRouteForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        TextField(
          controller: cityController,
          decoration: InputDecoration(
            labelText: "City Name",
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Destinations & Prices",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: destinationControllers.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: destinationControllers[index],
                      decoration: InputDecoration(
                        labelText: "Destination",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: priceControllers[index],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Price",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => _removeDestinationField(index),
                  )
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        TextButton.icon(
          onPressed: _addDestinationField,
          icon: const Icon(Icons.add),
          label: const Text("Add Destination"),
        ),
        const SizedBox(height: 20),
        SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _saveRoute,
              child: _isSaving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text("Save Route"),
            )),
      ],
    );
  }

  Widget _buildManageRoutes() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection("logistics_routes").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;

            final destinations = (data['destinations'] as List?) ?? [];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['city'] ?? '',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ...destinations.map((d) {
                      return Text(
                        "${d['name']} - ₦${d['price']}",
                      );
                    }).toList(),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              showManageRoutes = false;
                              cityController.text = data['city'];
                            });
                          },
                          child: const Text("Edit"),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 🔹 iOS BACK BUTTON
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),
        title: const Text(
          "Add Route",
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 TOGGLE BUTTON
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showManageRoutes = !showManageRoutes;
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: Text(
                showManageRoutes ? "Add Route" : "Manage Routes",
                style: const TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 CONTENT SWITCH
            Expanded(
              child: showManageRoutes
                  ? _buildManageRoutes()
                  : SingleChildScrollView(child: _buildAddRouteForm()),
            ),
          ],
        ),
      ),
    );
  }
}

class LogisticsDeliveryPage extends StatefulWidget {
  final String requestId;

  const LogisticsDeliveryPage({super.key, required this.requestId});

  @override
  State<LogisticsDeliveryPage> createState() => _LogisticsDeliveryPageState();
}

class _LogisticsDeliveryPageState extends State<LogisticsDeliveryPage> {
  final TextEditingController _pickupCodeController = TextEditingController();

  void _verifyPickupCode(String enteredCode, String correctCode) async {
    if (enteredCode.trim() == correctCode) {
      await FirebaseFirestore.instance
          .collection('logistics_requests')
          .doc(widget.requestId)
          .update({
        'status': 'pickedup',
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pickup code verified. Order picked up.")),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeliveryCodePage(requestId: widget.requestId),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Incorrect pickup code. Try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            'Logistics Delivery',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('logistics_requests')
            .doc(widget.requestId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final pickupCode = data['pickupCode'] ?? '';
          final pickupAddress = data['pickupAddress'] ?? 'N/A';
          final senderContact = data['senderContact'] ?? 'N/A';
          final senderName = data['senderName'] ?? 'N/A';

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),

                  // 🔥 Bold Instruction Text
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      children: [
                        const TextSpan(text: "Please proceed to "),
                        TextSpan(
                          text: pickupAddress,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple),
                        ),
                        const TextSpan(text: " and call "),
                        TextSpan(
                          text: senderContact,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple),
                        ),
                        const TextSpan(text: " to pick up this order."),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 🔒 Second Instruction
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      children: [
                        const TextSpan(text: "Enter pickup code from "),
                        TextSpan(
                          text: senderName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple),
                        ),
                        const TextSpan(text: " to confirm pickup."),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // 🔢 TextField
                  TextField(
                    controller: _pickupCodeController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter pickup code",
                    ),
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 20),

                  // 🚚 Confirm Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _verifyPickupCode(
                          _pickupCodeController.text, pickupCode),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "Confirm Pickup",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Page to enter delivery code
class DeliveryCodePage extends StatefulWidget {
  final String requestId;
  const DeliveryCodePage({super.key, required this.requestId});

  @override
  State<DeliveryCodePage> createState() => _DeliveryCodePageState();
}

class _DeliveryCodePageState extends State<DeliveryCodePage> {
  final TextEditingController _deliveryCodeController = TextEditingController();

  void _verifyDeliveryCode(String enteredCode, String correctCode) async {
    if (enteredCode.trim() == correctCode) {
      // Update status to completed
      await FirebaseFirestore.instance
          .collection('logistics_requests')
          .doc(widget.requestId)
          .update({
        'status': 'completed',
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Delivery code verified. Order completed.")),
      );

      // Go back to main dashboard or driver page
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Incorrect delivery code. Try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            'Delivery',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('logistics_requests')
            .doc(widget.requestId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final deliveryCode = data['deliveryCode'] ?? '';

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Package: ${data['packageName'] ?? 'N/A'}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text("Delivery Address: ${data['deliveryAddress'] ?? 'N/A'}"),
                const SizedBox(height: 30),
                const Text(
                  "Enter Delivery Code from Receiver",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _deliveryCodeController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter delivery code",
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _verifyDeliveryCode(
                        _deliveryCodeController.text, deliveryCode),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text("Confirm Delivery"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DeliveryAgentPage extends StatelessWidget {
  const DeliveryAgentPage({super.key});

  Future<void> acceptRequest(BuildContext context, String requestId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final driverDoc = await FirebaseFirestore.instance
        .collection('Drivers')
        .doc(currentUser.uid)
        .get();

    final driverName = driverDoc.data()?['name'] ?? 'Unknown';

    await FirebaseFirestore.instance
        .collection('logistics_requests')
        .doc(requestId)
        .update({
      'status': 'accepted',
      'assignedAgent': currentUser.uid,
      'driverName': driverName,
      'assignedAt': FieldValue.serverTimestamp(),
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LogisticsDeliveryPage(requestId: requestId),
      ),
    );
  }

  String formatCurrency(dynamic amount) {
    double val = 0;
    if (amount != null) {
      val = double.tryParse(amount.toString()) ?? 0;
    }
    final format = NumberFormat.currency(locale: "en_NG", symbol: "₦");
    return format.format(val);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            'Partner',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      // Wrap Column in a Container with white background
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // 🔝 Driver Overview Card
            if (currentUser != null)
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Drivers')
                    .doc(currentUser.uid)
                    .snapshots(),
                builder: (context, driverSnapshot) {
                  if (!driverSnapshot.hasData) {
                    return const SizedBox(
                        height: 120,
                        child: Center(child: CircularProgressIndicator()));
                  }
                  final driverData =
                      driverSnapshot.data!.data() as Map<String, dynamic>? ??
                          {};

                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('logistics_requests')
                        .where('assignedAgent', isEqualTo: currentUser.uid)
                        .snapshots(),
                    builder: (context, requestSnapshot) {
                      int totalDeliveries = 0;
                      double totalEarnings = 0;

                      if (requestSnapshot.hasData) {
                        final docs = requestSnapshot.data!.docs;
                        totalDeliveries = docs.length;
                        totalEarnings = docs.fold(
                          0,
                          (sum, doc) =>
                              sum +
                              (doc['price'] != null
                                  ? double.tryParse(doc['price'].toString()) ??
                                      0
                                  : 0),
                        );
                      }

                      return Column(
                        children: [
                          Card(
                            margin: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            elevation: 6,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  // Driver image
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.grey[300],
                                    backgroundImage: driverData['photoUrl'] !=
                                            null
                                        ? NetworkImage(driverData['photoUrl'])
                                        : null,
                                    child: driverData['photoUrl'] == null
                                        ? const Icon(Icons.person, size: 40)
                                        : null,
                                  ),
                                  const SizedBox(width: 20),
                                  // Name + stats
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          driverData['name'] ?? 'Unknown',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text("Total Deliveries",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black54)),
                                                Text("$totalDeliveries",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16)),
                                              ],
                                            ),
                                            const SizedBox(width: 30),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text("Total Earnings",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black54)),
                                                Text(
                                                    formatCurrency(
                                                        totalEarnings),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16)),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          // ✅ Manage Deliveries Button
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const DriverDeliveriesPage(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text(
                                  "Manage Deliveries",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),

            // Expanded list of pending requests
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('logistics_requests')
                    .where('status', isEqualTo: 'pending')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Error loading requests"));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No pending requests"));
                  }

                  final requests = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final doc = requests[index];
                      final data = doc.data() as Map<String, dynamic>? ?? {};

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Package: ${data['packageName'] ?? 'N/A'}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text("Category: ${data['category'] ?? 'N/A'}"),
                              Text("Pickup: ${data['pickupAddress'] ?? 'N/A'}"),
                              Text(
                                  "Delivery: ${data['deliveryAddress'] ?? 'N/A'}"),
                              Text(
                                  "Receiver: ${data['receiverName'] ?? 'N/A'} (${data['receiverContact'] ?? 'N/A'})"),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                onPressed: () => acceptRequest(context, doc.id),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                ),
                                icon: const Icon(Icons.check),
                                label: const Text("Accept & Set Price",
                                    style: TextStyle(color: Colors.white)),
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
      ),
    );
  }
}

// Placeholder page for driver deliveries
class DriverDeliveriesPage extends StatelessWidget {
  const DriverDeliveriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Deliveries"),
      ),
      body: const Center(
        child: Text("Here the deliveries will be listed based on status."),
      ),
    );
  }
}

class DispatchOnboarding extends StatefulWidget {
  const DispatchOnboarding({Key? key}) : super(key: key);

  @override
  State<DispatchOnboarding> createState() => _DispatchOnboardingState();
}

class _DispatchOnboardingState extends State<DispatchOnboarding> {
  final TextEditingController riderName = TextEditingController();
  final TextEditingController riderPhone = TextEditingController();
  final TextEditingController riderEmail = TextEditingController();
  final TextEditingController riderNIN = TextEditingController();

  final TextEditingController vehicleName = TextEditingController();
  final TextEditingController vehicleType = TextEditingController();
  final TextEditingController vehicleModel = TextEditingController();

  XFile? riderImage;
  XFile? vehicleImage;
  final ImagePicker _picker = ImagePicker();

  bool loading = false;

  Future<void> pickRiderImage() async {
    riderImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  Future<void> pickVehicleImage() async {
    vehicleImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  Future<void> saveData() async {
    if (riderName.text.isEmpty ||
        riderPhone.text.isEmpty ||
        riderEmail.text.isEmpty ||
        riderNIN.text.isEmpty ||
        vehicleName.text.isEmpty ||
        vehicleType.text.isEmpty ||
        vehicleModel.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('dispatch_riders')
          .doc(uid)
          .set({
        "riderName": riderName.text.trim(),
        "riderPhone": riderPhone.text.trim(),
        "riderEmail": riderEmail.text.trim(),
        "riderNIN": riderNIN.text.trim(),
        "vehicleName": vehicleName.text.trim(),
        "vehicleType": vehicleType.text.trim(),
        "vehicleModel": vehicleModel.text.trim(),
        "status": "pending_verification",
        "createdAt": FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DispatchDashboardPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => loading = false);
  }

  Widget buildImageUpload(String label, Function() pickImage, XFile? file) {
    return GestureDetector(
      onTap: pickImage,
      child: Container(
        height: 110,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.deepPurple),
        ),
        child: file == null
            ? Center(child: Text("Upload $label"))
            : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: kIsWeb
                    ? Image.network(
                        file.path,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(file.path),
                        fit: BoxFit.cover,
                      ),
              ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration:
          InputDecoration(labelText: label, border: const OutlineInputBorder()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            'Onboarding',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// ------- PERSONAL DETAILS CARD -------
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Personal Details",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    buildImageUpload(
                        "Rider Picture", pickRiderImage, riderImage),
                    const SizedBox(height: 15),
                    buildTextField("Full Name", riderName),
                    const SizedBox(height: 10),
                    buildTextField("Phone Number", riderPhone),
                    const SizedBox(height: 10),
                    buildTextField("Email Address", riderEmail),
                    const SizedBox(height: 10),
                    buildTextField("NIN Number", riderNIN),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ------- VEHICLE DETAILS CARD -------
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Vehicle Details",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    buildImageUpload(
                        "Vehicle Image", pickVehicleImage, vehicleImage),
                    const SizedBox(height: 15),
                    buildTextField("Vehicle Name", vehicleName),
                    const SizedBox(height: 10),
                    buildTextField("Vehicle Type (Bike/Car/etc)", vehicleType),
                    const SizedBox(height: 10),
                    buildTextField("Vehicle Model", vehicleModel),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// ------- SUBMIT BUTTON -------
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 120),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                backgroundColor: Colors.deepPurple,
              ),
              onPressed: loading ? null : saveData,
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Get Onboard", style: TextStyle(fontSize: 16)),
            )
          ],
        ),
      ),
    );
  }
}

/// ---------------------- DRIVER ONBOARDING ----------------------
class ShuttleDriverOnboarding extends StatefulWidget {
  const ShuttleDriverOnboarding({Key? key}) : super(key: key);

  @override
  _ShuttleDriverOnboardingState createState() =>
      _ShuttleDriverOnboardingState();
}

class _ShuttleDriverOnboardingState extends State<ShuttleDriverOnboarding> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController vehicleModelCtrl = TextEditingController();
  final TextEditingController vehicleNameCtrl = TextEditingController();
  final TextEditingController vehicleCapacityCtrl = TextEditingController();

  Uint8List? driverImageBytes;
  Uint8List? vehicleImageBytes;

  bool loading = false;
  final picker = ImagePicker();

  Future<void> pickImage(bool isDriver) async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    Uint8List bytes = await picked.readAsBytes();

    setState(() {
      if (isDriver) {
        driverImageBytes = bytes;
      } else {
        vehicleImageBytes = bytes;
      }
    });
  }

  Future<String> uploadToFirebase(Uint8List fileBytes, String folder) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final fileName = "$uid-${DateTime.now().millisecondsSinceEpoch}.jpg";
    final ref = FirebaseStorage.instance.ref("$folder/$fileName");
    await ref.putData(fileBytes);
    return await ref.getDownloadURL();
  }

  Future<void> saveDetails() async {
    if (!_formKey.currentState!.validate()) return;

    if (driverImageBytes == null || vehicleImageBytes == null) {
      _showSnack("Please upload both images");
      return;
    }

    setState(() => loading = true);

    try {
      String driverUrl =
          await uploadToFirebase(driverImageBytes!, "driverImages");
      String vehicleUrl =
          await uploadToFirebase(vehicleImageBytes!, "vehicleImages");

      String driverCode = "DB${Random().nextInt(90000) + 10000}";

      await FirebaseFirestore.instance
          .collection("shuttle_drivers")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        "name": nameCtrl.text.trim(),
        "phone": phoneCtrl.text.trim(),
        "email": emailCtrl.text.trim(),
        "driverImage": driverUrl,
        "vehicleImage": vehicleUrl,
        "vehicleModel": vehicleModelCtrl.text.trim(),
        "vehicleName": vehicleNameCtrl.text.trim(),
        "vehicleCapacity": int.parse(vehicleCapacityCtrl.text.trim()),

        /// NEW FIELDS
        "status": "offline",
        "activeInstitution": null,
        "pickupLocation": null,
        "destinationLocation": null,

        "driverCode": driverCode,
        "boardedPassengers": 0,
        "ticketIds": [],
        "amountCollected": 0.0,
        "earnings": 0.0,
        "timestamp": FieldValue.serverTimestamp(),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ShuttleDriverDashboard()),
      );
    } catch (e) {
      _showSnack("Error: $e");
    }

    setState(() => loading = false);
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _input(String label, TextEditingController ctrl,
      {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: ctrl,
        keyboardType: type,
        validator: (v) => v!.isEmpty ? "Required" : null,
        decoration:
            InputDecoration(border: OutlineInputBorder(), labelText: label),
      ),
    );
  }

  Widget _imagePicker(String title, Uint8List? bytes, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.grey)),
        child: bytes == null
            ? Center(child: Text(title))
            : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(bytes, fit: BoxFit.cover),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text("Fill your personal and vehicle details.",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              _imagePicker(
                  "Driver Image", driverImageBytes, () => pickImage(true)),
              _input("Full Name", nameCtrl),
              _input("Phone", phoneCtrl),
              _input("Email", emailCtrl),
              const SizedBox(height: 20),
              const Text("Vehicle Info",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              _imagePicker(
                  "Vehicle Image", vehicleImageBytes, () => pickImage(false)),
              _input("Vehicle Model", vehicleModelCtrl),
              _input("Vehicle Name", vehicleNameCtrl),
              _input("Capacity", vehicleCapacityCtrl,
                  type: TextInputType.number),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: loading ? null : saveDetails,
                child: loading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Get Onboard"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------------------- DRIVER DASHBOARD ----------------------
class ShuttleDriverDashboard extends StatefulWidget {
  const ShuttleDriverDashboard({Key? key}) : super(key: key);

  @override
  _ShuttleDriverDashboardState createState() => _ShuttleDriverDashboardState();
}

class _ShuttleDriverDashboardState extends State<ShuttleDriverDashboard> {
  final user = FirebaseAuth.instance.currentUser;

  /// ================= GO ONLINE FLOW =================
  void openRouteSelector() async {
    final snapshot =
        await FirebaseFirestore.instance.collection("institutions").get();

    List<Map<String, dynamic>> institutions =
        snapshot.docs.map((e) => e.data()).toList();

    String? selectedInstitution;
    String? pickup;
    String? destination;
    TextEditingController priceController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(builder: (context, setModalState) {
          List<String> locations = [];

          if (selectedInstitution != null) {
            final inst = institutions
                .firstWhere((e) => e['name'] == selectedInstitution);
            locations = List<String>.from(inst['locations']);
          }

          return Padding(
            padding: EdgeInsets.fromLTRB(
                20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Select Route",
                    style: TextStyle(fontWeight: FontWeight.bold)),

                /// Institution
                DropdownButtonFormField<String>(
                  hint: Text("Institution"),
                  value: selectedInstitution,
                  items: institutions
                      .map((e) => DropdownMenuItem<String>(
                            value: e['name'],
                            child: Text(e['name']),
                          ))
                      .toList(),
                  onChanged: (v) {
                    setModalState(() {
                      selectedInstitution = v;
                      pickup = null;
                      destination = null;
                    });
                  },
                ),

                /// Pickup
                DropdownButtonFormField<String>(
                  hint: Text("Pickup"),
                  value: pickup,
                  items: locations
                      .map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (v) => setModalState(() => pickup = v),
                ),

                /// Destination
                DropdownButtonFormField<String>(
                  hint: Text("Destination"),
                  value: destination,
                  items: locations
                      .map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (v) => setModalState(() => destination = v),
                ),

                /// 💰 PRICE INPUT
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter Price",
                  ),
                ),

                SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () async {
                    if (selectedInstitution == null ||
                        pickup == null ||
                        destination == null ||
                        priceController.text.isEmpty) return;

                    await FirebaseFirestore.instance
                        .collection("shuttle_drivers")
                        .doc(user!.uid)
                        .update({
                      "status": "online",
                      "activeInstitution": selectedInstitution,
                      "pickupLocation": pickup,
                      "destinationLocation": destination,
                      "price": int.parse(priceController.text),

                      /// reset trip stats
                      "boardedPassengers": 0,
                      "amountCollected": 0,
                      "timestamp": FieldValue.serverTimestamp(),
                    });

                    Navigator.pop(context);
                  },
                  child: Text("Go Online"),
                )
              ],
            ),
          );
        });
      },
    );
  }

  void goOffline() async {
    await FirebaseFirestore.instance
        .collection("shuttle_drivers")
        .doc(user!.uid)
        .update({
      "status": "offline",
      "activeInstitution": null,
      "pickupLocation": null,
      "destinationLocation": null,
    });
  }

  Future<void> departTrip(Map<String, dynamic> data) async {
    final driverRef =
        FirebaseFirestore.instance.collection("shuttle_drivers").doc(user!.uid);

    /// Save to history
    await FirebaseFirestore.instance.collection("shuttle_departures").add({
      "driverId": user!.uid,
      "name": data['name'],
      "vehicleName": data['vehicleName'],
      "institution": data['activeInstitution'],
      "pickup": data['pickupLocation'],
      "destination": data['destinationLocation'],
      "price": data['price'],
      "passengers": data['boardedPassengers'],
      "capacity": data['vehicleCapacity'],
      "amount": data['amountCollected'],
      "departedAt": FieldValue.serverTimestamp(),
    });

    /// Reset driver
    await driverRef.update({
      "status": "offline",
      "activeInstitution": null,
      "pickupLocation": null,
      "destinationLocation": null,
      "boardedPassengers": 0,
      "amountCollected": 0,
    });
  }

  /// ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Driver Dashboard")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("shuttle_drivers")
            .doc(user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return ListView(
            padding: EdgeInsets.all(16),
            children: [
              /// ONLINE SWITCH
              SwitchListTile(
                value: data['status'] == "online",
                title: Text("Go Online"),
                onChanged: (value) {
                  if (value) {
                    openRouteSelector();
                  } else {
                    goOffline();
                  }
                },
              ),

              /// ACTIVE ROUTE DISPLAY
              if (data['status'] == "online")
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['activeInstitution'] ?? "",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        SizedBox(height: 5),

                        Text(
                          "${data['pickupLocation']} → ${data['destinationLocation']}",
                        ),

                        SizedBox(height: 10),

                        /// 🧍 Capacity
                        Text(
                          "Passengers: ${data['boardedPassengers']} / ${data['vehicleCapacity']}",
                        ),

                        /// 💰 Earnings
                        Text(
                          "Amount: ₦${data['amountCollected']}",
                        ),

                        SizedBox(height: 10),

                        /// 🚀 DEPART BUTTON
                        ElevatedButton(
                          onPressed: () async {
                            await departTrip(data);
                          },
                          child: Text("Depart"),
                        )
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 20),

              Text("Driver: ${data['name']}"),
              Text("Vehicle: ${data['vehicleName']}"),
              SizedBox(height: 20),

              Text("Trip History",
                  style: TextStyle(fontWeight: FontWeight.bold)),

              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("shuttle_departures")
                    .where("driverId", isEqualTo: user!.uid)
                    .orderBy("departedAt", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return SizedBox();

                  return Column(
                    children: snapshot.data!.docs.map((doc) {
                      final d = doc.data() as Map<String, dynamic>;

                      return Card(
                        child: ListTile(
                          title: Text("${d['pickup']} → ${d['destination']}"),
                          subtitle: Text(
                              "Passengers: ${d['passengers']} | ₦${d['amount']}"),
                        ),
                      );
                    }).toList(),
                  );
                },
              )
            ],
          );
        },
      ),
    );
  }
}

class DispatchDashboardPage extends StatefulWidget {
  const DispatchDashboardPage({super.key});

  @override
  State<DispatchDashboardPage> createState() => _DispatchDashboardPageState();
}

class _DispatchDashboardPageState extends State<DispatchDashboardPage> {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  String _tab = 'New';

  @override
  Widget build(BuildContext context) {
    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text('You must be logged in')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            'Partner',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('dispatch_riders')
                    .doc(uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final data =
                      snapshot.data!.data() as Map<String, dynamic>? ?? {};
                  return _profileCard(data);
                },
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _tabButton('New'),
                  _tabButton('Pending'),
                  _tabButton('Completed'),
                ],
              ),

              const SizedBox(height: 16),

              // ORDER STREAM
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('orders')
                    .where('status', whereIn: _getStatusesForTab(_tab))
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('Error loading orders'),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: Text('No orders found')),
                    );
                  }

                  return Column(
                    children: docs.map((doc) {
                      final order = doc.data() as Map<String, dynamic>? ?? {};
                      final orderId = doc.id;

                      final userName = order['userName'] ?? 'Anonymous';
                      final items =
                          Map<String, dynamic>.from(order['items'] ?? {});
                      final price = _safeDouble(order['grandTotal']);
                      final status = order['status'] ?? 'pending';

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          onTap: () {
                            // Only navigate to pickup page if driver is assigned
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DriverPickupPage(
                                    orderId: orderId,
                                    orderData: order,
                                  ),
                                ),
                              );
                            }
                          },
                          leading: CircleAvatar(
                            backgroundColor: Colors.deepPurple.shade100,
                            child: Text('${items.length}',
                                style: const TextStyle(color: Colors.white)),
                          ),
                          title: Text(userName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('₦${price.toStringAsFixed(2)}'),
                          trailing: status == ['pending', 'accepted']
                              ? ElevatedButton(
                                  onPressed: () => _acceptOrder(orderId, order),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                  ),
                                  child: const Text('Accept'),
                                )
                              : null,
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// MAP TAB TO ORDER STATUS
  // Remove _mapTabToStatus entirely, or keep it if you still need a single string
// but currently it’s unused for StreamBuilder.

  List<String> _getStatusesForTab(String tab) {
    switch (tab) {
      case 'New':
        // Include orders that are pending OR accepted by vendor
        return ['pending', 'accepted'];
      case 'Pending':
        return ['driver_assigned', 'picked_up'];
      case 'Completed':
        return ['completed'];
      default:
        return ['pending'];
    }
  }

  /// PROFILE CARD (Responsive)
  Widget _profileCard(Map<String, dynamic>? data) {
    final imageUrl = data?['riderImage'] ?? '';
    final name = data?['riderName'] ?? 'Rider';
    final totalRides = data?['totalRides'] ?? 0;
    final earnings = _safeDouble(data?['totalEarnings']);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ROW 1 - IMAGE + NAME
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage:
                    imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                backgroundColor: Colors.grey[300],
                child: imageUrl.isEmpty
                    ? const Icon(Icons.person, size: 35, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              )
            ],
          ),

          const SizedBox(height: 10),

          // TOTALS
          _profileStat('Total Rides:', '$totalRides', Colors.deepPurple),
          const SizedBox(height: 6),
          _profileStat(
              'Earnings:', '₦${earnings.toStringAsFixed(2)}', Colors.green),
        ],
      ),
    );
  }

  Widget _profileStat(String label, String value, Color color) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8)),
          child: Text(value,
              style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _tabButton(String label) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tab = label),
        child: Container(
          height: 32,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _tab == label ? Colors.deepPurple : Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(label,
              style: TextStyle(
                  color: _tab == label ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  double _safeDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0.0;
    return 0.0;
  }

  Future<void> _acceptOrder(
      String orderId, Map<String, dynamic> orderData) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final riderRef =
        FirebaseFirestore.instance.collection('dispatch_riders').doc(user.uid);
    final orderRef =
        FirebaseFirestore.instance.collection('orders').doc(orderId);

    try {
      await FirebaseFirestore.instance.runTransaction((txn) async {
        final orderSnap = await txn.get(orderRef);
        if (!orderSnap.exists) return;

        final status = orderSnap.data()?['status'] ?? '';
        if (status != 'pending')
          return; // ensure only pending orders are accepted

        final riderSnap = await txn.get(riderRef);
        final riderName = riderSnap.data()?['riderName'] ?? 'Rider';

        txn.update(orderRef, {
          'assignedDriver': user.uid,
          'driverName': riderName,
          'status': 'driver_assigned',
          'driverAssignedAt': Timestamp.now(),
        });
      });

      // Navigate to pickup page
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DriverPickupPage(orderId: orderId, orderData: orderData),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error accepting order: $e')));
    }
  }
}

// ---------------- DRIVER PICKUP PAGE ----------------

// ---------------- DRIVER PICKUP PAGE ----------------
class DriverPickupPage extends StatefulWidget {
  final String orderId;
  final Map<String, dynamic> orderData;

  const DriverPickupPage({
    super.key,
    required this.orderId,
    required this.orderData,
  });

  @override
  State<DriverPickupPage> createState() => _DriverPickupPageState();
}

class _DriverPickupPageState extends State<DriverPickupPage> {
  final TextEditingController _pickupCodeController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _checkIfAlreadyPickedUp();
  }

  Future<void> _checkIfAlreadyPickedUp() async {
    final snap = await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderId)
        .get();

    final data = snap.data() as Map<String, dynamic>?;

    if (data != null && data['status'] == 'picked_up') {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DriverDeliveryPage(orderId: widget.orderId, orderData: data),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.orderData;
    final pickupAddress = order['pickupAddress'] ??
        order['storeAddress'] ??
        'No pickup address provided';
    final pickupCode = order['pickupCode'];
    final vendorName = order['vendorName'] ?? "Vendor";
    final vendorPhone = order['vendorPhone'] ?? "No phone";

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            'Pickup',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 Title Row
            Center(
              child: const Row(
                children: [
                  Text(
                    "Order Accepted",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.check_circle, color: Colors.green, size: 28),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Please proceed to:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),

            // 📍 Pickup Card
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Pickup Address",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    Text(pickupAddress, style: const TextStyle(fontSize: 15)),
                    const SizedBox(height: 15),
                    const Divider(),

                    // 👤 Vendor Info
                    const SizedBox(height: 8),
                    const Text(
                      "Vendor Details",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    Text(vendorName),
                    Text(vendorPhone),
                    const SizedBox(height: 15),

                    const Divider(),
                    const SizedBox(height: 12),

                    const Text(
                      "Collect & Confirm Pickup",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 10),

                    // 🔢 Code Field
                    TextField(
                      controller: _pickupCodeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Enter pickup code",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // 🚚 Confirm Button
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : () => _confirmPickup(pickupCode),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Confirm Pickup",
                        style: TextStyle(fontSize: 14, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmPickup(dynamic expectedCode) async {
    setState(() => _loading = true);
    final entered = _pickupCodeController.text.trim();

    try {
      final valid =
          (expectedCode != null) && (entered == expectedCode.toString());
      if (!valid) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Invalid pickup code')));
        setState(() => _loading = false);
        return;
      }

      await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderId)
          .update({
        'status': 'picked_up',
        'pickupConfirmedAt': Timestamp.now(),
        'pickupConfirmedBy': FirebaseAuth.instance.currentUser?.uid,
      });

      final snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderId)
          .get();
      final fresh =
          snapshot.data() as Map<String, dynamic>? ?? widget.orderData;

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DriverDeliveryPage(orderId: widget.orderId, orderData: fresh),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error confirming pickup: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}

// ---------------- DRIVER DELIVERY PAGE ----------------
class DriverDeliveryPage extends StatefulWidget {
  final String orderId;
  final Map<String, dynamic> orderData;

  const DriverDeliveryPage(
      {super.key, required this.orderId, required this.orderData});

  @override
  State<DriverDeliveryPage> createState() => _DriverDeliveryPageState();
}

class _DriverDeliveryPageState extends State<DriverDeliveryPage> {
  final TextEditingController _deliveryCodeController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final order = widget.orderData;
    final deliveryAddress = order['deliveryAddress'] ??
        order['destinationAddress'] ??
        'No delivery address provided';

    final deliveryCode = order['deliveryCode'];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            'Delivery',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar (Back + Text)
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    "Order Delivery",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Success Row
              Row(
                children: const [
                  Icon(Icons.check_circle, color: Colors.green, size: 28),
                  SizedBox(width: 8),
                  Text(
                    "Order on Delivery",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              const Text(
                "Please deliver to:",
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 12),

              // Card with Delivery Address
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Delivery Address',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 6),
                      Text(deliveryAddress,
                          style: const TextStyle(fontSize: 15)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Enter Delivery Code given by customer:',
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 8),

              TextField(
                controller: _deliveryCodeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter Delivery Code',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),

              // Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _confirmDelivery,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Confirm Delivery',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelivery() async {
    setState(() => _loading = true);
    final entered = _deliveryCodeController.text.trim();
    final expected = widget.orderData['deliveryCode'];

    try {
      final valid = (expected != null) && (entered == expected.toString());
      if (!valid) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid delivery code')));
        setState(() => _loading = false);
        return;
      }

      final driverUid = FirebaseAuth.instance.currentUser?.uid;

      // Update order status
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderId)
          .update({
        'status': 'completed',
        'deliveredAt': Timestamp.now(),
        'deliveryConfirmedBy': driverUid,
      });

      // Update stats
      if (driverUid != null) {
        final riderRef = FirebaseFirestore.instance
            .collection('dispatch_riders')
            .doc(driverUid);

        await FirebaseFirestore.instance.runTransaction((txn) async {
          final snap = await txn.get(riderRef);
          final current =
              snap.exists ? (snap.data() as Map<String, dynamic>) : {};
          final prevRides = (current['totalRides'] ?? 0) as int;
          final prevEarnings = _safeDouble(current['totalEarnings']);
          final grand = _safeDouble(widget.orderData['grandTotal']);

          txn.set(
            riderRef,
            {
              'totalRides': prevRides + 1,
              'totalEarnings': prevEarnings + grand,
            },
            SetOptions(merge: true),
          );
        });
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DeliverySuccessPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error confirming delivery: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  double _safeDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0.0;
    return 0.0;
  }
}

class DeliverySuccessPage extends StatelessWidget {
  const DeliverySuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    "Delivery Completed",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              const Icon(Icons.check_circle, color: Colors.green, size: 85),
              const SizedBox(height: 20),
              const Text(
                "Order Delivered Successfully!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Your funds are wired, and confirmed.\nCheers! 🎉",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text("Done", style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class VerificationRejectedScreen extends StatelessWidget {
  const VerificationRejectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cancel, size: 100, color: Colors.red),
              const SizedBox(height: 30),
              const Text(
                "Verification Rejected",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                "Unfortunately, your driver application was not approved. Please contact support or try again with correct information.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // You could redirect to support or login screen
                },
                child: const Text("Contact Support"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class VerificationPendingScreen extends StatelessWidget {
  const VerificationPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.hourglass_top, size: 100, color: Colors.orange),
              const SizedBox(height: 30),
              const Text(
                "Verification in Progress",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                "Thanks for signing up to be a Deck driver! Your profile is under review. We'll notify you once you're verified.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Log out or navigate somewhere
                },
                child: const Text("Ok"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DriverOnboardingForm extends StatefulWidget {
  @override
  _DriverOnboardingFormState createState() => _DriverOnboardingFormState();
}

class _DriverOnboardingFormState extends State<DriverOnboardingForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _vehicleController = TextEditingController();
  final TextEditingController _vehicleTypeController = TextEditingController();

  Uint8List? _driverImageBytes;
  Uint8List? _vehicleImageBytes;

  bool _isLoading = false;

  /// Pick image (works on web + mobile)
  Future<void> _pickImage(bool isDriver) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        if (isDriver) {
          _driverImageBytes = bytes;
        } else {
          _vehicleImageBytes = bytes;
        }
      });
    }
  }

  /// Upload image to Firebase Storage
  Future<String?> _uploadImage(Uint8List? image, String path) async {
    if (image == null) return null;

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('drivers/${FirebaseAuth.instance.currentUser!.uid}/$path.jpg');

      await ref.putData(image);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("No authenticated user found.");

      if (_driverImageBytes == null || _vehicleImageBytes == null) {
        throw Exception("Please upload both driver and vehicle images.");
      }

      final driverImageUrl =
          await _uploadImage(_driverImageBytes, "profileImage");
      final vehicleImageUrl =
          await _uploadImage(_vehicleImageBytes, "vehicleImage");

      if (driverImageUrl == null || vehicleImageUrl == null) {
        throw Exception("Image upload failed. Please try again.");
      }

      await FirebaseFirestore.instance.collection('Drivers').doc(user.uid).set({
        'name': _nameController.text.trim(),
        'vehicle': _vehicleController.text.trim(),
        'vehicleType': _vehicleTypeController.text.trim(),
        'profileImage': driverImageUrl,
        'vehicleImage': vehicleImageUrl,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Driver profile submitted for verification!")),
      );

      Navigator.pop(context);
    } catch (e, stack) {
      print("❌ Error in _submitForm: $e");
      print(stack);
      _showErrorDialog("Submission failed", e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("OK", style: TextStyle(color: Colors.deepPurple)),
          ),
        ],
      ),
    );
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> _driverStatusStream() {
    final user = FirebaseAuth.instance.currentUser;
    return FirebaseFirestore.instance
        .collection('Drivers')
        .doc(user!.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _driverStatusStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasData && snapshot.data!.exists) {
          final status = snapshot.data!.data()?['status'] ?? 'pending';

          if (status == 'verified') {
            return DriverHomePage();
          } else if (status == 'rejected') {
            return const VerificationRejectedScreen();
          } else {
            return const VerificationPendingScreen();
          }
        }

        return _buildOnboardingForm();
      },
    );
  }

  Widget _buildOnboardingForm() {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            'Onboarding',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Full Name"),
                validator: (value) => value!.isEmpty ? "Enter your name" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _vehicleController,
                decoration: const InputDecoration(labelText: "Vehicle"),
                validator: (value) =>
                    value!.isEmpty ? "Enter your vehicle" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _vehicleTypeController,
                decoration: const InputDecoration(labelText: "Vehicle Type"),
                validator: (value) =>
                    value!.isEmpty ? "Enter vehicle type" : null,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _driverImageBytes != null
                      ? CircleAvatar(
                          radius: 40,
                          backgroundImage: MemoryImage(_driverImageBytes!),
                        )
                      : const CircleAvatar(
                          radius: 40,
                          child: Icon(Icons.person, size: 40),
                        ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => _pickImage(true),
                    child: const Text("Upload Driver Photo"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _vehicleImageBytes != null
                      ? CircleAvatar(
                          radius: 40,
                          backgroundImage: MemoryImage(_vehicleImageBytes!),
                        )
                      : const CircleAvatar(
                          radius: 40,
                          child: Icon(Icons.directions_car, size: 40),
                        ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => _pickImage(false),
                    child: const Text("Upload Vehicle Photo"),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitForm,
                      child:
                          const Text("Submit", style: TextStyle(fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class DriverHomePage extends StatefulWidget {
  @override
  _DriverHomePageState createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  Stream<QuerySnapshot> rideRequestsStream = FirebaseFirestore.instance
      .collection('ride_requests')
      .where('Status', isEqualTo: 'pending')
      .snapshots();

  final Map<String, TextEditingController> _priceControllers = {};
  final Set<String> notifiedRequests = {};

  final AudioPlayer _audioPlayer = AudioPlayer();
  String? driverId, driverName, vehicleType, vehicle, driverImageUrl;

  @override
  void initState() {
    super.initState();
    _loadDriverInfo();
  }

  int completedRides = 0;
  double totalEarnings = 0.0;

  Future<void> _loadDriverInfo() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('Drivers')
        .doc(currentUser.uid)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      driverId = currentUser.uid;
      driverName = data['name'] ?? 'Unknown';
      vehicleType = data['vehicle'] ?? 'Not specified';
      vehicle = data['vehicleType'] ?? 'No description';
      driverImageUrl = data['profileImage']; // ✅ use direct URL now
    }

    // Fetch completed rides
    final ridesSnapshot = await FirebaseFirestore.instance
        .collection('ride_requests')
        .where('driverId', isEqualTo: driverName)
        .where('Status', isEqualTo: 'driver_accepted')
        .get();

    double earnings = 0.0;
    for (var ride in ridesSnapshot.docs) {
      final price = ride['price'];
      if (price is num) earnings += price.toDouble();
    }

    setState(() {
      completedRides = ridesSnapshot.docs.length;
      totalEarnings = earnings;
    });
  }

  Future<void> _playNotificationSound() async {
    await _audioPlayer.play(AssetSource('sounds/notification_sound.mp3'));
  }

  Future<void> _stopSound() async {
    await _audioPlayer.stop();
  }

  Future<void> _refresh() async {
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            'Partner',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 180,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black54),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          driverImageUrl != null && driverImageUrl!.isNotEmpty
                              ? CircleAvatar(
                                  radius: 18,
                                  backgroundImage:
                                      NetworkImage(driverImageUrl!),
                                )
                              : const CircleAvatar(
                                  radius: 18,
                                  backgroundImage:
                                      AssetImage('assets/images/driver.png'),
                                ),
                          const SizedBox(width: 8),
                          Text(
                            driverName ?? 'Driver',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green[600],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "Online",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const Text('Total Rides',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              )),
                          const SizedBox(height: 4),
                          Container(
                            height: 60,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                "  $completedRides",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Earnings',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              )),
                          const SizedBox(height: 4),
                          Container(
                            height: 60,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                " ₦${totalEarnings.toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: rideRequestsStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const Center(child: CircularProgressIndicator());

                final requests = snapshot.data!.docs;

                if (requests.isEmpty) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 200),
                      const Center(child: Text("No pending ride requests."))
                    ],
                  );
                }
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    ...requests.map((ride) {
                      final data = ride.data() as Map<String, dynamic>;
                      final rideId = ride.id;
                      final timestamp = data['Time'] as Timestamp?;
                      final timeAgo = _getTimeAgo(timestamp);

                      _priceControllers.putIfAbsent(
                          rideId, () => TextEditingController());

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 8,
                        color: Colors.grey[500],
                        shadowColor: Colors.black12,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                child: Text(
                                  "New Ride Request",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Pickup Location',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              _buildInfoRow("Pickup", data['Pickup Location']),
                              const SizedBox(height: 5),
                              const Text(
                                'Destination',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              _buildInfoRow("Destination", data['Destination']),
                              const SizedBox(height: 10),
                              Text(
                                "Booked by: ${data['userName'] ?? 'Unknown'}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Requested: $timeAgo",
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _priceControllers[rideId],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Enter your price',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () async {
                                        final priceText =
                                            _priceControllers[rideId]?.text ??
                                                '';
                                        final price =
                                            double.tryParse(priceText);
                                        if (price == null || price <= 0) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    "Please enter a valid price")),
                                          );
                                          return;
                                        }

                                        await FirebaseFirestore.instance
                                            .collection('ride_requests')
                                            .doc(rideId)
                                            .update({
                                          'Status': 'driver_accepted',
                                          'driverId': driverName ?? 'Unknown',
                                          'price': price,
                                          'vehicleType':
                                              vehicleType ?? 'Not specified',
                                          'vehicle':
                                              vehicle ?? 'No description',
                                        });

                                        _stopSound();

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => DriverBookedScreen(
                                              riderName:
                                                  data['userName'] ?? 'Unknown',
                                              pickup: data['Pickup Location'] ??
                                                  'Unknown',
                                              destination:
                                                  data['Destination'] ??
                                                      'Unknown',
                                              price: price,
                                              paymentMethod: 'Cash',
                                              rideId: rideId,
                                            ),
                                          ),
                                        );
                                      },
                                      label: const Text("Accept",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        _stopSound();
                                        notifiedRequests.add(rideId);
                                        setState(() {});
                                      },
                                      label: const Text("Reject",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          )),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red[900],
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          )
        ]),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            label == "Pickup" ? Icons.my_location : Icons.location_on,
            color: Colors.deepPurple,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "$label: $value",
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(Timestamp? timestamp) {
    if (timestamp == null) return "Unknown time";
    final now = DateTime.now();
    final rideTime = timestamp.toDate();
    final difference = now.difference(rideTime);
    if (difference.inMinutes < 1) return "Just now";
    if (difference.inMinutes < 60) return "${difference.inMinutes} mins ago";
    if (difference.inHours < 24) return "${difference.inHours} hrs ago";
    return "${difference.inDays} days ago";
  }
}

class EarnPage extends StatelessWidget {
  EarnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            '',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Select Your Service Type',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _buildEarnCard(
                title: "Rides",
                description:
                    "Accept ride requests and drive people around conveniently.",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DriverOnboardingForm()),
                ),
                imagePaths: [
                  'assets/images/man.png',
                  'assets/images/tricycle.png',
                  'assets/images/car.png',
                ],
              ),
              const SizedBox(height: 20),
              _buildEarnCard(
                title: "Logistics",
                description:
                    "Package delivery, Waybills, Instant Pickup and delivery, Bulk Transport etc.",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DeliveryAgentPage()),
                ),
                imagePaths: [
                  'assets/images/pickup-truck.png',
                  'assets/images/delivery-man.png',
                  'assets/images/fast-shipping.png',
                ],
              ),
              const SizedBox(height: 20),
              _buildEarnCard(
                title: "Transport",
                description:
                    "Intercity transportation for mass transport companies.",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const LogisticsAdminDashboard()),
                ),
                imagePaths: [
                  'assets/images/bus (2).png',
                  'assets/images/taxi.png',
                  'assets/images/car.png',
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminInstitutionsPage(),
                    ),
                  );
                },
                child: const Text(
                  "Manage Institutions",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEarnCard({
    required String title,
    required String description,
    required VoidCallback onTap,
    required List<String> imagePaths,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: 6),
                  Text(description,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      )),
                  const SizedBox(height: 12),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: imagePaths
                          .map((path) => Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Image.asset(
                                  path,
                                  width: 26,
                                  height: 26,
                                  fit: BoxFit.contain,
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_outlined,
                color: Colors.black45, size: 24),
          ],
        ),
      ),
    );
  }
}

class help extends StatefulWidget {
  const help({Key? key}) : super(key: key);

  @override
  State<help> createState() => _helpState();
}

class _helpState extends State<help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            'Help',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: const Center(
        child: Text(
          'Text',
        ),
      ),
    );
  }
}

class support extends StatefulWidget {
  const support({Key? key}) : super(key: key);

  @override
  State<support> createState() => _supportState();
}

class _supportState extends State<support> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            'Support',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: const Center(
        child: Text(
          'Text',
        ),
      ),
    );
  }
}

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class settings extends StatefulWidget {
  const settings({Key? key}) : super(key: key);

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false, // 👈 turn this off since we customize it
        backgroundColor: Colors.white,
        elevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[100], // ✅ grey 50 look
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Padding(
          padding: EdgeInsets.only(left: 8), // ✅ spacing from icon
          child: Text(
            'Settings',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: const Center(
        child: Text(
          'Text',
        ),
      ),
    );
  }
}
