import 'package:cost_handler/core/extensions/show_snack.dart';
import 'package:cost_handler/core/session_database_helper.dart';
import 'package:cost_handler/core/users_database_helper.dart';
import 'package:cost_handler/domain/cost_entity.dart';
import 'package:cost_handler/domain/user_entity.dart';
import 'package:cost_handler/presentation/widgets/mg_appbar.dart';
import 'package:cost_handler/presentation/widgets/mg_choosable_chip.dart';
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
  final List<UserEntity> receivers = [];
  final List<UserEntity> allUsers = [];

  @override
  void initState() {
    mounted;
    super.initState();

    UsersDatabaseHelper.instance
        .queryAllRows()
        .then((value) => allUsers.addAll(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MGAppbar(
        title: "Add new cost",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            child: Column(
              children: [
                _createSpenderGridView(),
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
                _createUsersGridView(receivers),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      //todo: fix this shit
                    });
                    final result = _addCost();
                    if (await result) {
                      context.showSnack("Cost added successfully");
                      Navigator.of(context).pop();
                    } else {
                      context.showSnack("Adding cost failed");
                    }
                  },
                  child: const Text("Add cost"),
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: Text("Refresh")),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _addCost() async {
    final cost = CostEntity(
        receiverUsersNames: receivers.map((e) => e.userName).toList().join(", "),
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
          : ListView.builder(
              // gridDelegate:
              //     const SliverGridDelegateWithMaxCrossAxisExtent(
              //         maxCrossAxisExtent: 4),
              itemCount: allUsers.length,
              itemBuilder: (BuildContext context, int index) {
                final user = allUsers[index];
                return MGChoosableChip(
                  label: user.userName,
                  onTap: (newValue) {
                    if (newValue) {
                      receivers.add(user);
                    } else {
                      receivers.remove(user);
                    }
                  },
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
          : ListView.builder(
              // gridDelegate:
              //     const SliverGridDelegateWithMaxCrossAxisExtent(
              //         maxCrossAxisExtent: 4),
              itemCount: allUsers.length,
              itemBuilder: (BuildContext context, int index) {
                final user = allUsers[index];
                return MGChoosableChip(
                  label: user.userName,
                  onTap: (newValue) {
                    if (newValue) {
                      spender = user;
                    }
                  },
                );
              },
            ),
    );
  }
}
