import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportCommentPage extends StatefulWidget {
  final String postId;
  final String commentId;
  final String postImageUrl;
  final String postContent;
  final String reportedUserId;

  ReportCommentPage({
    required this.postId,
    required this.commentId,
    required this.postImageUrl,
    required this.postContent,
    required this.reportedUserId,
  });

  @override
  _ReportCommentPageState createState() => _ReportCommentPageState();
}

class _ReportCommentPageState extends State<ReportCommentPage> {
  final TextEditingController _reportController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitReport() async {
    if (_reportController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập nội dung báo cáo')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot reporterSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        DocumentSnapshot reportedUserSnapshot = await FirebaseFirestore.instance.collection('users').doc(widget.reportedUserId).get();

        await FirebaseFirestore.instance.collection('post_reports').add({
          'postId': widget.postId,
          'commentId': widget.commentId,
          'reporterId': user.uid,
          'reporterUsername': reporterSnapshot['username'],
          'reporterEmail': reporterSnapshot['email'],
          'reportContent': _reportController.text,
          'timestamp': FieldValue.serverTimestamp(),
          'postImageUrl': widget.postImageUrl,
          'postContent': widget.postContent,
          'reportedUserId': widget.reportedUserId,
          'reportedUsername': reportedUserSnapshot['username'],
          'reportedEmail': reportedUserSnapshot['email'],
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Báo cáo đã được gửi thành công')),
        );

        Navigator.of(context).pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi. Vui lòng thử lại')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _reportController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Báo cáo bình luận'),
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(widget.postImageUrl),
            SizedBox(height: 20),
            TextField(
              controller: _reportController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Nội dung báo cáo',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _submitReport,
                    child: Text('Gửi báo cáo'),
                  ),
          ],
        ),
      ),
    ),
  );
}
}