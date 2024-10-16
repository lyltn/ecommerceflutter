import 'package:flutter/material.dart';

class FilterPanel extends StatefulWidget {
  @override
  _FilterPanelState createState() => _FilterPanelState();
}

class _FilterPanelState extends State<FilterPanel> {
  bool _showMore = false;
  List<bool> _selectedItems = [];
  List<String> _categories = [];
  List<bool> _selectedPrices = []; // Track selected price ranges
  int _visibleItemCount = 2; // Number of rows to show before 'See more'
  TextEditingController _minPriceController = TextEditingController();
  TextEditingController _maxPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  // Simulate fetching data from database/API
  Future<void> _fetchCategories() async {
    // Simulate a delay for fetching
    await Future.delayed(Duration(seconds: 2));
    List<String> fetchedCategories = [
      'Thời trang nam',
      'Thời trang nữ',
      'Phụ kiện',
      'Giày dép',
      'Trang sức',
      'Mũ nón',
      'Đồng hồ',
      'Túi xách'
    ];

    setState(() {
      _categories = fetchedCategories;
      _selectedItems = List.generate(_categories.length, (index) => false);
    });
  }

  // Save selected categories (Simulated database/API call)
  void _saveSelectedCategories() {
    List<String> selectedCategories = [];
    for (int i = 0; i < _categories.length; i++) {
      if (_selectedItems[i]) {
        selectedCategories.add(_categories[i]);
      }
    }
    // Simulate sending selected categories to a database
    print('Selected Categories: $selectedCategories');
    // Here you can make an API call to save the selected categories.
  }

  // Save price range
  void _savePriceRange() {
    String minPrice = _minPriceController.text;
    String maxPrice = _maxPriceController.text;
    print('Selected Price Range: $minPrice - $maxPrice');
    // You can also handle the logic for selected price ranges.
  }

  @override
  Widget build(BuildContext context) {
    return _categories.isEmpty
        ? Center(child: CircularProgressIndicator()) // Loading state
        : ListView(
            children: [
              Column(
                children: [
                  Container(
                    color: Color(0xFFD9D9D9),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Bộ lọc tìm kiếm',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 10, top: 10, right: 10, left: 20),
                        child: Text(
                          'Theo danh mục',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      // Loop through categories and dynamically display them
                      ..._buildCategoryRows(),
                      if (_categories.length > _visibleItemCount * 2)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showMore = !_showMore;
                                });
                              },
                              child: Row(
                                children: [
                                  Text(
                                    _showMore ? 'Thu gọn' : 'Xem thêm',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xC7000000),
                                    ),
                                  ),
                                  Icon(
                                    _showMore ? Icons.expand_less : Icons.expand_more,
                                    color: Color(0xC7000000),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      Divider(
                        color: Colors.black,
                        thickness: 0.5,
                        indent: 0,
                        endIndent: 0,
                      ),

                      // Price Range Filter Section
                      _buildPriceRangeFilter(),

                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                child: Text(
                                  'Thiết lập lại',
                                  style: TextStyle(
                                    color:  Color(0xFF15A362),  
                                  )
                                 
                                  ),
                                onPressed: () {
                                  _resetSelections();
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  side: BorderSide(color: Colors.green),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                child: Text(
                                  'Áp dụng',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  ),
                                onPressed: () {
                                  _saveSelectedCategories();
                                  _savePriceRange();
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ],
          );
  }

  // Build category rows dynamically
  List<Widget> _buildCategoryRows() {
    List<Widget> rows = [];
    int totalItems = _showMore ? _categories.length : _visibleItemCount * 2;

    for (int i = 0; i < totalItems; i += 2) {
      rows.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSelectableCategory(i),
              if (i + 1 < totalItems) _buildSelectableCategory(i + 1),
            ],
          ),
        ),
      );
      rows.add(SizedBox(height: 10));
    }
    return rows;
  }

