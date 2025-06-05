import 'package:flutter/material.dart';
import 'package:shop_app/global_variables.dart';
import 'package:shop_app/product_card.dart';
import 'package:shop_app/product_details_page.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final List<String> filters = const [
    'All',
    'Addidas',
    'Nike',
    'Bata',
    'Puma',
    'Reebok',
    'Asics',
    'New Balance'
  ];
  late String selectedFilter;
  String searchQuery = '';
  String sortOption = 'Name A-Z';

  @override
  void initState() {
    super.initState();
    selectedFilter = filters[0];
  }

  List<Map<String, Object>> get filteredProducts {
    var filtered = products.where((product) {
      final matchesFilter =
          selectedFilter == 'All' || product['company'] == selectedFilter;
      final matchesSearch = product['title']
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();

    if (sortOption == 'Price Low to High') {
      filtered.sort(
          (a, b) => (a['price'] as double).compareTo(b['price'] as double));
    } else if (sortOption == 'Price High to Low') {
      filtered.sort(
          (a, b) => (b['price'] as double).compareTo(a['price'] as double));
    } else if (sortOption == 'Name A-Z') {
      filtered.sort(
          (a, b) => (a['title'] as String).compareTo(b['title'] as String));
    } else if (sortOption == 'Name Z-A') {
      filtered.sort(
          (a, b) => (b['title'] as String).compareTo(a['title'] as String));
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(225, 225, 225, 1),
      ),
      borderRadius: BorderRadius.horizontal(
        left: Radius.circular(50),
      ),
    );

    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Shoes\nCollection',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: DropdownButton<String>(
                  value: sortOption,
                  items: const [
                    DropdownMenuItem(
                        value: 'Name A-Z', child: Text('Name A-Z')),
                    DropdownMenuItem(
                        value: 'Name Z-A', child: Text('Name Z-A')),
                    DropdownMenuItem(
                        value: 'Price Low to High',
                        child: Text('Price Low to High')),
                    DropdownMenuItem(
                        value: 'Price High to Low',
                        child: Text('Price High to Low')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        sortOption = value;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              itemCount: filters.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final filter = filters[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                    child: Chip(
                      backgroundColor: selectedFilter == filter
                          ? Theme.of(context).colorScheme.primary
                          : const Color.fromRGBO(245, 247, 249, 1),
                      side: const BorderSide(
                        color: Color.fromRGBO(245, 247, 249, 1),
                      ),
                      label: Text(filter),
                      labelStyle: const TextStyle(fontSize: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(child: Text('No products found'))
                : LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 1080) {
                        return GridView.builder(
                          itemCount: filteredProducts.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.75,
                          ),
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductDetailsPage(product: product),
                                  ),
                                );
                              },
                              child: ProductCard(
                                title: product['title'] as String,
                                price: product['price'] as double,
                                image: product['imageUrl'] as String,
                                backgroundColor: index.isEven
                                    ? const Color.fromRGBO(216, 240, 253, 1)
                                    : const Color.fromRGBO(245, 247, 249, 1),
                                productId: product['id'] as String,
                              ),
                            );
                          },
                        );
                      } else {
                        return ListView.builder(
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductDetailsPage(product: product),
                                  ),
                                );
                              },
                              child: ProductCard(
                                title: product['title'] as String,
                                price: product['price'] as double,
                                image: product['imageUrl'] as String,
                                backgroundColor: index.isEven
                                    ? const Color.fromRGBO(216, 240, 253, 1)
                                    : const Color.fromRGBO(245, 247, 249, 1),
                                productId: product['id'] as String,
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
