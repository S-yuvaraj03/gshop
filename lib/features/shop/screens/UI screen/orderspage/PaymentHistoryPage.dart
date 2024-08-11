import 'package:flutter/material.dart';
import 'package:gshop/features/shop/model/PaymentModel.dart';

class PaymentHistoryPage extends StatelessWidget {
  final List<Payment> paymentHistory;

  PaymentHistoryPage({required this.paymentHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment History'),
      ),
      body: ListView.builder(
        itemCount: paymentHistory.length,
        itemBuilder: (context, index) {
          final payment = paymentHistory[index];
          return ListTile(
            leading: payment.status == "success"
                ? Icon(Icons.check_circle, color: Colors.green)
                : Icon(Icons.error, color: Colors.red),
            title: Text('${payment.method} - ₹${payment.amount}'),
            subtitle: Text('${payment.date}'),
            trailing: Text(payment.status),
          );
        },
      ),
    );
  }
}
