import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercettl/models/Product.dart';
import 'package:ecommercettl/pages/customer/component/ProductCard.dart';
import 'package:ecommercettl/pages/customer/productDetail.dart';
import 'package:ecommercettl/services/customer_service.dart';
import 'package:ecommercettl/services/shop_service.dart';
import 'package:flutter/material.dart';

class ShopDetailPage extends StatefulWidget {
  final String shopName;

  ShopDetailPage({required this.shopName});

  @override
  _ShopDetailPageState createState() => _ShopDetailPageState();
}

class _ShopDetailPageState extends State<ShopDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? uid;
  String? shopid;
  List<Product>? productList;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeUid();
    _fetchProductByShop();
  }

  Future<void> _initializeUid() async {
    uid = await ShopService.getCurrentUserId();
    shopid = await ShopService.getUidByShopName(widget.shopName);
    setState(() {}); // Update UI after UID is obtained
    print("useriddddddddddddddd:${uid}");
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  void _fetchProductByShop() async{
    CustomerService customerService = CustomerService();
    uid = await ShopService.getCurrentUserId();
    try {
      productList = await customerService.fetchProductByShopId(uid!);
      print("productlist ${productList}");
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shopName),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Online 3 phút trước",
                      style: TextStyle(fontSize: 12, color: Colors.white70)),
                  Text("4.6/5.0 | 621,9k Người theo dõi",
                      style: TextStyle(fontSize: 12, color: Colors.white70)),
                ],
              ),
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: "Shop"),
                  Tab(text: "Sản phẩm"),
                  Tab(text: "Danh mục hàng"),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          shopid != null
              ? ShopInfoTab(shopid: shopid!) // Add the new ShopInfoTab
              : Center(child: CircularProgressIndicator()),
          shopid != null
              ? ProductsTab(uid: shopid!, list: productList!,)
              : Center(child: CircularProgressIndicator()),
          shopid != null
              ? CategoriesTab(shopid: shopid!)
              : Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

class ProductsTab extends StatelessWidget {
  final String uid;
  final List<Product> list;

  ProductsTab({required this.uid, required this.list});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.6, // Adjust
      ),
      itemCount: list.length,
      itemBuilder: (context, index) {
        var productData = list[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Productdetail(newProduct: productData),
              ),
            );
          },
          child: ProductCard(
            imagePath: productData.imageUrls[0],
            name: productData.name,
            price: productData.price,
            rating: 5, // Assuming static rating and review count for now
            reviewCount: 10,
            sold: 3,
             width: MediaQuery.of(context).size.width / 2 - 15, // Adjust card width
             height: 350, // Set a fixed height for the card
          ),
        );
      },
    );
  }
}


// class ProductCard extends StatelessWidget {
//   final Product data;

//   ProductCard({required this.data});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Image.network(
//             data["imageUrl"][0] ?? "https://via.placeholder.com/150",
//             height: 130,
//             width: double.infinity,
//             fit: BoxFit.cover,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               data["name"] ?? "Product Name",
//               style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Text(
//               (data["price"] ?? 0.0).toString(),
//               style: TextStyle(color: Colors.red),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("⭐ ${data["rating"] ?? "5.0"}"),
//                 Text("Đã bán ${data["sold"] ?? "3"}"),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class CategoriesTab extends StatelessWidget {
  final String shopid;

  CategoriesTab({required this.shopid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('categorys')
          .where('userid', isEqualTo: shopid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final categories = snapshot.data!.docs;

        return ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            var categoryData = categories[index].data() as Map<String, dynamic>;
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Góc bo tròn
              ),
              margin: EdgeInsets.symmetric(
                  vertical: 8), // Khoảng cách giữa các Card
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Căn trái
                  children: [
                    Text(
                      categoryData["name"] ?? "Danh mục",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ShopInfoTab extends StatelessWidget {
  final String shopid;

  ShopInfoTab({required this.shopid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(shopid)
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        // Check if the user document exists
        if (!userSnapshot.data!.exists) {
          return Center(child: Text("User not found"));
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>?;

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('shopRequests')
              .where('uid', isEqualTo: shopid)
              .snapshots(),
          builder: (context, shopSnapshot) {
            if (!shopSnapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            // Check if there are any shop documents
            if (shopSnapshot.data!.docs.isEmpty) {
              return Center(child: Text("Shop information not found"));
            }

            // Get the first document's data
            final shopData =
                shopSnapshot.data!.docs.first.data() as Map<String, dynamic>;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Information Section
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green[50], // Light green background
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              userData?['imgAvatar'] ??
                                  "https://via.placeholder.com/150"),
                          radius: 50,
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.green),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Địa chỉ: ${userData?['address'] ?? 'N/A'}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.phone, color: Colors.green),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'SĐT: ${userData?['phone'] ?? 'N/A'}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),

                  // Shop Information Section
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green[50], // Light green background
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tên cửa hàng: ${shopData['shopName'] ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800], // Dark green text
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.green),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Ngày tham gia: ${shopData['submittedAt'] ?? 'N/A'}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.description, color: Colors.green),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Mô tả shop: ${shopData['shopDescription'] ?? 'N/A'}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.email, color: Colors.green),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Email: ${shopData['email'] ?? 'N/A'}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
