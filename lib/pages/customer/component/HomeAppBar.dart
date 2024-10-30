import 'package:ecommercettl/models/UserModel.dart';
import 'package:ecommercettl/pages/customer/profile.dart';
import 'package:ecommercettl/pages/customer/update_profile.dart';
import 'package:ecommercettl/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeAppBar extends StatefulWidget {
  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  String? uid;
  late AuthService auth = AuthService();
  UserModel? userModel;

  Future<UserModel?> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Icon(Icons.menu, color: Colors.black),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/logo-cus.png',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 8),
          Text(
            'TTL',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
      actions: [
        FutureBuilder<UserModel?>(
          future: _getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                ),
              );
            } else if (snapshot.hasError) {
              return Icon(Icons.error, color: Colors.red);
            } else if (snapshot.hasData && snapshot.data != null) {
              return CircleAvatar(
                radius: 20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                    context,
                      MaterialPageRoute(builder: (context) => UpdateProfilePage()),
                    );
                  },
                  child: CircleAvatar(
                  radius: 20,
                  backgroundImage: snapshot.data!.imgAvatar != null
                    ? NetworkImage(snapshot.data!.imgAvatar)
                    : AssetImage('assets/default_avatar.png') as ImageProvider,
                  ),
                ),
              );
            } else {
              return CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/default_avatar.png'),
              );
            }
          },
        ),
        SizedBox(width: 16),
      ],
    );
  }
}