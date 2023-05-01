import 'dart:async';

import 'package:cabshare/JourneyReview.dart';
import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final double amount;

  PaymentPage({required this.amount});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isCashSelected = true;
  bool _isTabSelected = false;

  double _tabAmount = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Amount: \₹${widget.amount}',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Select Payment Method:',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Cash',
                  style: TextStyle(fontSize: 18.0),
                ),
                Radio(
                  value: true,
                  groupValue: _isCashSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      _isCashSelected = value!;
                      _isTabSelected = !_isCashSelected;
                    });
                  },
                ),
                SizedBox(width: 40.0),
                Text(
                  'Tab',
                  style: TextStyle(fontSize: 18.0),
                ),
                Radio(
                  value: true,
                  groupValue: _isTabSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      _isTabSelected = value!;
                      _isCashSelected = !_isTabSelected;
                    });
                  },
                ),
              ],
            ),
            _isTabSelected
                ? Column(
                    children: [
                      SizedBox(height: 20.0),
                      Text(
                        'Enter Tab Amount:',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      SizedBox(height: 20.0),
                      SizedBox(
                        width: 200.0,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Amount',
                          ),
                          onChanged: (value) {
                            setState(() {
                              _tabAmount = double.parse(value);
                            });
                          },
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Simulate payment process
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text('Processing Payment...'),
                    );
                  },
                );

                // Wait for 3 seconds
                Future.delayed(Duration(seconds: 3), () {
                  // Navigate to success page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          PaymentSuccessPage(amountPaid: widget.amount,isTab: _isTabSelected),
                    ),
                  );
                });
              },
              child: Text('Pay'),
            ),
            SizedBox(height: 20.0),
            _isTabSelected
                ? Text(
                    'Pending Tab: \₹${widget.amount - _tabAmount}',
                    style: TextStyle(fontSize: 18.0),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}



class PaymentSuccessPage extends StatefulWidget {
  final double amountPaid;
  final bool isTab;

  PaymentSuccessPage({
    required this.amountPaid,
    required this.isTab,
  });

  @override
  _PaymentSuccessPageState createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> {
  int _countdown = 3;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        timer.cancel();
        Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ReviewForm(driverId: "hhhhh",userId: "0000")),
    );
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent the user from going back
        return false;
      },
      child:Scaffold(
      appBar: AppBar(
        title: Text('Payment Success'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Payment Successful!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              'Amount Paid: \₹${widget.amountPaid.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              widget.isTab ? 'Amount added to your tab.' : 'Cash payment received.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 32),
            Text(
              'Redirecting to review in $_countdown seconds...',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    ));
  }
}