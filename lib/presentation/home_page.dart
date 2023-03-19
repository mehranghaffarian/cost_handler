import 'package:cost_handler/core/session_database_helper.dart';
import 'package:cost_handler/domain/cost_entity.dart';
import 'package:cost_handler/presentation/add_cost_page.dart';
import 'package:cost_handler/presentation/add_user_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const routeName = "home_page";

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final List<CostEntity> costs;

  @override
  void initState() {
    costs = [];
    setState(() {
      SessionDatabaseHelper.instance
          .queryAllRows()
          .then((value) => costs.addAll(value));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushReplacementNamed(AddCostPage.routeName),
            icon: Icon(Icons.add_shopping_cart_outlined),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pushReplacementNamed(AddUserPage.routeName),
            icon: Icon(Icons.add_reaction_outlined),
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            itemBuilder: (ctx, index) => _buildRow(index),
          )),
    );
  }

  Widget _buildRow(int index) {
    return SizedBox();
  }
}
