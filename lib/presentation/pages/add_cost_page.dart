import 'package:cost_handler/core/extensions/show_snack.dart';
import 'package:cost_handler/core/users_database_helper.dart';
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
  final spenderNameController = TextEditingController();

  final costController = TextEditingController();

  final descriptionController = TextEditingController();

  final List<UserEntity> receivers = [];
  final List<UserEntity> allUsers = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      UsersDatabaseHelper.instance
          .queryAllRows()
          .then((value) => allUsers.addAll(value));
    });
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
                TextField(
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: "spender username",
                    hintStyle: const TextStyle(color: Colors.black38),
                    labelText: "spender username",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      gapPadding: 2,
                    ),
                  ),
                  controller: spenderNameController,
                ),
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
                SizedBox(
                  height: 200,
                  child: GridView(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 1),
                    children: _createReceiversList(),
                  ),
                ),const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {

                    });
                    final result = _addCost();
                    if (result) {
                      context.showSnack("User added successfully");
                      Navigator.of(context).pop();
                    } else {
                      context.showSnack("useName maximum length is 75");
                    }
                  },
                  child: const Text("Add user"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _createReceiversList() {
    return allUsers.isEmpty
        ? const [Text("There is no user yet!")]
        : allUsers
            .map(
              (e) => SizedBox(width: 50, height: 50,
                child: MGChoosableChip(
                  label: e.userName,
                  onTap: (newValue) {
                    if (newValue) {
                      receivers.add(e);
                    } else {
                      receivers.remove(e);
                    }
                  },
                ),
              ),
            )
            .toList();
  }

  bool _addCost() {
    return false;
  }
}
