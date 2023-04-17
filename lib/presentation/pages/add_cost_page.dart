import 'package:cost_handler/core/users_database_helper.dart';
import 'package:cost_handler/domain/user_entity.dart';
import 'package:cost_handler/presentation/widgets/mg_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddCostPage extends StatefulWidget {
  static const routeName = "add_cost_page";

  AddCostPage({Key? key}) : super(key: key);

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
    setState(() {
      UsersDatabaseHelper.instance
          .queryAllRows()
          .then((value) => allUsers.addAll(value));
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MGAppbar(
        title: "Add new cost",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
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
                Card(elevation: 5,
                  child: GridView(
                    gridDelegate:  const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 3),
                    children: _createReceiversList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _createReceiversList() {
    return receivers
        .map((e) => InkWell(child: Chip(label: Text(e.userName),), onTap: (){},))
        .toList().add(InkWell(child: Icon(Icons.add), onTap: () {},));
  }
}
