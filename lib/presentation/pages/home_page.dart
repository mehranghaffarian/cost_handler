import 'package:cost_handler/core/session_database_helper.dart';
import 'package:cost_handler/domain/cost_entity.dart';
import 'package:cost_handler/presentation/pages/add_cost_page.dart';
import 'package:cost_handler/presentation/pages/add_user/add_user_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const routeName = "home_page";

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<CostEntity> costs = [];

  @override
  void initState() {
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
        title: const Text("Home Page"),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AddCostPage.routeName),
            icon: const Icon(Icons.add_shopping_cart_outlined),
          ),
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AddUserPage.routeName),
            icon: const Icon(Icons.person_add_alt_1_sharp),
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            itemBuilder: (ctx, index) => _buildRow(costs[index]),
          )),
    );
  }

  Widget _buildRow(CostEntity cost) {
    return Card(
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("spender: ${cost.spenderUserName}"),
          const SizedBox(height: 10),
          Text("description: ${cost.description}"),
          const SizedBox(height: 10),
          Text("cost: ${cost.cost}"),
          const SizedBox(height: 10),
          Text("users: ${cost.receiverUsersNames.map((e) => "$e, ")}"),
        ],
      ),
    );
  }
}
