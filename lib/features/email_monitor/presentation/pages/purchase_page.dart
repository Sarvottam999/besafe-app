import 'package:besafe/features/email_monitor/services/subscription_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PurchaseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final subscriptionService = Provider.of<SubscriptionService>(context);

    if (!subscriptionService.isAvailable) {
      return const Center(child: Text("Store not available"));
    }

    return ListView(
      children: subscriptionService.products.map((product) {
        return ListTile(
          title: Text(product.title),
          subtitle: Text(product.description),
          trailing: Text(product.price),
          onTap: () {
            subscriptionService.buy(product);
          },
        );
      }).toList(),
    );
  }
}
