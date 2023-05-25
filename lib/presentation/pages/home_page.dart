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
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : costs.isEmpty
                ? const Text("There is no cost yet!")
                : Padding(
                    padding: const EdgeInsets.all(5),
                    // child: ListView.separated(
                    //   separatorBuilder: (_, index) => const SizedBox(height: 5),
                    //   itemCount: costs.length,
                    //   itemBuilder: (ctx, index) => _buildRow(costs[index], [
                    //     theme.colorScheme.primary,
                    //     theme.colorScheme.surface,
                    //     theme.colorScheme.secondary
                    //   ]),
                    // ),
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemCount: costs.length,
                        itemBuilder: (_, index) => _buildRow(costs[index], [
                          theme.colorScheme.surface.withOpacity(0.5),
                          theme.colorScheme.primary.withOpacity(1)
                          ,
                            ])),
                  ),
      ),
    );
  }

  Widget _buildRow(CostEntity cost, List<Color> colors) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shadowColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        side: BorderSide(color: Colors.blueGrey, width: 2),
      ),
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
      ),
    );
  }
}
