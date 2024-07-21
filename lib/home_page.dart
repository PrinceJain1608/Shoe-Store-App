import 'package:flutter/material.dart';
import 'package:shop_app/global_variables.dart';
import 'package:shop_app/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> filters = const ["All", "Adidas", "Nike", "Bata"];
  late String selectedFilter;
  @override
  void initState() {
    super.initState();
    selectedFilter = filters[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Shoes\nCollection",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                ),
              ),
              const Expanded(
                  child: TextField(
                      decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(255, 255, 247, 1)),
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(50))),
              ))),
            ],
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (context, index) {
                final filter = filters[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                    child: Chip(
                      backgroundColor: selectedFilter == filter
                          ? Colors.yellow
                          : Color.fromRGBO(245, 247, 249, 1),
                      side: BorderSide(color: Color.fromRGBO(245, 247, 249, 1)),
                      label: Text(filter),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      labelStyle: const TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  title: product["title"] as String,
                  price: product["price"] as double,
                  image: product["imageUrl"] as String,
                  backgroundcolor: index.isEven
                      ? const Color.fromRGBO(216, 240, 253, 1)
                      : const Color.fromRGBO(245, 247, 249, 1),
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}
