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
              onPressed: () async {
                final givenUserName = addUserNameController.text;
                if (givenUserName.length > Constants.userNameMaxLen) {
                  context.showSnack("Username length should be less than ${Constants.userNameMaxLen}");
                return;}
                if(givenUserName.isEmpty){
                  context.showSnack("Username should not be empty");
                  return;
                }
                final result = await UsersDatabaseHelper.instance.insert(givenUserName);
                if (result != 0) {
                  context.showSnack("User added successfully");
                  addUserNameController.text = "";
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
}
