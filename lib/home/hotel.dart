import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class HotelPage extends StatelessWidget {
  const HotelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotels List',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent)),
        backgroundColor: const Color(0xFF0C1615),
        centerTitle: true,
        elevation: 6,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0C1615),
              Color(0xFF1B5E20),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('hotels').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.greenAccent));
            }

            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data!.docs.isEmpty) {
              return const Center(
                  child: Text('No hotels available',
                      style: TextStyle(color: Colors.greenAccent)));
            }

            final hotels = snapshot.data!.docs;

            return ListView.builder(
              itemCount: hotels.length,
              itemBuilder: (context, index) {
                final hotel = hotels[index];
                final hotelName = hotel['hotelName'];
                final location = hotel['location'];
                final imageUrl = hotel['imageUrl'] ?? '';

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 5,
                  color: Colors.black.withOpacity(0.7),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: imageUrl.isNotEmpty
                          ? Image.network(imageUrl,
                              width: 60, height: 60, fit: BoxFit.cover)
                          : const Icon(Icons.hotel,
                              size: 60, color: Colors.greenAccent),
                    ),
                    title: Text(
                      hotelName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.greenAccent),
                    ),
                    subtitle: Text(location,
                        style: const TextStyle(color: Colors.white70)),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        color: Colors.greenAccent),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HotelRoomsPage(
                              hotelId: hotel.id, hotelName: hotelName),
                        ),
                      );
                    },
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

class HotelRoomsPage extends StatefulWidget {
  final String hotelId;
  final String hotelName;

  const HotelRoomsPage(
      {Key? key, required this.hotelId, required this.hotelName})
      : super(key: key);

  @override
  _HotelRoomsPageState createState() => _HotelRoomsPageState();
}

class _HotelRoomsPageState extends State<HotelRoomsPage> {
  late Razorpay _razorpay;
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";
    DateTime? checkInDate;
  DateTime? checkOutDate;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

   void _selectDates(BuildContext context, String roomNumber, String price) async {
    final DateTime? pickedCheckIn = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedCheckIn != null) {
      final DateTime? pickedCheckOut = await showDatePicker(
        context: context,
        initialDate: pickedCheckIn.add(const Duration(days: 1)),
        firstDate: pickedCheckIn.add(const Duration(days: 1)),
        lastDate: DateTime(2101),
      );

      if (pickedCheckOut != null) {
        setState(() {
          checkInDate = pickedCheckIn;
          checkOutDate = pickedCheckOut;
        });

        _payForRoom(roomNumber, price);
      }
    }
  }


  void _payForRoom(String roomNumber, String price) {
    var options = {
      'key': 'rzp_test_D5Vh3hyi1gRBV0',
      'amount': int.parse(price) * 100,
      'name': 'Hotel Room Booking',
      'description': 'Booking for Room $roomNumber',
      'prefill': {'contact': '1234567890', 'email': 'user@example.com'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {

    DocumentSnapshot roomSnapshot = await FirebaseFirestore.instance
        .collection('hotels')
        .doc(widget.hotelId)
        .collection('rooms')
        .limit(1) // Fetch only one room
        .get()
        .then((snapshot) => snapshot.docs.first);

    String roomNumber = roomSnapshot['roomNumber']; // Extract room number
  await FirebaseFirestore.instance
      .collection('hotels')
      .doc(widget.hotelId)
      .collection('bookings')
      .add({
    'hotelId': widget.hotelId,
    'hotelName': widget.hotelName,
    'roomNumber':roomNumber, 
    'userId': currentUserId,
    'userName': FirebaseAuth.instance.currentUser?.displayName ?? 'Guest',
    'userEmail': FirebaseAuth.instance.currentUser?.email ?? 'N/A',
    'paymentId': response.paymentId,
    'checkInDate': DateFormat('yyyy-MM-dd').format(checkInDate!),
    'checkOutDate': DateFormat('yyyy-MM-dd').format(checkOutDate!),
    'amount': response.orderId,
    'timestamp': FieldValue.serverTimestamp(),
  });

  ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text('Payment Successful!')));
}

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment Failed: ${response.message}')));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('External Wallet Selected: ${response.walletName}')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.hotelName} - Rooms',
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent)),
        backgroundColor: const Color(0xFF0C1615),
        centerTitle: true,
        elevation: 6,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0C1615), Color(0xFF1B5E20)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('hotels')
              .doc(widget.hotelId)
              .collection('rooms')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.greenAccent));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                  child: Text('No rooms available',
                      style: TextStyle(color: Colors.greenAccent)));
            }

            final rooms = snapshot.data!.docs;

            return ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                final room = rooms[index];
                final roomNumber = room['roomNumber'] ?? 'Unknown';
                final roomPrice = room['price'] ?? '0';
                final roomImage = room['imageUrl'] ?? '';
                final features = room['features'] ?? {};
                final ac = features['AC'] ?? false;
                final balcony = features['Balcony'] ?? false;
                final roomService = features['Room Service'] ?? false;
                final wifi = features['Wi-Fi'] ?? false;
                final isAvailable = room['isAvailable'] ?? false;

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  elevation: 5,
                  color: Colors.black.withOpacity(0.7),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: roomImage.isNotEmpty
                              ? Image.network(roomImage,
                                  width: 60, height: 60, fit: BoxFit.cover)
                              : const Icon(Icons.bed,
                                  size: 60, color: Colors.greenAccent),
                        ),
                        title: Text('Room $roomNumber',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.greenAccent)),
                        subtitle: Text('Price: \$${roomPrice}',
                            style: const TextStyle(color: Colors.white70)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Features:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.greenAccent)),
                            Text('AC: ${ac ? 'Yes' : 'No'}',
                                style: const TextStyle(color: Colors.white70)),
                            Text('Balcony: ${balcony ? 'Yes' : 'No'}',
                                style: const TextStyle(color: Colors.white70)),
                            Text('Room Service: ${roomService ? 'Yes' : 'No'}',
                                style: const TextStyle(color: Colors.white70)),
                            Text('Wi-Fi: ${wifi ? 'Yes' : 'No'}',
                                style: const TextStyle(color: Colors.white70)),
                            Text('Available: ${isAvailable ? 'Yes' : 'No'}',
                                style: const TextStyle(color: Colors.white70)),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () =>
                                   _selectDates(context,roomNumber, roomPrice),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.greenAccent),
                                child: const Text('Book Now',
                                    style: TextStyle(color: Colors.black)),
                              ),
                            ),
                          ],
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
