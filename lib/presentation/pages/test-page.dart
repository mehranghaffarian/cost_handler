import 'package:cost_handler/presentation/pages/add_cost_page.dart';
import 'package:cost_handler/presentation/pages/add_user/add_user_page.dart';
import 'package:cost_handler/presentation/pages/home_page.dart';
import 'package:cost_handler/presentation/pages/settle_up_page.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class TestPage extends StatefulWidget {
  static const routeName = "test_page";
  @override
  TestPageState createState() => TestPageState();
}

class TestPageState extends State<TestPage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    AddCostPage(),
    AddUserPage(),
    SettleUpPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.grey[100],//todo: cool usage of colors
      body: SafeArea(//todo what is safe area
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colorScheme.primary,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: colorScheme.secondary.withOpacity(0.5),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: colorScheme.onSurface,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: colorScheme.onBackground,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 1000),
              tabBackgroundColor: colorScheme.background,//Colors.grey[100]!,
              color: colorScheme.background,
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.add_shopping_cart_outlined,
                  text: 'Add cost',
                ),
                GButton(
                  icon: Icons.person_add_alt_1_sharp,
                  text: 'Add user',
                ),
                GButton(
                  icon: Icons.account_balance_wallet_sharp,
                  text: 'Settle up',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}