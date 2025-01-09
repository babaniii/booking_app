import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingActionsScreen extends StatelessWidget {
  const BookingActionsScreen({Key? key}) : super(key: key);

  Future<void> _updateStatus(
      BuildContext context, String bookingId, String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({'status': status});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking $status!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengupdate: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = ModalRoute.of(context)!.settings.arguments as QueryDocumentSnapshot;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aksi Booking'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Tempat: ${booking['placeId']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _updateStatus(context, booking.id, 'completed'),
              child: const Text('Selesai Menggunakan'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _updateStatus(context, booking.id, 'canceled'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text('Batal'),
            ),
          ],
        ),
      ),
    );
  }
}
