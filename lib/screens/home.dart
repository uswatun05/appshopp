
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Product {
  final String name;
  final int price;
  final String imagePath;
  final String category;

  Product({
    required this.name,
    required this.price,
    required this.imagePath,
    required this.category,
  });
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> categories = ['Semua', 'Cewek', 'Cowok', 'Atasan', 'Bawahan', 'Aksesoris'];
  final formatRupiah = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  int selectedCategoryIndex = -1;
  int selectedPriceRange = -1;
  List<bool> isFavorited = List.generate(7, (_) => false);

  // Data produk
  final List<Product> allProducts = [
    Product(name: 'Kemeja Unisex', price: 129000, imagePath: 'assets/images/baju.jpg', category: 'Semua'),
    Product(name: 'Kaos Cewek', price: 89000, imagePath: 'assets/images/baju2.jpg', category: 'Cewek'),
    Product(name: 'Celana Jeans', price: 149000, imagePath: 'assets/images/baju3.jpg', category: 'Cowok'),
    Product(name: 'Rok Mini', price: 99000, imagePath: 'assets/images/baju4.jpg', category: 'Cewek'),
    Product(name: 'Aksesoris Kalung', price: 59000, imagePath: 'assets/images/baju5.jpg', category: 'Aksesoris'),
    Product(name: 'Jaket Cowok', price: 199000, imagePath: 'assets/images/baju6.jpg', category: 'Cowok'),
    Product(name: 'Kaos rajut', price: 45000, imagePath: 'assets/images/baju7.jpg', category: 'Semua'),
  ];

  // Filter produk berdasarkan kategori dan harga
  List<Product> get filteredProducts {
    List<Product> filtered = allProducts;

  if (selectedCategoryIndex != -1) {
    String selectedCategory = categories[selectedCategoryIndex];
    if (selectedCategory != 'Semua') {
      filtered = filtered.where((product) => product.category == selectedCategory).toList();
    }
  }
    

    // Filter berdasarkan harga
   if (selectedPriceRange != -1) {
  if (selectedPriceRange == 0) {
    filtered = filtered.where((product) => product.price < 50000).toList();
  } else if (selectedPriceRange == 1) {
    filtered = filtered.where((product) => product.price >= 50000 && product.price <= 100000).toList();
  } else if (selectedPriceRange == 2) {
    filtered = filtered.where((product) => product.price > 100000).toList();
  }
}


    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shopping',
          style: TextStyle(
            fontFamily: 'Kaushan',
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {},
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: Text('2', style: TextStyle(fontSize: 12, color: Colors.white)),
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => buildFilterSheet(),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // search bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari outfit favoritmu... ',
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Kategori
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    bool isSelected = selectedCategoryIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategoryIndex = index;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 8),
                        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.deepPurpleAccent : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            categories[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.deepPurpleAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),

              // Banner promo
              SizedBox(
                height: 150,
                child: PageView(
                  children: [
                    promoBanner('assets/images/banner1.jpg'),
                    promoBanner('assets/images/banner2.jpg'),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Produk populer
              Text(
                'Rekomendasi Buat Kamu',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: filteredProducts.map((product) {
                  return productCard(product);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget promoBanner(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(imagePath, fit: BoxFit.cover),
    );
  }

  Widget productCard(Product product) {
    int index = allProducts.indexOf(product);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(blurRadius: 4, color: Colors.grey.shade300)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(product.imagePath, fit: BoxFit.cover, width: double.infinity),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(product.name, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(formatRupiah.format(product.price), style: TextStyle(color: Colors.deepPurple)),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(
                isFavorited[index] ? Icons.favorite : Icons.favorite_border,
                color: isFavorited[index] ? Colors.red : Colors.deepPurple,
              ),
              onPressed: () {
                setState(() {
                  isFavorited[index] = !isFavorited[index];
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFilterSheet() {
    return StatefulBuilder(
      builder: (context, setModalState) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Filter Kategori", style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: List.generate(categories.length, (index) {
                  return ChoiceChip(
                    label: Text(categories[index]),
                    selected: selectedCategoryIndex == index,
                    onSelected: (bool selected) {
                      setModalState(() {
                        if (selectedCategoryIndex == index) {
                          selectedCategoryIndex = -1;
                        } else {
                          selectedCategoryIndex = index;
                        }
                      });
                    },
                  );
                }),
              ),
              SizedBox(height: 16),
              Text("Filter Harga", style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: Text("< Rp50rb"),
                    selected: selectedPriceRange == 0,
                    onSelected: (_) {
                      setModalState(() {
                         selectedPriceRange = (selectedPriceRange == 0) ? -1 : 0;
                      });
                    },
                  ),
                  FilterChip(
                    label: Text("Rp50rb–Rp100rb"),
                    selected: selectedPriceRange == 1,
                    onSelected: (_) {setModalState(() { selectedPriceRange = (selectedPriceRange == 1) ? -1 : 1;
                      });
                    },
                  ),
                  FilterChip(
                    label: Text("> Rp100rb"),
                    selected: selectedPriceRange == 2,
                    onSelected: (_) { 
                      setModalState(() {
                        selectedPriceRange = (selectedPriceRange == 2) ? -1 : 2;                                 
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      setModalState(() {
                        selectedCategoryIndex = -1;
                        selectedPriceRange = -1;
                      });
                    },
                    child: Text ('Reset Filter'),
                  ),
                  ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {});                 
                },
                child: Text("Terapkan Filter"),                              
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

