import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Ruang Kerja',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
            tooltip: 'Profil Saya',
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[200], // Warna latar belakang
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('places').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'Tidak ada ruang kerja yang tersedia.',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              );
            }
            final places = snapshot.data!.docs;
            return ListView.builder(
              itemCount: places.length,
              itemBuilder: (context, index) {
                final place = places[index];
                return Card(
                  elevation: 3, // Bayangan pada card
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
                      place['name'] ?? 'Nama tidak tersedia',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                      place['description'] ?? 'Deskripsi tidak tersedia',
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.blueAccent,
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/detail', arguments: {
                        'id': place.id,
                        'name': place['name'],
                        'description': place['description'],
                      });
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/schedule');
        },
        backgroundColor: Colors.blueAccent,
        icon: const Icon(Icons.calendar_today),
        label: const Text('Lihat Jadwal'),
        tooltip: 'Lihat Jadwal Kosong',
      ),
    );
  }
}