  // Build each selectable category
  Widget _buildSelectableCategory(int index) {
    return Expanded(
      flex: 6,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0), // Add horizontal padding
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedItems[index] = !_selectedItems[index];
            });
          },
          child: Container(
            color: _selectedItems[index] ? Colors.green : Color(0xFFD9D9D9),
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(_categories[index]),
            ),
          ),
        ),
      ),
    );
  }

  // Build Price Range Filter
  Widget _buildPriceRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20, bottom: 10, top: 10),
          child: 
            Text(
            'Khoảng giá (đ)',
            style: TextStyle(fontSize: 18),
          ),
        ),
        Container(
          color: Color(0xFFF0F0F0),
          child:  Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: _minPriceController,
                      decoration: InputDecoration(
                        fillColor: Colors.white, // Set background color to white
                        filled: true, // Enable background fill
                        hintText: 'TỐI THIỂU', // Set hint text
                        border: InputBorder.none, // Remove border
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                SizedBox(width: 10), // Space between fields
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: _maxPriceController,
                      decoration: InputDecoration(
                        fillColor: Colors.white, // Set background color to white
                        filled: true, // Enable background fill
                        hintText: 'TỐI ĐA', // Set hint text
                        border: InputBorder.none, // Remove border
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
              ],
            ),
          )
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
          child: Text(
            'Giá ví dụ:',
            style: TextStyle(fontSize: 16),
          ),
        ),
        
        _buildExamplePriceRanges(),
      ],
    );
  }

  // Build example price ranges
 // Build example price ranges
  Widget _buildExamplePriceRanges() {
    List<String> examplePrices = [
      'Dưới 100,000 VND',
      '100,000 - 500,000 VND',
      '500,000 - 1,000,000 VND',
      'Trên 1,000,000 VND',
    ];

    List<Widget> rows = [];
    List<Widget> priceWidgets = [];

    for (int i = 0; i < examplePrices.length; i++) {
      priceWidgets.add(
        Expanded(
          child: GestureDetector(
            onTap: () {
              // Toggle selection state
              setState(() {
                if (_selectedPrices.length > i && _selectedPrices[i]) {
                  // If the price box is already selected, deselect it
                  _selectedPrices[i] = false;
                  _minPriceController.clear(); // Clear min price
                  _maxPriceController.clear(); // Clear max price
                } else {
                  // Set min and max prices based on the selected example
                  switch (i) {
                    case 0:
                      _minPriceController.text = '0';
                      _maxPriceController.text = '100000';
                      break;
                    case 1:
                      _minPriceController.text = '100000';
                      _maxPriceController.text = '500000';
                      break;
                    case 2:
                      _minPriceController.text = '500000';
                      _maxPriceController.text = '1000000';
                      break;
                    case 3:
                      _minPriceController.text = '1000000';
                      _maxPriceController.text = '999999999'; // No upper limit
                      break;
                  }

                  // Mark the selected price
                  _selectedPrices = List.generate(examplePrices.length, (index) => index == i);
                }
              });
            },
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(5),  // Add horizontal margin for spacing
              decoration: BoxDecoration(
                color: _selectedPrices.length > i && _selectedPrices[i]
                    ? Colors.green
                    : Color(0xFFD9D9D9),
              ),
              alignment: Alignment.center,
              height: 50, // Set a fixed height for all boxes
              child: Text(
                examplePrices[i],
                style: TextStyle(fontSize: 12), // Set font size to 16
                textAlign: TextAlign.center, // Center the text
              ),
            ),
          ),
        ),
      );

      // Create a row every two items
      if ((i + 1) % 2 == 0) {
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: priceWidgets,
        ));
        priceWidgets = []; // Reset the list for the next row
      }
    }

    // Handle the last row if it has an odd number of items
    if (priceWidgets.isNotEmpty) {
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: priceWidgets,
      ));
    }

    return Column(children: rows);
  }


void _resetSelections() {
  setState(() {
    _selectedItems = List.generate(_categories.length, (index) => false);
    _selectedPrices = List.generate(4, (index) => false); // Reset the selected prices
    _minPriceController.clear(); // Clear minimum price
    _maxPriceController.clear(); // Clear maximum price
  });
}
}
