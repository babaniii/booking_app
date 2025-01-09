import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jadwal Pemesanan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent, // Warna AppBar
      ),
      body: Container(
        color: Colors.grey[200], // Warna latar belakang
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('bookings').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'Belum ada jadwal pemesanan.',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              );
            }
            final bookings = snapshot.data!.docs;
            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return Card(
                  elevation: 3, // Tambahkan bayangan
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: const Icon(
                        Icons.meeting_room,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      'Tempat: ${booking['placeId']}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tanggal: ${booking['date']}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Jam: ${booking['time'] ?? 'Tidak tersedia'}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    trailing: Text(
                      '${booking['duration']} jam',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
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
