import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Tambahkan ini untuk memformat tanggal dan waktu
import 'package:nebengbro_apps/Drivers/dompet1.dart';
import 'package:nebengbro_apps/Drivers/map_driver.dart';
import 'package:nebengbro_apps/Drivers/message.dart';
import 'package:nebengbro_apps/Drivers/profile.dart';

class Beranda_Driver extends StatefulWidget {
  final String? username;

  const Beranda_Driver({super.key, required this.username});

  @override
  _Beranda_DriverState createState() => _Beranda_DriverState();
}

class _Beranda_DriverState extends State<Beranda_Driver> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      HomeScreen(username: widget.username),
      PendapatanScreen1(),
      TextMessageScreen(),
      ProfilePage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: _buildAnimatedIcon(Icons.home, 0),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: _buildAnimatedIcon(Icons.account_balance_wallet, 1),
            label: "Dompet",
          ),
          BottomNavigationBarItem(
            icon: _buildAnimatedIcon(Icons.chat, 2),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: _buildAnimatedIcon(Icons.person, 3),
            label: "Profile",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromRGBO(63, 81, 181, 1),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildAnimatedIcon(IconData icon, int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: _selectedIndex == index ? 35 : 25,
      height: _selectedIndex == index ? 35 : 25,
      child: Icon(
        icon,
        color: _selectedIndex == index
            ? const Color.fromRGBO(63, 81, 181, 1)
            : Colors.grey,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String? username;

  const HomeScreen({super.key, required this.username});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> usersWithOrders = [];
  bool isOnline = true;

  @override
  void initState() {
    super.initState();
    _fetchUsersWithOrders();
  }

  Future<void> _fetchUsersWithOrders() async {
    QuerySnapshot usersSnapshot = await _firestore.collection('users').get();
    for (var userDoc in usersSnapshot.docs) {
      QuerySnapshot ordersSnapshot =
          await userDoc.reference.collection('orders').get();
      if (ordersSnapshot.docs.isNotEmpty) {
        setState(() {
          usersWithOrders.add({
            'name': userDoc['name'],
            'email': userDoc['email'],
            'orders': ordersSnapshot.docs.map((orderDoc) {
              var orderData = orderDoc.data() as Map<String, dynamic>;
              return {
                'LokasiTujuan': orderData.containsKey('end_location')
                    ? orderData['end_location']['LokasiTujuan']
                    : 'No Location',
              };
            }).toList(),
          });
        });
      }
    }
  }

  void toggleOnlineStatus() {
    setState(() {
      isOnline = !isOnline;
    });
  }

  String _formatDateTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: const Color.fromARGB(255, 252, 252, 252),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 76, 138, 211),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: toggleOnlineStatus,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isOnline
                                  ? const Color.fromRGBO(191, 231, 49, 1)
                                  : Colors.white,
                              foregroundColor:
                                  isOnline ? Colors.black : Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                            ),
                            child: const Text('Online'),
                          ),
                          const SizedBox(width: 10),
                          OutlinedButton(
                            onPressed: toggleOnlineStatus,
                            style: OutlinedButton.styleFrom(
                              backgroundColor: isOnline
                                  ? Colors.white
                                  : const Color.fromRGBO(191, 231, 49, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              side: BorderSide(
                                color: isOnline
                                    ? Colors.grey
                                    : const Color.fromRGBO(191, 231, 49, 1),
                              ),
                            ),
                            child: Text(
                              'Offline',
                              style: TextStyle(
                                  color: isOnline ? Colors.grey : Colors.black),
                            ),
                          ),
                        ],
                      ),
                      Image.asset(
                        'assets/image/car.png',
                        width: 120,
                        height: 120,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: usersWithOrders.length,
                  itemBuilder: (context, index) {
                    var user = usersWithOrders[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Maps_Drivers()),
                        );
                      },
                      child: Container(
                        width: screenWidth * 0.9,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 255, 255, 255),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    user['name'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    user['email'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: user['orders'].length,
                                    itemBuilder: (context, orderIndex) {
                                      var order = user['orders'][orderIndex];
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 5),
                                          Text(
                                            'Tujuan: ${order['LokasiTujuan']}', // Display the end location name
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                          const Divider(),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Maps_Drivers()),
                                );
                              },
                              child: Image.asset(
                                'assets/image/maps.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
