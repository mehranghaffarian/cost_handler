import 'package:cost_handler/core/session_database_helper.dart';
import 'package:cost_handler/domain/cost_entity.dart';
import 'package:cost_handler/presentation/pages/add_cost_page.dart';
import 'package:cost_handler/presentation/pages/add_user/add_user_page.dart';
import 'package:cost_handler/presentation/pages/settle_up_page.dart';
import 'package:cost_handler/presentation/pages/settle_up_page.dart';
import 'package:cost_handler/presentation/pages/settle_up_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const routeName = "home_page";

  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CostEntity> costs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () => _getCosts(),
    );
  }

  _getCosts() {
    SessionDatabaseHelper.instance.queryAllRows().then((value) {
      costs = value;
      isLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          IconButton(
            onPressed: () async {
              final res =
                  await Navigator.of(context).pushNamed(AddCostPage.routeName);
              isLoading = true;
              if (res == true) {
                _getCosts();
              }
            },
            icon: const Icon(Icons.add_shopping_cart_outlined,
                color: Colors.black),
          ),
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AddUserPage.routeName),
            icon: const Icon(
              Icons.person_add_alt_1_sharp,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(SettleUpPage.routeName),
            icon: const Icon(
              Icons.account_balance_wallet_sharp,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : costs.isEmpty
                ? const Text("There is no cost yet!")
                : ListView.builder(
                    itemCount: costs.length,
                    itemBuilder: (ctx, index) => _buildRow(costs[index]),
                  ),
      ),
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
          Text("users: ${cost.receiverUsersNames}"),
        ],
      ),
    );
  }
}
