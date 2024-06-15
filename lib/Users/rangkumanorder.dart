import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:nebengbro_apps/Users/homepage.dart';
import 'package:intl/intl.dart';

class Rangkumanorder extends StatefulWidget {
  const Rangkumanorder({super.key});

  @override
  _RangkumanorderState createState() => _RangkumanorderState();
}

class _RangkumanorderState extends State<Rangkumanorder> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DatabaseReference pickupRef = FirebaseDatabase.instance.ref('locations/start/name');
  final DatabaseReference dropRef = FirebaseDatabase.instance.ref('locations/end/name');

  String userName = 'Loading...';
  // String orderTime = 'Loading...';

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        // Retrieve user data
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
          print("User data: $userData");
          setState(() {
            userName = userData['name'] ?? 'No Name';
          });
        } else {
          print("User document does not exist");
        }

        // Retrieve order data
        // DocumentSnapshot orderDoc = await _firestore.collection('orders').doc(user.uid).get();
        // if (orderDoc.exists) {
        //   Map<String, dynamic>? orderData = orderDoc.data() as Map<String, dynamic>?;
        //   if (orderData != null && orderData['Waktu_Order'] is Timestamp) {
        //     Timestamp orderTimestamp = orderData['Waktu_Order'] as Timestamp;
        //     DateTime orderDateTime = orderTimestamp.toDate();
        //     setState(() {
        //       orderTime = DateFormat('HH:mm').format(orderDateTime); // Only display time
        //     });
        //   } else {
        //     print("Order data is null or Waktu_Order is not a Timestamp");
        //   }
        // } else {
        //   print("Order document does not exist");
        // }
      } catch (e) {
        print("Error getting user or order data: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesanan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildOrderDetails(),
            const SizedBox(height: 16),
            _buildTravelDetails(),
            const SizedBox(height: 16),
            _buildPaymentDetails(),
            const SizedBox(height: 16),
            _buildBackButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.directions_car, size: 40, color: Colors.blue),
            const SizedBox(width: 8),
            const Text(
              'Nebeng Bro',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Text(orderTime, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderDetails() {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey[300],
          radius: 30,
          child: const Icon(Icons.person, size: 40, color: Colors.blue),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTravelDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detail Perjalanan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Row(
          children: [
            Icon(Icons.arrow_upward, color: Colors.blue),
            SizedBox(width: 8),
            Text('Lokasi jemput', style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
        StreamBuilder<DatabaseEvent>(
          stream: pickupRef.onValue,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.only(left: 24),
                child: Text('Loading...', style: TextStyle(fontSize: 16)),
              );
            } else if (snapshot.hasError) {
              return const Padding(
                padding: EdgeInsets.only(left: 24),
                child: Text('Error loading location', style: TextStyle(fontSize: 16)),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text(snapshot.data?.snapshot.value.toString() ?? 'Unknown', style: const TextStyle(fontSize: 16)),
              );
            }
          },
        ),
        const Row(
          children: [
            Icon(Icons.arrow_downward, color: Colors.red),
            SizedBox(width: 8),
            Text('Lokasi tujuan', style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
        StreamBuilder<DatabaseEvent>(
          stream: dropRef.onValue,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.only(left: 24),
                child: Text('Loading...', style: TextStyle(fontSize: 16)),
              );
            } else if (snapshot.hasError) {
              return const Padding(
                padding: EdgeInsets.only(left: 24),
                child: Text('Error loading location', style: TextStyle(fontSize: 16)),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text(snapshot.data?.snapshot.value.toString() ?? 'Unknown', style: const TextStyle(fontSize: 16)),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildPaymentDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rincian Pembayaran',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildPaymentRow('Biaya Perjalanan', 'Rp10.000'),
        _buildPaymentRow('Biaya jasa aplikasi', 'Rp5.000'),
        const Divider(),
        _buildPaymentRow('Total', 'Rp15.000'),
        const Divider(),
        _buildPaymentRow('Bayar Pakai NebengPay', 'Rp15.000'),
      ],
    );
  }

  Widget _buildPaymentRow(String title, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        Text(amount, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage_User(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(63, 81, 181, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        ),
        child: const Text(
          'Back',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
