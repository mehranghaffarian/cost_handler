import 'package:cost_handler/core/constants.dart';
import 'package:cost_handler/core/users_database_helper.dart';
import 'package:cost_handler/presentation/widgets/mg_appbar.dart';
import 'package:flutter/material.dart';
import 'package:cost_handler/core/extensions/show_snack.dart';

class AddUserPage extends StatelessWidget {
  final TextEditingController addUserNameController = TextEditingController();

  static const routeName = "add_user_page";

  AddUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MGAppbar(title: "Add User"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              maxLines: 1,
              decoration: InputDecoration(
                hintText: "User name",
                hintStyle: const TextStyle(color: Colors.black38),
                labelText: "User name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  gapPadding: 2,
                ),
              ),
              controller: addUserNameController,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final result = _addUser();
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
    );
  }

  bool _addUser() {
    final givenUserName = addUserNameController.text;
    if (givenUserName.length <= Constants.userNameMaxLen) {
      UsersDatabaseHelper.instance.insert(givenUserName);
      return true;
    }
    return false;
  }
}
