import 'package:flutter/material.dart';

void main() {
  runApp(const DojoOwnerApp());
}

class DojoOwnerApp extends StatelessWidget {
  const DojoOwnerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dojo Owner App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: const Color(0xFFF2F8F9),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSubscribed = false;

  void _onGenerateQRCodeClicked() {
    if (!isSubscribed) {
      _showSubscriptionDialog();
    } else {
      _showQRCodeScreen();
    }
  }

  void _showSubscriptionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Subscription Required'),
        content: const Text(
          'To generate a QR code and access live walk tracking, please subscribe for ₹100/month.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                isSubscribed = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Subscription Successful! Now you can generate QR.')),
              );
            },
            child: const Text('Pay ₹100 & Subscribe'),
          ),
        ],
      ),
    );
  }

  void _showQRCodeScreen() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Scan to Start Walk'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.qr_code_2, size: 150, color: Colors.black87),
            SizedBox(height: 10),
            Text('Ask your Walker to scan this QR code to begin the session.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Dojo Walker',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Welcome, Owner!',
                style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Live Walk Dashboard',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.teal.shade100),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map, size: 50, color: Colors.teal),
                    SizedBox(height: 8),
                    Text(
                      'Live Tracking Map\n(Will activate once walker scans QR)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _onGenerateQRCodeClicked,
                  icon: const Icon(Icons.qr_code, color: Colors.white, size: 28),
                  label: const Text(
                    'GENERATE QR CODE FOR NEW WALK',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
