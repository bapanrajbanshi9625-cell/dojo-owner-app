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
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFFEAF4F4),
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
  int _selectedIndex = 0;
  bool isSubscribed = true;
  
  // डायनेमिक ओनर और लाइव वॉक डेटा
  String ownerName = "Bapan";
  String walkDuration = "24:15";
  int susuCount = 1;
  int pottyCount = 2;
  String activeWalker = "W-9842 (Ravi Kumar)";
  String activeRoute = "Lake View Garden";

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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

  void _showNotificationsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: const Text('Walker W-9842 started the walk.\nMonthly subscription active (₹100/m).'),
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
    final List<Widget> screens = [
      _buildHomeScreen(),
      const WalkHistoryScreen(),
      AccountScreen(isSubscribed: isSubscribed, ownerName: ownerName),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Dojo Walker',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active, color: Colors.teal),
            onPressed: _showNotificationsDialog,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Center(
              child: Text(
                'Welcome Back,\n$ownerName!',
                textAlign: TextAlign.right,
                style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
          ),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Walk History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }

  // होम स्क्रीन UI
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
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: NetworkImage('https://i.stack.imgur.com/HlImr.png'),
                  fit: BoxFit.cover,
                  opacity: 0.3,
                ),
                border: Border.all(color: Colors.teal.shade100, width: 2),
              ),
              child: Center(
                child: Chip(
                  label: Text('Walker: $activeWalker', style: const TextStyle(color: Colors.white)),
                  backgroundColor: Colors.teal,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard('Walk Duration', walkDuration),
              _buildStatCard('Susu', '$susuCount', icon: Icons.pets),
              _buildStatCard('Potty', '$pottyCount', icon: Icons.delete_outline),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange.shade400,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                ),
                onPressed: _onGenerateQRCodeClicked,
                icon: const Icon(Icons.camera_alt, color: Colors.white, size: 30),
                label: const Text(
                  'GENERATE QR CODE FOR NEW WALK',
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
}

class WalkHistoryScreen extends StatelessWidget {
  const WalkHistoryScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> walkList = const [
    {
      'date': 'Today, 10:30 AM',
      'walkerId': 'W-9842 (Ravi Kumar)',
      'duration': '45 Mins',
      'destination': 'Local Park Route',
      'susu': 2,
      'potty': 1,
    },
    {
      'date': 'Yesterday, 05:00 PM',
      'walkerId': 'W-7123 (Suresh)',
      'duration': '30 Mins',
      'destination': 'Main Road Route',
      'susu': 1,
      'potty': 0,
    },
    {
      'date': '18 July, 09:15 AM',
      'walkerId': 'W-9842 (Ravi Kumar)',
      'duration': '50 Mins',
      'destination': 'Lake View Garden',
      'susu': 3,
      'potty': 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Walks (Tap to view details)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: walkList.length,
              itemBuilder: (context, index) {
                final walk = walkList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WalkDetailScreen(walkData: walk),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(walk['date'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                              Text(walk['duration'], style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const Divider(),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.person_pin, color: Colors.black54, size: 20),
                              const SizedBox(width: 8),
                              Text('Walker ID: ${walk['walkerId']}', style: const TextStyle(fontSize: 15)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.black54, size: 20),
                              const SizedBox(width: 8),
                              Text('Route: ${walk['destination']}', style: const TextStyle(fontSize: 15)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WalkDetailScreen extends StatelessWidget {
  final Map<String, dynamic> walkData;
  const WalkDetailScreen({Key? key, required this.walkData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Walk Detail & Map Route'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: NetworkImage('https://i.stack.imgur.com/HlImr.png'),
                  fit: BoxFit.cover,
                  opacity: 0.4,
                ),
                border: Border.all(color: Colors.teal, width: 2),
              ),
              child: const Center(
                child: Chip(
                  label: Text('Walk Route Map Line', style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.teal,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Date & Time: ${walkData['date']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Walker ID: ${walkData['walkerId']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Destination / Route: ${walkData['destination']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Total Duration: ${walkData['duration']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 15),
            Row(
              children: [
                Chip(label: Text('Susu Count: ${walkData['susu']}'), backgroundColor: Colors.orange.shade100),
                const SizedBox(width: 10),
                Chip(label: Text('Potty Count: ${walkData['potty']}'), backgroundColor: Colors.brown.shade100),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AccountScreen extends StatelessWidget {
  final bool isSubscribed;
  final String ownerName;
  const AccountScreen({Key? key, required this.isSubscribed, required this.ownerName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: CircleAvatar(radius: 40, backgroundColor: Colors.teal, child: Icon(Icons.person, size: 50, color: Colors.white)),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(ownerName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 5),
          const Center(
            child: Text('Member since: 2022-04-12', style: TextStyle(fontSize: 13, color: Colors.black54)),
          ),
          const SizedBox(height: 15),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: const Text('Subscription Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: Text(
                isSubscribed ? 'Active Subscriber\nPlan: ₹100/month' : 'Free Plan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isSubscribed ? Colors.green : Colors.red),
              ),
              trailing: Icon(isSubscribed ? Icons.check_circle : Icons.warning, color: isSubscribed ? Colors.green : Colors.red),
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            tileColor: Colors.white,
            leading: const Icon(Icons.payment, color: Colors.teal),
            title: const Text('Payment Methods'),
            subtitle: const Text('UPI / Credit Card / Wallet'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Payment Methods'),
                  content: const Text('Linked UPI: user@paytm\n\nWould you like to add a new method?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                    ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('+ Add New')),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            tileColor: Colors.white,
            leading: const Icon(Icons.notifications, color: Colors.teal),
            title: const Text('Notifications'),
            subtitle: const Text('Manage walk alerts'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Notifications Settings'),
                  content: const Text('Walk Alerts: ON\nSubscription Reminders: ON\nPromotional Offers: OFF'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            tileColor: Colors.white,
            leading: const Icon(Icons.support_agent, color: Colors.teal),
            title: const Text('Contact Support'),
            subtitle: const Text('Get help regarding walks or subscription'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Contact Support'),
                  content: const Text('Helpline: +91 98765 43210\nEmail: support@dojowalker.com'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
