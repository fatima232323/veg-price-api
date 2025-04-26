/*import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("Fatima AND Mahnooray12"),
            // Replace with actual user name
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage(
                  "assets/images/profile.jpg"), // Use an actual image
            ),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 159, 79, 167),
            ),
            accountEmail: null,
          ),
          _buildDrawerItem(Icons.monetization_on, "Earn with Us", context),
          _buildDrawerItem(Icons.person, "Profile", context),
          _buildDrawerItem(Icons.settings, "Settings", context),
          _buildDrawerItem(Icons.history, "Order History", context),
          _buildDrawerItem(Icons.star, "Ratings & Reviews", context),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Color.fromARGB(255, 159, 79, 167)),
      title: Text(title, style: TextStyle(fontSize: 16)),
      onTap: () {
        Navigator.pop(context); // Close the drawer
        // TODO: Navigate to the respective screen
      },
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:servicehub/worker/workerwelcome.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("Fatima AND Mahnooray12"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage("assets/images/profile.jpg"),
            ),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 159, 79, 167),
            ),
            accountEmail: null,
          ),
          _buildDrawerItem(Icons.monetization_on, "Earn with Us", context,
              WorkerScreenApp()),
          _buildDrawerItem(Icons.person, "Profile", context, null),
          _buildDrawerItem(Icons.settings, "Settings", context, null),
          _buildDrawerItem(Icons.history, "Order History", context, null),
          _buildDrawerItem(Icons.star, "Ratings & Reviews", context, null),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      IconData icon, String title, BuildContext context, Widget? screen) {
    return ListTile(
      leading: Icon(icon, color: Color.fromARGB(255, 159, 79, 167)),
      title: Text(title, style: TextStyle(fontSize: 16)),
      onTap: () {
        Navigator.pop(context); // Close the drawer
        if (screen != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => screen));
        }
      },
    );
  }
}
