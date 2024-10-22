import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String username;
  String email;
  String password;
  String phone;
  String address;
  String dob;
  String fullName;
  String role;
  String imgAvatar;

  UserModel({
    this.id = "",
    this.username = "",
    this.email = "",
    this.password = "",
    this.phone = "",
    this.address = "",
    this.dob = "",
    this.fullName = "",
    this.role = "",
    this.imgAvatar = "",
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id : doc.id,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      dob: data['dob'] ?? '',
      fullName: data['fullName'] ?? '',
      role: data['role'] ?? '',
      imgAvatar: data['imgAvatar'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'phone': phone,
      'address': address,
      'dob': dob,
      'fullName': fullName,
      'imgAvatar': imgAvatar,
      'role': role,
    };
  }
}