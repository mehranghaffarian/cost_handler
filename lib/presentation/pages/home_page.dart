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
                    child: GridView.builder(shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemCount: costs.length,
                      itemBuilder: (_, index) => _buildRow(
                        costs[index],
                        context,
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildRow(CostEntity cost, BuildContext ctx) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return
        Card(
        clipBehavior: Clip.antiAlias,
        shadowColor: Colors.black,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          side: BorderSide(color: Colors.blueGrey, width: 2),
        ),
        elevation: 20,
        child:
        Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            colors: [
              colorScheme.secondary.withOpacity(0.2),
              colorScheme.primary.withOpacity(1),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 20,
              spreadRadius: 10,
            ),
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_box_outlined,
                size: 30,
                color: colorScheme.onSurface,
                shadows: [Shadow(color: colorScheme.shadow, blurRadius: 5.0)],
              ),
              const SizedBox(width: 5),
              Text(
                cost.spenderUserName,
                style: textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 30,
                color: colorScheme.onSurface,
                shadows: [
                  Shadow(color: colorScheme.shadow, blurRadius: 5.0),
                ],
              ),
              const SizedBox(width: 5),
              Flexible(
                // child: FittedBox(
                //   fit: BoxFit.scaleDown,
                  child:
                  Text(
                    cost.description?.length == 0 ? "temp" : cost.description ?? "Unknown",
                    style: textTheme.titleMedium,
                    maxLines: 1,
                  ),
                ),
              // ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.monetization_on_outlined,
                size: 30,
                color: colorScheme.onSurface,
                shadows: [
                  Shadow(color: colorScheme.shadow, blurRadius: 5.0),
                ],
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  cost.cost.toStringAsFixed(2),
                  style: textTheme.titleMedium,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.supervised_user_circle_sharp,
                size: 30,
                color: colorScheme.onSurface,
                shadows: [
                  Shadow(color: colorScheme.shadow, blurRadius: 5.0),
                ],
              ),
              const SizedBox(width: 5),
              Text(
                cost.receiverUsersNames,
                style: textTheme.titleMedium,
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }
}
