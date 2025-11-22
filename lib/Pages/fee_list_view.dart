import 'package:fin_tech/Provider/providers.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeeListView extends StatelessWidget {
  const FeeListView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('fee').where(
            'studentId', isEqualTo: authProviders
            .getUser()
            ?.id)
            .snapshots(),
        builder: (context, snapshot)
    {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Center(child: Text('No records found.'));
      }
      final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

      return ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, index) {
          final data = documents[index].data() as Map<String, dynamic>;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(data['studentName'] ?? 'No Name'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Fee: ${data['totalFee'] ?? 'N/A'}'),
                  Text('Paid Fee: ${data['paidFee'] ?? 'N/A'}'),
                ],
              ),
            ),
          );
        },
      );
    },);
  }
}
