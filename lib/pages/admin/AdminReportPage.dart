import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminReportPage extends StatefulWidget {
  @override
  _AdminReportPageState createState() => _AdminReportPageState();
}

class _AdminReportPageState extends State<AdminReportPage> {
  Future<void> _deleteReport(String docId) async {
    await FirebaseFirestore.instance.collection('post_reports').doc(docId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã xóa báo cáo')),
    );
    setState(() {}); // Reload the page
  }

  Future<void> _deletePost(String postId) async {
    await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã xóa bài viết')),
    );
    setState(() {}); // Reload the page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Báo cáo bài viết'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
        Navigator.of(context).pop();
          },
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('post_reports').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Không có báo cáo nào.'));
          }

          return ListView(
            padding: EdgeInsets.all(16.0),
            children: snapshot.data!.docs.map((doc) {
              return Card(
                margin: EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Người báo cáo: ${doc['reporterUsername']} (${doc['reporterEmail']})'),
                      SizedBox(height: 8),
                      Text('Nội dung báo cáo: ${doc['reportContent']}'),
                      SizedBox(height: 8),
                      Text('Thời gian: ${doc['timestamp'].toDate()}'),
                      SizedBox(height: 8),
                      Text('Nội dung bài viết: ${doc['postContent']}'),
                      SizedBox(height: 8),
                      Text('Người bị báo cáo: ${doc['reportedUsername']} (${doc['reportedEmail']})'),
                      if (doc['postImageUrl'] != null) ...[
                        SizedBox(height: 8),
                        Image.network(doc['postImageUrl']),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteReport(doc.id),
                          ),
                          Text('Xóa báo cáo'),
                          IconButton(
                          icon: Icon(Icons.delete_forever, color: Colors.red),
                          onPressed: () => _deletePost(doc['postId']),
                          ),
                          Text('Xóa bài viết'),
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
    );
  }
}