import 'package:flutter/material.dart';
import 'UserDashboard.dart';
class ReviewForm extends StatefulWidget {
  final String driverId;
  final String userId;
  

  ReviewForm({required this.driverId, required this.userId});

  @override
  _ReviewFormState createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final _formKey = GlobalKey<FormState>();
  String _reviewText = '';
  int _rating = 0;
  bool redirect= false;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Do something with the review text and rating, such as submit to a database
      print("Review Recorded");
      setState(() {
        redirect=true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if(redirect){
      return DashboardPage();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Review'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Driver ID: ${widget.driverId}'),
              Text('User ID: ${widget.userId}'),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Review Text',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a review';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _reviewText = value;
                  });
                },
              ),
              Row(
                children: [
                  Text('Rating: '),
                  Expanded(
                    child: Slider(
                      value: _rating.toDouble(),
                      min: 0,
                      max: 5,
                      divisions: 5,
                      label: _rating.toString(),
                      onChanged: (value) {
                        setState(() {
                          _rating = value.round();
                        });
                      },
                    ),
                  ),
                  Text(_rating.toString()),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}