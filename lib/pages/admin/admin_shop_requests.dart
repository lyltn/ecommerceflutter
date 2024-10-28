import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class AdminShopRequestsPage extends StatelessWidget {
  final String smtpServer = 'smtp.gmail.com';
  final int smtpPort = 587;
  final String smtpUsername = 'kiendn2@gmail.com';
  final String smtpPassword = 'jiuo lvls dkxd jfos';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yêu cầu đăng ký Shop'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
        Navigator.of(context).pop();
          },
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('shopRequests').where('status', isEqualTo: 'pending').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return ListTile(
                title: Text(doc['shopName']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mô tả: ${doc['shopDescription']}'),
                    Text('Liên lạc: ${doc['email']}'),
                    Text('Trạng thái: ${doc['status']}'),
                    Text('Ngày gửi: ${doc['submittedAt']}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () => _approveRequest(doc.id, doc['uid'], doc['email']),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () => _rejectRequest(doc.id, doc['email']),
                    ),
                  ],
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Request Details'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Shop Name: ${doc['shopName']}'),
                            Text('Email: ${doc['email']}'),
                            Text('Description: ${doc['shopDescription']}'),
                            Text('Status: ${doc['status']}'),
                            Text('Submitted At: ${doc['submittedAt']}'),
                            Text('Reviewed By: ${doc['reviewedBy'] ?? 'null'}'),
                            Text('Reviewed At: ${doc['reviewedAt'] ?? 'null'}'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            child: Text('Close'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Future<void> _approveRequest(String docId, String uid, String email) async {
    await FirebaseFirestore.instance.collection('shopRequests').doc(docId).update({
      'status': 'approved',
      'reviewedBy': FirebaseAuth.instance.currentUser!.uid,
      'reviewedAt': DateTime.now(),
    });

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'role': 'USER',
    });

    // Gửi email thông báo
    await _sendEmail(
        email,
        '🎉 Chúc mừng! 🎉\n\n'
            'Xin chào,\n\n'
            'Chúng tôi rất vui mừng thông báo rằng yêu cầu đăng ký shop của bạn đã được phê duyệt thành công! 🥳\n\n'
            '🌟 Giờ đây, bạn có thể bắt đầu quản lý và phát triển cửa hàng của mình trên nền tảng của chúng tôi. Đừng ngần ngại liên hệ với chúng tôi nếu bạn có bất kỳ câu hỏi hoặc yêu cầu hỗ trợ nào.\n\n'
            'Chúc bạn kinh doanh thuận lợi và thành công! 🚀\n\n'
            'Trân trọng,\n'
            'Đội ngũ quản trị\n'
    );
  }

  Future<void> _rejectRequest(String docId, String email) async {
    await FirebaseFirestore.instance.collection('shopRequests').doc(docId).update({
      'status': 'rejected',
      'reviewedBy': FirebaseAuth.instance.currentUser!.uid,
      'reviewedAt': DateTime.now(),
    });

    // Gửi email thông báo
    await _sendEmail(
        email,
        '🔔 Thông báo cập nhật từ yêu cầu đăng ký shop của bạn\n\n'
            'Xin chào,\n\n'
            'Cảm ơn bạn đã quan tâm và gửi yêu cầu đăng ký shop trên nền tảng của chúng tôi. Sau khi xem xét kỹ lưỡng, chúng tôi rất tiếc phải thông báo rằng hiện tại chúng tôi chưa thể phê duyệt yêu cầu này. 😔\n\n'
            '🙏 Điều này không ảnh hưởng đến cơ hội hợp tác trong tương lai. Chúng tôi rất mong có dịp đồng hành cùng bạn trong những lần tới. Đừng ngần ngại liên hệ nếu bạn cần thêm thông tin hay hỗ trợ nào khác.\n\n'
            'Trân trọng,\n'
            'Đội ngũ quản trị\n'
    );
  }

  Future<void> _sendEmail(String toEmail, String message) async {
    final smtpServerInstance = SmtpServer(
      smtpServer,
      port: smtpPort,
      username: smtpUsername,
      password: smtpPassword,
    );

    final emailMessage = Message()
      ..from = Address(smtpUsername, 'Admin')
      ..recipients.add(toEmail)
      ..subject = 'Thông báo yêu cầu đăng ký shop'
      ..text = message;

    try {
      final sendReport = await send(emailMessage, smtpServerInstance);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent. \n' + e.toString());
    }
  }
}