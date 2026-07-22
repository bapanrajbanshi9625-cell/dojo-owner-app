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
        // फोटो के हिसाब से हल्का नीला/हरा बैकग्राउंड
        scaffoldBackgroundColor: const Color(0xFFEAF4F4), 
      ),
      home: const MainDashboard(),
    );
  }
}

class MainDashboard extends StatefulWidget {
  const MainDashboard({Key? key}) : super(key: key);

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _selectedIndex = 0; // टैब बदलने के लिए
  bool isSubscribed = false; // सब्सक्रिप्शन स्टेटस

  // नीचे दिए गए टैब्स की लिस्ट
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // QR कोड जनरेट और सब्सक्रिप्शन चेक लॉजिक
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
          'To generate a QR code and access live walk tracking & history, please subscribe for ₹100/month.',
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
                const SnackBar(content: Text('Subscription Successful!')),
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
            Text('Ask your Walker to scan this QR code to begin.'),
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
    // तीनों स्क्रीन की लिस्ट
    final List<Widget> screens = [
      _buildHomeScreen(),
      _buildWalkHistoryScreen(),
      _buildAccountScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Dojo Walker',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'Welcome Back,\n[Owner Name]!',
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          )
        ],
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Walk History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  // 1. होम स्क्रीन (फोटो के अनुसार डिज़ाइन)
  Widget _buildHomeScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Live Walk Dashboard',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          // मैप का डमी डिज़ाइन
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  // यहाँ असल मैप आएगा, अभी के लिए एक रंग दिया है
                  image: NetworkImage('https://i.stack.imgur.com/HILmr.png'),
                  fit: BoxFit.cover,
                  opacity: 0.3,
                ),
                border: Border.all(color: Colors.teal.shade100, width: 2),
              ),
              child: const Center(
                child: Chip(
                  label: Text('Your Dog & Walker', style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.teal,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // स्टेट्स कार्ड्स (Duration, Susu, Potty)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard('Walk Duration', '00:00'),
              _buildStatCard('Susu', '0', icon: Icons.pets),
              _buildStatCard('Potty', '0', icon: Icons.delete_outline),
            ],
          ),
          const SizedBox(height: 24),
          // QR जनरेट बटन
          Center(
            child: SizedBox(
              width: double.infinity,
              height: 70,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                ),
                onPressed: _onGenerateQRCodeClicked,
                icon: const Icon(Icons.camera_alt, color: Colors.white, size: 30),
                label: const Text(
                  'GENERATE QR CODE\nFOR NEW WALK',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // छोटे स्टेट्स कार्ड बनाने का फंक्शन
  Widget _buildStatCard(String title, String value, {IconData? icon}) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
      ),
      child: Column(
        children: [
          if (icon != null) Icon(icon, size: 20, color: Colors.teal),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // 2. वॉक हिस्ट्री स्क्रीन (जहाँ पुराने वॉक दिखेंगे)
  Widget _buildWalkHistoryScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Walks',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildHistoryCard(
                  date: 'Today, 10:30 AM',
                  walkerId: 'W-9842 (Ravi Kumar)',
                  duration: '45 Mins',
                  destination: 'Local Park Route',
                  susu: 2,
                  potty: 1,
                ),
                _buildHistoryCard(
                  date: 'Yesterday, 05:00 PM',
                  walkerId: 'W-7123 (Suresh)',
                  duration: '30 Mins',
                  destination: 'Main Road Route',
                  susu: 1,
                  potty: 0,
                ),
                _buildHistoryCard(
                  date: '18 July, 09:15 AM',
                  walkerId: 'W-9842 (Ravi Kumar)',
                  duration: '50 Mins',
                  destination: 'Local Park Route',
                  susu: 3,
                  potty: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // हिस्ट्री कार्ड का डिज़ाइन
  Widget _buildHistoryCard({
    required String date,
    required String walkerId,
    required String duration,
    required String destination,
    required int susu,
    required int potty,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(date, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                Text(duration, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person_pin, color: Colors.black54, size: 20),
                const SizedBox(width: 8),
                Text('Walker ID: $walkerId', style: const TextStyle(fontSize: 15)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.black54, size: 20),
                const SizedBox(width: 8),
                Text('Route: $destination', style: const TextStyle(fontSize: 15)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Susu: $susu', style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold)),
                Text('Potty: $potty', style: const TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }

  // 3. अकाउंट स्क्रीन
  Widget _buildAccountScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.account_circle, size: 100, color: Colors.teal),
          const SizedBox(height: 16),
          const Text('Owner Account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            isSubscribed ? 'Status: Active Subscriber (₹100/m)' : 'Status: Free Plan (Not Subscribed)',
            style: TextStyle(fontSize: 16, color: isSubscribed ? Colors.green : Colors.red),
          ),
        ],
      ),
    );
  }
}
