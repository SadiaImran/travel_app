import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class BookNowScreen extends StatefulWidget {
  @override
  _BookNowScreenState createState() => _BookNowScreenState();
}

class _BookNowScreenState extends State<BookNowScreen> {
  final _formKey = GlobalKey<FormState>();
  final _database = FirebaseDatabase.instance.ref();

  String? _date;
  String? _location;
  int? _persons;

  void _bookNow() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Create a unique key for the booking
        String bookingId = _database.child('bookings').push().key!;

        // Add booking data to Firebase
        await _database.child('bookings/$bookingId').set({
          'date': _date,
          'location': _location,
          'persons': _persons,
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking successful!')),
        );

        // Reset form
        _formKey.currentState!.reset();
      } catch (error) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to book. Try again later.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Book Now',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Date input
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Date',
                          hintText: 'YYYY-MM-DD',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.datetime,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a date.';
                          }
                          return null;
                        },
                        onSaved: (value) => _date = value,
                      ),
                      SizedBox(height: 16),

                      // Location input
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Location',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a location.';
                          }
                          return null;
                        },
                        onSaved: (value) => _location = value,
                      ),
                      SizedBox(height: 16),

                      // Number of persons input
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Number of Persons',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the number of persons.';
                          }
                          if (int.tryParse(value) == null || int.parse(value) <= 0) {
                            return 'Please enter a valid number.';
                          }
                          return null;
                        },
                        onSaved: (value) => _persons = int.parse(value!),
                      ),
                      SizedBox(height: 24),

                      // Submit button
                      ElevatedButton(
                        onPressed: _bookNow,
                        child: Text('Book Now'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
