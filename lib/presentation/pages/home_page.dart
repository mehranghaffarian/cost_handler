import 'package:cost_handler/core/session_database_helper.dart';
import 'package:cost_handler/domain/cost_entity.dart';
import 'package:cost_handler/presentation/pages/add_cost_page.dart';
import 'package:cost_handler/presentation/pages/add_user/add_user_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const routeName = "home_page";

  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isPressed = false;
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
    Color shadowColor = Colors.redAccent.shade700;
    Color backgroundColor = shadowColor.withOpacity(0.7);
    // Color shadowColor = Colors.blueAccent.shade700;
    // Color shadowColor = Colors.purpleAccent.shade700;

    return Scaffold(
      backgroundColor: const Color(0xFF00000F),
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
          child: Center(
            child: Listener(
              onPointerDown: (_) => setState(() {
                isPressed = true;
              }),
              onPointerUp: (_) => setState(() {
                isPressed = false;
              }),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 100),
                decoration: BoxDecoration(
                    color: isPressed ? backgroundColor : null,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      for (double i = 1; i < 5; i++)
                        BoxShadow(
                            spreadRadius: -1,
                            blurStyle: BlurStyle.outer,
                            color: Colors.white,
                            blurRadius: (isPressed ? 5 : 3) * i),
                      for (double i = 1; i < 5; i++)
                        BoxShadow(
                            spreadRadius: -1,
                            blurStyle: BlurStyle.outer,
                            color: shadowColor,
                            blurRadius: (isPressed ? 5 : 3) * i)
                    ]),
                child: TextButton(
                  onHover: (hovered) => setState(() {
                    this.isPressed = hovered;
                  }),
                  style: TextButton.styleFrom(
                    side: BorderSide(color: Colors.white, width: 4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {},
                  child: Text(
                    "neon button",
                    style: TextStyle(
                      color: Colors.white,
                      shadows: [
                        for (double i = 1; i < (isPressed ? 8 : 4); i++)
                          Shadow(color: shadowColor, blurRadius: i * 3),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),
      // child: ListView.builder(
      //   itemBuilder: (ctx, index) => _buildRow(costs[index]),
      // )),
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
