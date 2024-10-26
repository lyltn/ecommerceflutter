import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercettl/pages/client/shoplistproduct.dart';
import 'package:ecommercettl/services/brand_service.dart';
import 'package:ecommercettl/services/category_service.dart';
import 'package:ecommercettl/services/product_service.dart';
import 'package:ecommercettl/services/shop_service.dart';
import 'package:flutter/material.dart';
import 'package:ecommercettl/widget/widget_support.dart';

class ResourceShop extends StatefulWidget {
  const ResourceShop({super.key});

  @override
  State<ResourceShop> createState() => _ResourceShopState();
}

class _ResourceShopState extends State<ResourceShop> {
  bool brandStatus = true;
  bool categoryStatus = true;
  final ProductService productService = ProductService();

  String? uid;

  @override
  void initState() {
    super.initState();

    // Anonymous async function inside initState
    () async {
      uid = await ShopService.getCurrentUserId();
      print('User ID: $uid');
      setState(() {}); // Update UI if necessary
    }();
  }

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
    final CategoryService categoryService = CategoryService();
    final TextEditingController nameController = TextEditingController();
    // Initialize with default status
    String? editingCateId; // Track the category being edited

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
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('categorys')
                                      .where('userid',
                                          isEqualTo: uid!) // Correct field
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }

                                    if (snapshot.hasError) {
                                      return const Text('Lỗi khi lấy dữ liệu.');
                                    }

                                    if (!snapshot.hasData ||
                                        snapshot.data!.docs.isEmpty) {
                                      return const Text(
                                          'Không có danh mục nào.');
                                    }

                                    var categoryDocs = snapshot.data!.docs;

                                    return ListView.builder(
                                      itemCount: categoryDocs.length,
                                      itemBuilder: (context, index) {
                                        var category = categoryDocs[index]
                                            .data() as Map<String, dynamic>;
                                        var categoryId = categoryDocs[index].id;

                                        return ListTile(
                                          title: Text(
                                            category['name'] ?? 'No Name',
                                            style: AppWiget.TextFeildStyle(),
                                          ),
                                          subtitle: Text(
                                              category['status'] ?? 'Unknown'),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.edit_outlined,
                                                    color: Colors.blue),
                                                onPressed: () {
                                                  // Set the fields with the current category data for editing
                                                  nameController.text =
                                                      category['name'] ?? '';
                                                  categoryStatus =
                                                      category['status'] ==
                                                          'active';
                                                  editingCateId = categoryId;
                                                  Navigator.of(context)
                                                      .pop(); // Store the editing ID
                                                },
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete,
                                                    color: Colors.red),
                                                onPressed: () async {
                                                  await categoryService
                                                      .deleteCategory(
                                                          categoryId);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            'Danh mục đã được xoá')),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
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
                controller: nameController,
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
                        scale: 0.8, // Adjust scale for Switch size
                        child: Switch(
                          value: categoryStatus,
                          onChanged: (value) {
                            setState(() {
                              categoryStatus =
                                  value; // Update the category status
                            });
                          },
                          activeColor: const Color.fromARGB(
                              255, 113, 155, 65), // Active color
                          inactiveTrackColor:
                              Colors.lightGreen.shade100, // Inactive color
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (nameController.text.isNotEmpty) {
                        if (editingCateId != null) {
                          // Update the existing category
                          await categoryService.updateCategory(
                            editingCateId!,
                            nameController.text,
                            uid!, // User ID
                            categoryStatus ? 'active' : 'inactive',
                          );

                          // Clear the editing category ID
                          editingCateId = null;
                        } else {
                          // Add a new category
                          await categoryService.addCategory(
                            nameController.text,
                            uid!, // User ID
                            categoryStatus ? 'active' : 'inactive',
                          );
                        }

                        // Clear the text fields after submission
                        nameController.clear();

                        // Show a success message using a SnackBar
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Danh mục đã được thêm hoặc cập nhật')),
                        );
                      } else {
                        // Show an error message if any field is empty
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Vui lòng nhập đầy đủ thông tin')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      'Lưu',
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

  // To keep track of the brand being edited

  Widget _buildBrandForm(BuildContext context) {
    final BrandService brandService = BrandService();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController nationController = TextEditingController();
    // Initialize with default status
    String? editingBrandId;
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
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('brands')
                                        .where('userid', isEqualTo: uid!)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }

                                      if (snapshot.hasError) {
                                        return const Text(
                                            'Lỗi khi lấy dữ liệu.');
                                      }

                                      if (!snapshot.hasData ||
                                          snapshot.data!.docs.isEmpty) {
                                        return const Text(
                                            'Không có thương hiệu nào.');
                                      }

                                      var brandDocs = snapshot.data!.docs;

                                      return ListView.builder(
                                        itemCount: brandDocs.length,
                                        itemBuilder: (context, index) {
                                          var brand = brandDocs[index].data()
                                              as Map<String, dynamic>;
                                          var brandId = brandDocs[index].id;

                                          return ListTile(
                                            title: Text(
                                              brand['name'] ?? 'No Name',
                                              style: AppWiget.TextFeildStyle(),
                                            ),
                                            subtitle: Text(
                                                brand['nation'] ?? 'Unknown'),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () async {
                                                    await brandService
                                                        .deleteBrand(brandId);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                              'Thương hiệu đã được xoá')),
                                                    );
                                                  },
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.edit_outlined,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () {
                                                    // Populate form with the brand's data
                                                    nameController.text =
                                                        brand['name'] ?? '';
                                                    nationController.text =
                                                        brand['nation'] ?? '';
                                                    brandStatus = brand[
                                                            'status'] ==
                                                        'active'; // Assuming status is saved as 'active' or 'inactive'
                                                    editingBrandId = brandId;
                                                    Navigator.of(context)
                                                        .pop(); // Set the brand ID being edited
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: const Text('Đóng'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    )
                  ],
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: nameController,
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
                  controller: nationController,
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
                          scale: 0.8, // Adjust scale for Switch size
                          child: Switch(
                            value: brandStatus,

                            onChanged: (value) {
                              setState(() {
                                brandStatus = value;
                              });
                            },
                            activeColor: const Color.fromARGB(
                                255, 113, 155, 65), // Active color
                            inactiveTrackColor:
                                Colors.lightGreen.shade100, // Inactive color
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (nameController.text.isNotEmpty &&
                            nationController.text.isNotEmpty) {
                          if (editingBrandId != null) {
                            // Update the existing brand
                            await brandService.updateBrand(
                              editingBrandId!,
                              nameController.text,
                              nationController.text,
                              uid!,
                              brandStatus ? 'active' : 'inactive',
                            );

                            // Clear the editing brand ID
                            editingBrandId = null;
                          } else {
                            // Add a new brand
                            await brandService.addBrand(
                              nameController.text,
                              nationController.text,
                              uid!,
                              brandStatus ? 'active' : 'inactive',
                            );
                          }

                          // Clear the text fields after submission
                          nameController.clear();
                          nationController.clear();

                          // Show a success message using a SnackBar
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Thương hiệu đã được thêm hoặc cập nhật')),
                          );
                        } else {
                          // Show an error message if any field is empty
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Vui lòng nhập đầy đủ thông tin')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text(
                        'Lưu',
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
