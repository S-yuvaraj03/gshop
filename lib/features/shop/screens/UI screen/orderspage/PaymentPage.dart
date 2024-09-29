import 'package:flutter/material.dart';
import 'package:gshop/features/shop/model/PaymentModel.dart';
import 'package:gshop/utils/constant/sizes.dart';
import 'package:quickalert/quickalert.dart';
import 'package:gshop/features/shop/screens/UI%20screen/orderspage/cart_bloc/cart_bloc.dart';
import 'ConfirmationOfOrderPage.dart';

class PaymentPage extends StatefulWidget {
  final double totalAmount;
  final List<CartSelectedItem> cartItems;
  final String deliveryAddress; // Add delivery address

  PaymentPage({
    required this.totalAmount,
    required this.cartItems,
    required this.deliveryAddress, // Initialize delivery address
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

List<Payment> paymentHistory = [];

  void storePayment(Payment payment) {
    paymentHistory.add(payment);
  }

class _PaymentPageState extends State<PaymentPage> {
  String? selectedPaymentMethod;
  bool isProcessingPayment = false;

  @override
  Widget build(BuildContext context) {
    double kheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order', style: TextStyle(fontSize: TSizes.fontLg)),
                Text('₹${widget.totalAmount}', style: TextStyle(fontSize: TSizes.fontLg)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: TextStyle(fontSize: TSizes.fontLg, fontWeight: FontWeight.bold)),
                Text('₹${widget.totalAmount}', style: TextStyle(fontSize: TSizes.fontLg, fontWeight: FontWeight.bold)),
              ],
            ),
            Divider(thickness: 1, height: kheight*0.032),
            Text('Payment', style: TextStyle(fontSize: TSizes.Lg, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            buildPaymentMethodOption('VISA', 'assets/images/visa.png', '************2109'),
            buildPaymentMethodOption('PayPal', 'assets/images/paypal.png', '************XXXX'),
            buildPaymentMethodOption('MasterCard', 'assets/images/mastercard.png', '************XXXX'),
            buildPaymentMethodOption('Google Pay', 'assets/images/gpay.png', 'UPI id:XXX XXX@axl'),
            SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: selectedPaymentMethod == null
    ? null
    : () async {
        setState(() {
          isProcessingPayment = true;
        });

        QuickAlert.show(
          context: context,
          type: QuickAlertType.loading,
          title: 'Loading',
          text: 'Fetching your data',
          barrierDismissible: false,
        );

        // Simulate payment processing
        await Future.delayed(Duration(seconds: 5));

        // Simulate a random outcome for demonstration purposes
        bool paymentSuccessResult = DateTime.now().second % 2 == 0;

        Navigator.of(context).pop(); // Dismiss the loading alert

        // Store the payment result
                  storePayment(Payment(
                    amount: widget.totalAmount,
                    method: selectedPaymentMethod!,
                    status: paymentSuccessResult ? "success" : "failed",
                    date: DateTime.now(),
                  ));

                  if (paymentSuccessResult) {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      text: 'Transaction Completed Successfully!',
                      autoCloseDuration: const Duration(seconds: 2),
                      showConfirmBtn: false,
                      disableBackBtn: true,
                      widget: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Icon(Icons.thumb_up, size: 32,),
                      )
                    );
                    await Future.delayed(Duration(seconds: 2));
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConfirmationOfOrderPage(
                          totalAmount: widget.totalAmount,
                          cartItems: widget.cartItems,
                          deliveryAddress: widget.deliveryAddress, // Pass delivery address
                        ),
                      ),
                    );
                  } else {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      title: 'Oops...',
                      text: 'Sorry, something went wrong',
                      backgroundColor: Colors.black,
                      titleColor: Colors.white,
                      textColor: Colors.white,
                      disableBackBtn: true,
                      confirmBtnText: "Okay"
                    );
                  }

                  setState(() {
                    isProcessingPayment = false;
                  });
                },

              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentMethodOption(String method, String logo, String cardNumber) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = method;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: selectedPaymentMethod == method ? Colors.red : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Image.asset(logo, width: 32, height: 32),
            SizedBox(width: 16),
            Expanded(
              child: Text(method, style: TextStyle(fontSize: 16)),
            ),
            Text(cardNumber, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
