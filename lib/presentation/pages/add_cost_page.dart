import 'package:cost_handler/core/extensions/show_snack.dart';
import 'package:cost_handler/core/session_database_helper.dart';
import 'package:cost_handler/core/users_database_helper.dart';
import 'package:cost_handler/domain/cost_entity.dart';
import 'package:cost_handler/domain/user_entity.dart';
import 'package:cost_handler/presentation/widgets/mg_appbar.dart';
import 'package:cost_handler/presentation/widgets/mg_choosable_chip.dart';
import 'package:cost_handler/presentation/widgets/neon_button.dart';
import 'package:flutter/material.dart';

class AddCostPage extends StatefulWidget {
  static const routeName = "add_cost_page";

  const AddCostPage({Key? key}) : super(key: key);

  @override
  State<AddCostPage> createState() => _AddCostPageState();
}

class _AddCostPageState extends State<AddCostPage> {
  final costController = TextEditingController();
  final descriptionController = TextEditingController();

  UserEntity? spender;
  var isLoading = true;
  final List<UserEntity> receivers = [];
  final List<UserEntity> allUsers = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(
        Duration.zero,
        () => UsersDatabaseHelper.instance.queryAllRows().then((value) {
              allUsers.addAll(value);
              isLoading = false;
              setState(() {});
            }));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
        body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            child: Column(
              children: [
                isLoading
                    ? const CircularProgressIndicator()
                    : _createSpenderGridView(),
                const SizedBox(height: 15),
                TextField(
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: "cost",
                    hintStyle: const TextStyle(color: Colors.black38),
                    labelText: "cost",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      gapPadding: 2,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  controller: costController,
                ),
                const SizedBox(height: 15),
                TextField(
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: "description",
                    hintStyle: const TextStyle(color: Colors.black38),
                    labelText: "description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      gapPadding: 2,
                    ),
                  ),
                  controller: descriptionController,
                ),
                const SizedBox(height: 15),
                isLoading
                    ? const CircularProgressIndicator()
                    : _createUsersGridView(receivers),
                const SizedBox(height: 15),
                NeonButton(
                  onPressed: () async {
                    setState(() {
                      //todo: fix this shit
                    });
                    final result = _addCost();
                    if (await result) {
                      context.showSnack("Cost added successfully");
                    } else {
                      context.showSnack("Adding cost failed");
                    }
                  },
                  buttonText: "Add cost",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _addCost() async {
    final cost = CostEntity(
        receiverUsersNames:
            receivers.map((e) => e.userName).toList().join(", "),
        spenderUserName: spender?.userName ?? "Unknown",
        cost: double.tryParse(costController.text) ?? 0,
        description: descriptionController.text);

    final res = await SessionDatabaseHelper.instance.insert(cost);
    return res != 0;
  }

  _createUsersGridView(List<UserEntity> targetUsers) {
    return SizedBox(
      height: 200,
      child: allUsers.isEmpty
          ? const Text("There is no user yet!")
          : GridView.builder(
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              itemCount: allUsers.length,
              itemBuilder: (BuildContext context, int index) {
                final user = allUsers[index];
                return Container(
                  margin: const EdgeInsets.all(5),
                  child: MGChoosableChip(
                    label: user.userName,
                    onTap: (newValue) {
                      if (newValue) {
                        receivers.add(user);
                      } else {
                        receivers.remove(user);
                      }
                    },
                  ),
                );
              },
            ),
    );
  }

  _createSpenderGridView() {
    return SizedBox(
      height: 200,
      child: allUsers.isEmpty
          ? const Text("There is no user yet!")
          : GridView.builder(
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              itemCount: allUsers.length,
              itemBuilder: (BuildContext context, int index) {
                final user = allUsers[index];
                return Container(
                  margin: const EdgeInsets.all(5),
                  child: MGChoosableChip(
                    label: user.userName,
                    onTap: (newValue) {
                      if (newValue) {
                        spender = user;
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
