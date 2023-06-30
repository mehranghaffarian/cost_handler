import 'package:cost_handler/core/constants.dart';
import 'package:cost_handler/core/users_database_helper.dart';
import 'package:cost_handler/domain/user_entity.dart';
import 'package:cost_handler/presentation/widgets/mg_appbar.dart';
import 'package:cost_handler/presentation/widgets/mg_choosable_chip.dart';
import 'package:cost_handler/presentation/widgets/neon_button.dart';
import 'package:flutter/material.dart';
import 'package:cost_handler/core/extensions/show_snack.dart';

class AddUserPage extends StatefulWidget {
  static const routeName = "add_user_page";

  AddUserPage({Key? key}) : super(key: key);

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final TextEditingController addUserNameController = TextEditingController();

  final List<UserEntity> allUsers = [];
  bool isLoading = false;

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
                    context.showSnack(
                        "Username length should be less than ${Constants.userNameMaxLen}");
                    return;
                  }
                  if (givenUserName.isEmpty) {
                    context.showSnack("Username should not be empty");
                    return;
                  }
                  final result =
                      await UsersDatabaseHelper.instance.insert(givenUserName);
                  if (result != 0) {
                    context.showSnack("User added successfully");
                    addUserNameController.text = "";
                  } else {
                    context.showSnack("Adding user name failed");
                  }
                },
                buttonText: "Add user",
              ),
              const SizedBox(height: 20),
              allUsers.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : Wrap(
                      children: allUsers
                          .map(
                            (e) => InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text(
                                        "Do you want to delete ${e.userName}?"),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(),
                                          child: const Text("No")),
                                      TextButton(
                                        onPressed: () async {
                                          if (await UsersDatabaseHelper.instance
                                                  .delete(e.userName) >
                                              0) {
                                            ctx.showSnack(
                                                "${e.userName} is deleted successfully");

                                            allUsers.removeWhere((element) =>
                                                element.userName == e.userName);
                                            setState(() {});
                                          } else {
                                            ctx.showSnack(
                                                "Deleting ${e.userName} failed");
                                          }
                                          Navigator.of(ctx).pop();
                                        },
                                        child: Text(
                                          "Yes",
                                          style: TextStyle(
                                              color: colorScheme.error),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Container(
                                  //   height: 150,
                                  //     width: 200,
                                  //     color: colorScheme.background,
                                  //   child: Column(
                                  //     children: [
                                  //       Text(
                                  //           "Do you want to delete ${e.userName}?"),
                                  //       Row(
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.spaceBetween,
                                  //         children: [
                                  //           TextButton(
                                  //               onPressed: () =>
                                  //                   Navigator.of(ctx).pop(),
                                  //               child: const Text("No")),
                                  //           TextButton(
                                  //             onPressed: () async {
                                  //               if (await UsersDatabaseHelper
                                  //                       .instance
                                  //                       .delete(e.userName) >
                                  //                   0) {
                                  //                 ctx.showSnack(
                                  //                     "${e.userName} is deleted successfully");
                                  //
                                  //                 allUsers.removeWhere(
                                  //                     (element) =>
                                  //                         element.userName ==
                                  //                         e.userName);
                                  //                 setState(() {});
                                  //               } else {
                                  //                 ctx.showSnack(
                                  //                     "Deleting ${e.userName} failed");
                                  //               }
                                  //               Navigator.of(ctx).pop();
                                  //             },
                                  //             child: Text(
                                  //               "Yes",
                                  //               style: TextStyle(
                                  //                   color: colorScheme.error),
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.all(20),
                                child: Text(e.userName),
                              ),
                            ),
                          )
                          .toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
