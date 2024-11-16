import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerAddressController = TextEditingController();
  final TextEditingController _customerPhoneController = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _shopAddressController = TextEditingController();
  final TextEditingController _shopPhoneController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Add parentheses to call the method
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerAddressController.dispose();
    _customerPhoneController.dispose();
    _shopNameController.dispose();
    _shopAddressController.dispose();
    _shopPhoneController.dispose();
    super.dispose();
  }

void _updateProfile() async
{
  User? currentUser = _auth.currentUser;
  if (currentUser == null) return;

  String uid = currentUser.uid;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Map<String, dynamic> updatedData = {
    "customerName": _customerNameController.text,
    "customerAddress": _customerAddressController.text,
    "customerPhone": _customerPhoneController.text,
    "shopName": _shopNameController.text,
    "shopAddress": _shopAddressController.text,
    "shopPhone": _shopPhoneController.text,
    "updatedAt": FieldValue.serverTimestamp(),
  };
  try {
    // Use the user ID as the document ID (or use a specific ID if available)
    await _firestore.collection('users').doc(uid).set(
        updatedData, SetOptions(merge: true));

    // Optionally, show a success message in the UI
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  } catch (e) {
    print("Failed to update profile: $e");

    // Optionally, show an error message in the UI
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to update profile: $e')),
    );
  }
}
// Fetch user data from Firestore
    Future<void> _loadUserData() async {
      try {
        // Get the current user's uid
        User? currentUser = _auth.currentUser;
        if (currentUser == null) return;

        String uid = currentUser.uid;

        // Get user document from Firestore
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('userId', isEqualTo: uid)
            .get();

        // Check if the document exists
        if (querySnapshot.docs.isNotEmpty) {
          // Get the first document (assuming userId is unique)
          DocumentSnapshot userDoc = querySnapshot.docs.first;
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

          // Populate text controllers with data
          _customerNameController.text = userData['customerName'] ?? '';
          _customerAddressController.text = userData['customerAddress'] ?? '';
          _customerPhoneController.text = userData['customerPhone'] ?? '';
          _shopNameController.text = userData['shopName'] ?? '';
          _shopAddressController.text = userData['shopAddress'] ?? '';
          _shopPhoneController.text = userData['shopPhone'] ?? '';
        }
      } catch (e) {
        print('Failed to load user data: $e');
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile'), titleTextStyle: TextStyle(color: Colors.white),
        backgroundColor: Colors.blue[800]),
      backgroundColor: Colors.blue[900],

      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration:  BoxDecoration(
            color: Colors.white, // Set the form background color to white
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // Shadow position
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true, // Allow the ListView to take minimum space
              children: [
                Text('Customer Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                TextFormField(
                  controller: _customerNameController,
                  decoration: InputDecoration(labelText: 'Customer Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter customer name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _customerAddressController,
                  decoration: InputDecoration(labelText: 'Customer Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter customer address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _customerPhoneController,
                  decoration: InputDecoration(labelText: 'Customer Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter customer phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                Text('Shop Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                TextFormField(
                  controller: _shopNameController,
                  decoration: InputDecoration(labelText: 'Shop Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter shop name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _shopAddressController,
                  decoration: InputDecoration(labelText: 'Shop Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter shop address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _shopPhoneController,
                  decoration: InputDecoration(labelText: 'Shop Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter shop phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _updateProfile();
                    }

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900], // Set the background color to blue
                    foregroundColor: Colors.white,// Set the text color to white
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Adjust padding as needed
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Rounded corners for the button
                    ),
                  ),
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
