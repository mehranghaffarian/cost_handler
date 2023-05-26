import 'package:cost_handler/core/constants.dart';
import 'package:cost_handler/core/users_database_helper.dart';
import 'package:cost_handler/presentation/widgets/mg_appbar.dart';
import 'package:cost_handler/presentation/widgets/neon_button.dart';
import 'package:flutter/material.dart';
import 'package:cost_handler/core/extensions/show_snack.dart';

class AddUserPage extends StatelessWidget {
  final TextEditingController addUserNameController = TextEditingController();

  static const routeName = "add_user_page";

  AddUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            NeonButton(
              onPressed: () async{
                final result = _addUser();
                if (await result) {
                  context.showSnack("User added successfully");
                } else {
                  context.showSnack("Adding user name failed");
                }
              },
              buttonText: "Add user",
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<bool> _addUser() async {
    final givenUserName = addUserNameController.text;
    if (givenUserName.length <= Constants.userNameMaxLen) {
      final res = await UsersDatabaseHelper.instance.insert(givenUserName);
      return res != 0;
    }
    return false;
  }
}
