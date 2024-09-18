import 'package:ecommercettl/pages/shoplistproduct.dart';
import 'package:flutter/material.dart';
import 'package:ecommercettl/widget/widget_support.dart';

class ResourceShop extends StatefulWidget {
  const ResourceShop({super.key});

  @override
  State<ResourceShop> createState() => _ResourceShopState();
}

class _ResourceShopState extends State<ResourceShop> {
  bool categoryStatus = true;
  bool brandStatus = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  children: [
                    Image.asset(
                      "images/logo-admin.png",
                      height: 33.0,
                      width: 33.0,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      "TTL",
                      style: AppWiget.HeadlineTextFeildStyle(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShopListProduct()));
                },
                child: Container(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(
                          color: Colors.green, // Đặt màu viền
                          width: 2.0, // Độ dày của viền
                        ),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShopListProduct()));
                      },
                      child: const Text(
                        'Quản lý sản phẩm +',
                        style: TextStyle(
                          color: Colors.green,
                          fontFamily: 'Roboto',
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Thêm danh mục section
              _buildCategoryForm(context),
              const SizedBox(height: 20),
              // Brand Form
              _buildBrandForm(context),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryForm(BuildContext context) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 3,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Form(
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Danh mục",
                    style: AppWiget.boldTextFeildStyle(),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.remove_red_eye_outlined,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Danh sách danh mục',
                                style: AppWiget.boldTextFeildStyle()),
                            content: SingleChildScrollView(
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Wrap(
                                      spacing:
                                          8.0, // Khoảng cách giữa các widget ngang
                                      runSpacing:
                                          2.0, // Khoảng cách giữa các widget dọc
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.green,
                                                width:
                                                    1.0), // Đường viền màu xanh
                                            borderRadius: BorderRadius.circular(
                                                4.0), // Tùy chọn: góc viền bo tròn
                                          ),
                                          padding: EdgeInsets.all(4.0),
                                          child: Text(
                                            'Danh mục 1Danh mục 1Danh mục 1',
                                            style: AppWiget.TextFeildStyle(),
                                            softWrap:
                                                true, // Cho phép xuống dòng
                                          ),
                                        ),
                                        const Icon(
                                          Icons.visibility_outlined,
                                          color: Colors.green,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Wrap(
                                      spacing:
                                          8.0, // Khoảng cách giữa các widget ngang
                                      runSpacing:
                                          2.0, // Khoảng cách giữa các widget dọc
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.green,
                                                width:
                                                    1.0), // Đường viền màu xanh
                                            borderRadius: BorderRadius.circular(
                                                4.0), // Tùy chọn: góc viền bo tròn
                                          ),
                                          padding: EdgeInsets.all(4.0),
                                          child: Text(
                                            'Danh mục 1Danh mục 1Danh mục 1',
                                            style: AppWiget.TextFeildStyle(),
                                            softWrap:
                                                true, // Cho phép xuống dòng
                                          ),
                                        ),
                                        const Icon(
                                          Icons.visibility_off_outlined,
                                          color: Colors.red,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Đóng dialog
                                },
                                child: const Text('Đóng'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'tên danh mục...',
                  hintStyle: TextStyle(
                    fontSize: 12.0,
                    fontFamily: 'Roboto',
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên danh mục';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Trạng thái:',
                          style: AppWiget.SemiBoldTextFeildStyle()),
                      Transform.scale(
                        scale:
                            0.8, // Điều chỉnh tỷ lệ để chiều cao gần với 18 (vì Switch mặc định khá lớn)
                        child: Switch(
                          value: categoryStatus,
                          onChanged: (value) {
                            setState(() {
                              categoryStatus = value;
                            });
                          },
                          activeColor: const Color.fromARGB(
                              255, 113, 155, 65), // Màu khi bật
                          inactiveTrackColor: Colors
                              .lightGreen.shade100, // Màu khi tắt (xanh nhạt)
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      'Thêm',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Roboto',
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandForm(BuildContext context) {
    return SingleChildScrollView(
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Form(
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Thương hiệu của sp",
                      style: AppWiget.boldTextFeildStyle(),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.remove_red_eye_outlined,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Danh sách thương hiệu',
                                  style: AppWiget.boldTextFeildStyle()),
                              content: SingleChildScrollView(
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Wrap(
                                        spacing:
                                            8.0, // Khoảng cách giữa các widget ngang
                                        runSpacing:
                                            2.0, // Khoảng cách giữa các widget dọc
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.green,
                                                  width:
                                                      1.0), // Đường viền màu xanh
                                              borderRadius: BorderRadius.circular(
                                                  4.0), // Tùy chọn: góc viền bo tròn
                                            ),
                                            padding: EdgeInsets.all(4.0),
                                            child: Text(
                                              'Danh mục 1Danh mục 1Danh mục 1',
                                              style: AppWiget.TextFeildStyle(),
                                              softWrap:
                                                  true, // Cho phép xuống dòng
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.green,
                                                  width:
                                                      1.0), // Đường viền màu xanh
                                              borderRadius: BorderRadius.circular(
                                                  4.0), // Tùy chọn: góc viền bo tròn
                                            ),
                                            padding: EdgeInsets.all(4.0),
                                            child: Text(
                                              'Việt nam',
                                              style: AppWiget.TextFeildStyle(),
                                            ),
                                          ),
                                          const Icon(
                                            Icons.visibility_outlined,
                                            color: Colors.green,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Wrap(
                                        spacing:
                                            8.0, // Khoảng cách giữa các widget ngang
                                        runSpacing:
                                            2.0, // Khoảng cách giữa các widget dọc
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.green,
                                                  width:
                                                      1.0), // Đường viền màu xanh
                                              borderRadius: BorderRadius.circular(
                                                  4.0), // Tùy chọn: góc viền bo tròn
                                            ),
                                            padding: EdgeInsets.all(4.0),
                                            child: Text(
                                              'Danh mục 1Danh mục 1Danh mục 1',
                                              style: AppWiget.TextFeildStyle(),
                                              softWrap:
                                                  true, // Cho phép xuống dòng
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.green,
                                                  width:
                                                      1.0), // Đường viền màu xanh
                                              borderRadius: BorderRadius.circular(
                                                  4.0), // Tùy chọn: góc viền bo tròn
                                            ),
                                            padding: EdgeInsets.all(4.0),
                                            child: Text(
                                              'Việt nam',
                                              style: AppWiget.TextFeildStyle(),
                                            ),
                                          ),
                                          const Icon(
                                            Icons.visibility_off_outlined,
                                            color: Colors.red,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Đóng dialog
                                  },
                                  child: const Text('Đóng'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'tên thương hiệu...',
                    hintStyle: TextStyle(
                      fontSize: 12.0,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên thương hiệu';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'tên quốc gia...',
                    hintStyle: TextStyle(
                      fontSize: 12.0,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên quốc gia';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('Trạng thái:',
                            style: AppWiget.SemiBoldTextFeildStyle()),
                        Transform.scale(
                          scale:
                              0.8, // Điều chỉnh tỷ lệ để chiều cao gần với 18 (vì Switch mặc định khá lớn)
                          child: Switch(
                            value: brandStatus,
                            onChanged: (value) {
                              setState(() {
                                brandStatus = value;
                              });
                            },
                            activeColor: const Color.fromARGB(
                                255, 113, 155, 65), // Màu khi bật
                            inactiveTrackColor: Colors
                                .lightGreen.shade100, // Màu khi tắt (xanh nhạt)
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text(
                        'Thêm',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto',
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
