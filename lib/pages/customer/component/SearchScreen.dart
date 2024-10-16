import 'package:ecommercettl/pages/customer/component/FindBar.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<String> searchHistory = [
    'dsfdsfsdf sdfjhklsd fsdfsjfd fds fsdjf',
    'dsfdsfsdf sdfjhklsd fsdfsjfd fds fsdjf',
    'dsfdsfsdf sdfjhklsd fsdfsjfd fds fsdjf',
    'dsfdsfsdf sdfjhklsd fsdfsjfd fds fsdjf',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Findbar(isEnabled: true,),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lịch sử tìm kiếm',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: ListView.separated(
                        itemCount: searchHistory.length,
                        separatorBuilder: (context, index) => Divider(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              searchHistory[index],
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            searchHistory.clear();
                          });
                        },
                        child: Text(
                          'Xoá lịch sử tìm kiếm',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
