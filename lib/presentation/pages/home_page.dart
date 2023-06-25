import 'package:cost_handler/core/session_database_helper.dart';
import 'package:cost_handler/domain/cost_entity.dart';
import 'package:cost_handler/presentation/pages/add_cost_page.dart';
import 'package:cost_handler/presentation/pages/add_user/add_user_page.dart';
import 'package:cost_handler/presentation/pages/settle_up_page.dart';
import 'package:cost_handler/presentation/pages/settle_up_page.dart';
import 'package:cost_handler/presentation/pages/settle_up_page.dart';
import 'package:cost_handler/presentation/widgets/mg_report_card.dart';
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
                    child: Scrollbar(
                      thickness: 5.0,
                      interactive: true,
                      thumbVisibility: true,
                      trackVisibility: true,
                      radius: const Radius.circular(10),
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemCount: costs.length,
                        itemBuilder: (_, index) => _buildRow(
                          costs[index],
                          context,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildRow(CostEntity cost, BuildContext ctx) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconColor = colorScheme.onSurface;
    final textTheme = Theme.of(context).textTheme;

    return MGReportCard(reportInfoChildren: [
      Row(
        children: [
          Image.asset("assets/images/spender.png", width: 30, height: 30, color: iconColor,),
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
          Image.asset("assets/images/description.png", width: 30, height: 30, color: iconColor,),
          const SizedBox(width: 5),
          Flexible(
            // child: FittedBox(
            //   fit: BoxFit.scaleDown,
            child: Text(
              cost.description?.isEmpty ?? true
                  ? "No description"
                  : cost.description ?? "Unknown",
              style: textTheme.titleMedium,overflow: TextOverflow.visible,
              maxLines: 1,
            ),
          ),
          // ),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Image.asset("assets/images/price.png", width: 30, height: 30, color: iconColor,),
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
          Image.asset("assets/images/receiver.png", width: 30, height: 30, color: iconColor,),
          const SizedBox(width: 5),
          Text(
            cost.receiverUsersNames,
            style: textTheme.titleMedium,
          ),
        ],
      ),
    ]);
  }
}
