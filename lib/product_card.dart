import "package:flutter/material.dart";

class ProductCard extends StatelessWidget {
  final String title;
  final double price;
  final String image;
  final Color backgroundcolor;
  const ProductCard(
      {super.key,
      required this.title,
      required this.price,
      required this.image,
      required this.backgroundcolor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: backgroundcolor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            "\$$price",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(
            height: 6,
          ),
          Center(
            child: Image(
              image: AssetImage(image),
              height: 175,
            ),
          )
        ],
      ),
    );
  }
}
