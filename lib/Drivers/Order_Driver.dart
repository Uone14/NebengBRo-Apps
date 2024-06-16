import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:nebengbro_apps/Drivers/home.dart';
import 'package:nebengbro_apps/Drivers/jemput_pelanggan.dart';

class OrderDrivers extends StatefulWidget {
  const OrderDrivers({super.key});

  @override
  _OrderDriversState createState() => _OrderDriversState();
}

class _OrderDriversState extends State<OrderDrivers> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String endLocation = 'Loading...';
  String startLocation = 'Loading...';
  String driverName = 'Loading...';

  @override
  void initState() {
    super.initState();
    fetchLocationData();
    fetchDriverData();
  }

  Future<void> fetchLocationData() async {
    DatabaseReference endLocationRef = FirebaseDatabase.instance.ref('locations/end/name');
    DatabaseReference startLocationRef = FirebaseDatabase.instance.ref('locations/start/name');

    String endLocationFetched = (await endLocationRef.once()).snapshot.value.toString();
    String startLocationFetched = (await startLocationRef.once()).snapshot.value.toString();

    setState(() {
      endLocation = endLocationFetched;
      startLocation = startLocationFetched;
    });
  }

  Future<void> fetchDriverData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('drivers').doc(user.uid).get();
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      setState(() {
        driverName = data['name'] ?? 'No name';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permintaan Penjemputan'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '19:02',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/image/profil.png'),
                    radius: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driverName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text('Status Kerja: Aktif'),
                    ],
                  ),
                  const Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                      Text('5.00'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Order Number and Status
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                ],
              ),
              const SizedBox(height: 20),
              // Nebeng Bro Section
              Row(
                children: [
                  Image.asset(
                    'assets/image/Logo.png',
                    height: 50,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Nebeng Bro',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Payment Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Bayar pakai NebengPay Rp15.000', style: TextStyle(color: Colors.black)),
                ),
              ),
              const SizedBox(height: 20),
              // Location Details
              ListTile(
                leading: Icon(Icons.arrow_upward, color: Colors.blue),
                title: const Text(
                  "Penjemputan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  startLocation,
                ),
              ),
              ListTile(
                leading: Icon(Icons.location_on, color: Colors.red),
                title: const Text(
                  "Tujuan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  endLocation,
                ),
              ),
              const SizedBox(height: 20),
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('Chat'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Jemput_Pelanggan()),
                      );
                    },
                    icon: const Icon(Icons.person_outline),
                    label: const Text('Jemput Pelanggan'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Back Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Beranda_Driver(username: 'user')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(63, 81, 181, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Back', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
