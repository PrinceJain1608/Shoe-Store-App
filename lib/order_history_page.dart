import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/order_provider.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final orders = orderProvider.orders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: orders.isEmpty
          ? const Center(child: Text('No orders yet'))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final items = order['items'] as List<dynamic>;
                return ExpansionTile(
                  title: Text('Order #${order['id']}'),
                  subtitle: Text(
                    'Total: \$${order['totalPrice'].toStringAsFixed(2)} | Date: ${DateTime.parse(order['date'] as String).toLocal().toString().substring(0, 16)}',
                  ),
                  children: items.map((item) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(item['imageUrl'] as String),
                        radius: 20,
                      ),
                      title: Text(item['title'] as String),
                      subtitle: Text(
                          'Size: ${item['size']} | Quantity: ${item['quantity']}'),
                      trailing: Text(
                          '\$${((item['price'] as double) * (item['quantity'] as int)).toStringAsFixed(2)}'),
                    );
                  }).toList(),
                );
              },
            ),
    );
  }
}
