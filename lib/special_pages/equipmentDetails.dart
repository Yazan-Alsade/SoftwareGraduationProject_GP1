import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'const.dart';

class MaterialDetailsDialog extends StatefulWidget {
  final dynamic material;

  const MaterialDetailsDialog({Key? key, required this.material})
      : super(key: key);

  @override
  _MaterialDetailsDialogState createState() => _MaterialDetailsDialogState();
}

class _MaterialDetailsDialogState extends State<MaterialDetailsDialog> {
  final _formKey = GlobalKey<FormState>();
  int _rating = 3;
  String _comment = '';
  dynamic _review;

  @override
  void initState() {
    super.initState(); // Fetch the review when the dialog is initialized
    loadSavedReview(); // Load the saved review from shared preferences
  }
Future<void> clearReview() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('rating');
  await prefs.remove('comment');
}

  Future<void> loadSavedReview() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedRating = prefs.getInt('rating');
    final savedComment = prefs.getString('comment');
    if (savedRating != null && savedComment != null) {
      setState(() {
        _rating = savedRating;
        _comment = savedComment;
      });
    }
  }

  Future<void> saveReview() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('rating', _rating);
    await prefs.setString('comment', _comment);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.material['name']),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.material['description']),
          Text('Price: \$${widget.material['price']}'),
          Text('Unit: ${widget.material['unit']}'),
          SizedBox(height: 20),
          Text('Leave a review:'),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    RatingBar.builder(
                      initialRating: _rating.toDouble(),
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 25,
                      itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          _rating = rating.toInt();
                        });
                      },
                    ),
                    SizedBox(width: 10),
                    Text('$_rating star(s)'),
                  ],
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Write a review...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a comment';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _comment = value;
                    });
                    saveReview();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        TextButton(
        onPressed: () async {
  if (_formKey.currentState!.validate()) {
    final userId = '645a4760d03ec8ca68a8ed25'; // Replace with actual user ID

    // Store new review
    final response = await http.post(
      Uri.parse(
        '$apiBaseUrl:3000/Materials/${widget.material['_id']}/reviews'),
      body: json.encode({
        'userId': userId,
        'rating': _rating,
        'comment': _comment,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      final newReview = json.decode(response.body);
      setState(() {
        _review = newReview;
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Review submitted'),
          duration: Duration(seconds: 2),
        ),
      );
      clearReview(); // Clear the saved review from shared preferences
    }
  }
},

          child: Text(_review != null ? 'Update' : 'Submit'),
        )
      ],
    );
  }
}
