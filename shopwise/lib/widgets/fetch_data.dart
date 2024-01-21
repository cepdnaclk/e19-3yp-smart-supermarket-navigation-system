import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Widget fetchData(String title, CollectionReference collection) {
  return FutureBuilder<QuerySnapshot>(
    future: collection.get(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else {
        // Data retrieved successfully
        List<DocumentSnapshot> data = snapshot.data!.docs;

        // Process and display the data as needed
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  var itemData = data[index].data() as Map<String, dynamic>;
                  return ListTile(
                    title: Text(itemData['title']),
                    subtitle: Text(itemData['price']),
                    // Add other fields as needed
                  );
                },
              ),
            ),
          ],
        );
      }
    },
  );
}
