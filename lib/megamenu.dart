import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:m_tap/profile.dart';

class Megamenu extends StatefulWidget {
  const Megamenu({super.key});

  @override
  State<Megamenu> createState() => _MegamenuState();
}

class Item {
  final String description;
  final double price;

  Item(this.description, this.price);
}

class _MegamenuState extends State<Megamenu> {
  final List<Map<String, dynamic>> menuItems = [
    {'title': 'UPI', 'icon': Icons.account_balance_wallet},
    {'title': 'QR Code', 'icon': Icons.qr_code},
    {'title': 'Card', 'icon': Icons.credit_card},
    {'title': 'NFC', 'icon': Icons.nfc},
    {'title': 'Generate Bill', 'icon': Icons.receipt},
    {'title': 'History', 'icon': Icons.history},
  ];

  void _onMenuItemTap(String title) {
    print("$title selected");
    if (title == 'Generate Bill') {
      List<Item> items = [
        Item('Item 1 - Widget A', 10.00),
        Item('Item 2 - Widget B', 15.50),
        Item('Item 3 - Service Fee', 20.00),
        Item('Item 4 - Custom Part C', 7.25),
        Item('Item 5 - Extra Service D', 12.75),
      ];
      generateBill(items);
    }
    // Here you could navigate to another screen or perform an action.
  }

  void _onDrawerItemTap(String title) async {
    Navigator.pop(context); // Close the drawer

    if (title == 'Logout') {
      try {
        await FirebaseAuth.instance.signOut();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Something went wrong. Please try again'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else if (title == 'Profile') {
      print('Profile');
      Navigator.pushNamed(context, 'Profile');
    } else if (title == 'Settings') {
      // Add any settings action here if needed
    }

  }


  Future<void> generateBill(List<Item> items) async {
    final pdf = pw.Document();
    final double total = items.fold(0, (sum, item) => sum + item.price);

    // Load the logo image
    //final ByteData bytes = await rootBundle.load('assets/logo.png');
    //final Uint8List imageData = bytes.buffer.asUint8List();
    //final pw.MemoryImage logoImage = pw.MemoryImage(imageData);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Company Logo
             // pw.Image(logoImage, width: 100, height: 100),
              pw.SizedBox(height: 10),
              // Company Information
              pw.Text('Your Company Name', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Text('123 Business Rd.', style: pw.TextStyle(fontSize: 14)),
              pw.Text('City, State, ZIP', style: pw.TextStyle(fontSize: 14)),
              pw.Text('Phone: (123) 456-7890', style: pw.TextStyle(fontSize: 14)),
              pw.Text('Email: info@yourcompany.com', style: pw.TextStyle(fontSize: 14)),
              pw.Text('Website: www.yourcompany.com', style: pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 20),
              // Invoice Title
              pw.Text('INVOICE', style: pw.TextStyle(fontSize: 36, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              // Invoice Date
              pw.Text('Date: ${DateTime.now().toLocal()}', style: pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 10),
              // Items Section
              pw.Text('Items:', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              for (int i = 0; i < items.length; i++)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('${i + 1}. ${items[i].description}', style: pw.TextStyle(fontSize: 14)),
                    pw.Text(' ${items[i].price.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 14)),
                  ],
                ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('2. Another Item', style: pw.TextStyle(fontSize: 14)),
                  pw.Text('20.00', style: pw.TextStyle(fontSize: 14)),
                ],
              ),
              pw.Divider(),
              pw.SizedBox(height: 10),
              // Total Section
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Total:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Rs. '+total.toStringAsFixed(2), style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 20),
              // Footer
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Text('Thank you for your business!', style: pw.TextStyle(fontSize: 14, fontStyle: pw.FontStyle.italic)),
              pw.Text('Payment is due within 30 days.', style: pw.TextStyle(fontSize: 14, fontStyle: pw.FontStyle.italic)),
            ],
          ); // Column
        },
      ),
    );

    // Show the document in a preview
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mega Menu', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
      ),
      backgroundColor: Colors.blue[900],
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: SizedBox(
                height: 20, // Adjust height as needed
                child: Center(
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.black),
              title: Text('Profile', style: TextStyle(color: Colors.black)),
              onTap: () => _onDrawerItemTap('Profile'),
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.black),
              title: Text('Settings', style: TextStyle(color: Colors.black)),
              onTap: () => _onDrawerItemTap('Settings'),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.black),
              title: Text('Logout', style: TextStyle(color: Colors.black)),
              onTap: () => _onDrawerItemTap('Logout'),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 items per row
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
          ),
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            final item = menuItems[index];
            return GestureDetector(
              onTap: () => _onMenuItemTap(item['title']),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[800],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item['icon'], color: Colors.white, size: 40),
                    SizedBox(height: 10),
                    Text(
                      item['title'],
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
