import 'package:cost_handler/core/extensions/show_snack.dart';
import 'package:cost_handler/core/session_database_helper.dart';
import 'package:cost_handler/core/users_database_helper.dart';
import 'package:cost_handler/domain/cost_entity.dart';
import 'package:cost_handler/domain/share_entity.dart';
import 'package:cost_handler/presentation/widgets/mg_report_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettleUpPage extends StatefulWidget {
  static const routeName = "settle_up_page";

  const SettleUpPage({Key? key}) : super(key: key);

  @override
  State<SettleUpPage> createState() => _SettleUpPageState();
}

class _SettleUpPageState extends State<SettleUpPage> {
  var isLoading = true;
  List<CostEntity> costs = [];
  Map<String, List<ShareEntity>> shares = {};
  Map<String, List<ShareEntity>> simplifiedShares = {};

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      SessionDatabaseHelper.instance.queryAllRows().then((value) {
        costs = value;
        _settleUp();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeightRemaining = MediaQuery.of(context).size.height - 25;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: isLoading
          ? const CircularProgressIndicator()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Simplified Shares",
                      style: textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: deviceHeightRemaining * 0.4,
                      child: simplifiedShares.isEmpty ? Text(
                        "There is no share",
                        style: textTheme.titleLarge,
                      ) : GridView(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        children: _buildSharesWidgets(
                            targetShares: simplifiedShares,
                            iconColor: colorScheme.onSurface,
                            descriptionNeeded: false),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "All shares",
                      style: textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: deviceHeightRemaining * 0.4,
                      child: shares.isEmpty ? Text(
                        "There is no share",
                        style: textTheme.titleLarge,
                      ) : GridView(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        children: _buildSharesWidgets(
                          iconColor: colorScheme.onSurface,
                          targetShares: shares,
                        ),
                      ),
                    ), const SizedBox(height: 15),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          showCupertinoDialog(context: context, builder: (context) => AlertDialog(
                            title: const Text(
                                "Do you really want to delete everything?"),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(),
                                  child: const Text("No")),
                              TextButton(
                                onPressed: () async {
                                  if (await UsersDatabaseHelper.instance
                                      .deleteAll() >
                                      0) {
                                    context.showSnack(
                                        "All users deleted successfully");
                                    setState(() {});
                                  } else {
                                    context.showSnack(
                                        "Deleting users failed");
                                  }
                                  if (await SessionDatabaseHelper.instance
                                      .deleteAll() >
                                      0) {
                                    context.showSnack(
                                        "All costs deleted successfully");
                                    setState(() {});
                                  } else {
                                    context.showSnack(
                                        "Deleting costs failed");
                                  }
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Yes",
                                  style: TextStyle(
                                      color: colorScheme.error),
                                ),
                              ),
                            ],));
                        },
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(colorScheme.error),
                        ),
                        child: const Text("Delete all data!"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  _settleUp() {
    _calculateShares();
    _simplifyShares();
  }

  List<Widget> _buildSharesWidgets({
    required Map<String, List<ShareEntity>> targetShares,
    required Color iconColor,
    descriptionNeeded = true,
  }) {
    final List<Widget> shareCards = [];
    final users = targetShares.keys.toList();

    for (String user in users) {
      final tempWidgets = targetShares[user]?.map(
        (e) {
          final List<Widget> columnChildren = [
            Row(children: [
              Image.asset(
                "assets/images/paying_money.png",
                width: 30,
                height: 30,
                color: iconColor,
              ),
              Text(" ${e.borrower}")
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Image.asset(
                "assets/images/getting_money.png",
                width: 30,
                height: 30,
                color: iconColor,
              ),
              Text(" ${e.lender}")
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Image.asset(
                "assets/images/price.png",
                width: 30,
                height: 30,
                color: iconColor,
              ),
              Text(" ${e.cost.toStringAsFixed(3)}")
            ]),
          ];
          if (descriptionNeeded) {
            columnChildren.add(const SizedBox(height: 10));
            columnChildren.add(
              Row(children: [
                Image.asset(
                  "assets/images/description.png",
                  width: 30,
                  height: 30,
                  color: iconColor,
                ),
                Flexible(
                  child: Text(
                    " ${e.description}",
                    overflow: TextOverflow.visible,
                    maxLines: 1,
                  ),
                )
              ]),
            );
          }

          return MGReportCard(reportInfoChildren: columnChildren);
        },
      ).toList();
      if (tempWidgets != null) {
        shareCards.addAll(tempWidgets);
      }
    }
    shareCards.add(const Text("End of shares"));
    return shareCards;
  }

  _printShares() {
    for (String user in shares.keys) {
      debugPrint("\n$user shares:\n");
      final userShares = shares[user];
      if (userShares != null) {
        for (ShareEntity s in userShares) {
          debugPrint(
              "\nborrower: ${s.borrower}\nlender: ${s.lender}\ndescription: ${s.description}\ncost: ${s.cost}");
        }
      }
    }
  }

  _printCosts() {
    for (CostEntity c in costs) {
      debugPrint(
          "\ncost: ${c.cost}\ndescription: ${c.description}\nreceivers: ${c.receiverUsersNames}\nsepender: ${c.spenderUserName}");
    }
  }

  void _calculateShares() {
    //calculating the shares
    debugPrint("***************\ncost:\n");
    _printCosts();
    debugPrint("\n***********************\n");
    for (CostEntity e in costs) {
      final borrowers = e.receiverUsersNames.split(", ");
      final costUsersLen = borrowers.length;
      for (int i = 0; i < costUsersLen; i++) {
        final share = ShareEntity(
          borrower: borrowers[i],
          lender: e.spenderUserName,
          cost: e.cost / costUsersLen,
          description: e.description ?? "Unknown",
        );

        if (shares.containsKey(borrowers[i])) {
          shares.update(borrowers[i], (value) {
            value.add(share);
            return value;
          });
        } else {
          shares.putIfAbsent(borrowers[i], () => [share]);
        }
      }
    }
  }

  void _simplifyShares() {
    debugPrint("***************\nshares:\n");
    _printShares();
    debugPrint("\n***********************\n");
    // settling up
    for (var element in shares.keys) {
      final tempUser = shares[element];
      if (tempUser != null) {
        final tempShares = tempUser
            .map((e) => ShareEntity(
                  borrower: e.borrower,
                  lender: e.lender,
                  cost: e.cost,
                ))
            .toList();
        simplifiedShares.putIfAbsent(element, () => tempShares);
      }
    }
    for (int i = 0; i < simplifiedShares.length; i++) {
      final user = simplifiedShares.keys.elementAt(i);
      final userShares = simplifiedShares[user];

      if (userShares != null) {
        for (int j = 0; j < userShares.length; j++) {
          final share = userShares[j];
          final shareWithSameLenderIndex = userShares
              .lastIndexWhere((element) => element.lender == share.lender);

          //eliminating costs that the borrower and lender are the same
          if (share.lender == share.borrower) {
            userShares.remove(share);
            j--;
          }
          //adding the shares with the same lender and borrower
          else if (shareWithSameLenderIndex != -1 &&
              shareWithSameLenderIndex != j) {
            userShares.add(
              ShareEntity(
                borrower: share.borrower,
                lender: share.lender,
                cost: share.cost + userShares[shareWithSameLenderIndex].cost,
              ),
            );
            userShares.removeAt(shareWithSameLenderIndex);
            userShares.remove(share);
            j--;
          }
        }
        simplifiedShares.update(user, (value) => userShares);
      }
    }

    debugPrint("***********\nstarting simplifying\n**********");
    //simplifying shares, which has two rules
    //0. 1->2 and 2->3 and 1->3 can be simplified to (1->3) and removing one of the first two
    //1. 1->2 and 2->1 simplifies to empty
    for (int i = 0; i < simplifiedShares.length; i++) {
      final firstUser = simplifiedShares.keys.elementAt(i);
      final firstUserShares = simplifiedShares[firstUser];

      if (firstUserShares != null) {
        for (int j = 0; j < firstUserShares.length; j++) {
          final firstUserFirstShare = firstUserShares[j];
          final secondUserShares = simplifiedShares[firstUserFirstShare.lender];

          debugPrint(
              "******************\nnew firstUserFirstShare: ${firstUserFirstShare.toString()}\n**************************");
          if (secondUserShares != null) {
            for (int k = 0; k < secondUserShares.length; k++) {
              final secondUserShare = secondUserShares[k];
              final firstUserShareWithTheSameLenderIndex =
                  firstUserShares.lastIndexWhere(
                      (element) => element.lender == secondUserShare.lender);

              debugPrint(
                  "******************\nnew secondUserShare: ${secondUserShare.toString()}\n**************************");

              if (secondUserShare.lender == firstUserFirstShare.borrower &&
                  firstUserFirstShare.lender == secondUserShare.borrower) {
                if (secondUserShare.cost > firstUserFirstShare.cost) {
                  //1. 1->2*(x) and 2->1*(x+y) simplifies to 2->1*(y)
                  final secondUserNewShare = ShareEntity(
                    borrower: secondUserShare.borrower,
                    lender: secondUserShare.lender,
                    cost: secondUserShare.cost - firstUserFirstShare.cost,
                  );

                  secondUserShares.insert(k, secondUserNewShare);
                  secondUserShares.remove(secondUserShare);

                  firstUserShares.remove(firstUserFirstShare);
                } else {
                  //1. 1->2*(x+y) and 2->1*(x) simplifies to 1->2*(y)
                  final firstUserNewFirstShare = ShareEntity(
                    borrower: firstUserFirstShare.borrower,
                    lender: firstUserFirstShare.lender,
                    cost: firstUserFirstShare.cost - secondUserShare.cost,
                  );

                  secondUserShares.remove(secondUserShare);

                  firstUserShares.insert(j, firstUserNewFirstShare);
                  firstUserShares.remove(firstUserFirstShare);
                }
                j--;
                debugPrint(
                    "*************************\n$firstUser share simplified in first if\n**********************");
                break;
              } else if (firstUserShareWithTheSameLenderIndex != -1 &&
                  firstUserShareWithTheSameLenderIndex != j) {
                debugPrint(
                    "*************************\n$firstUser share simplifying in second if\n**********************");
                final firstUserSecondShare =
                    firstUserShares[firstUserShareWithTheSameLenderIndex];

                debugPrint(
                    "******************\ncurrent firstUserSecondShare: ${firstUserSecondShare.toString()}\n**************************");
                //(1->2)*(x+y) and (2->3)(x) and (1->3)*z can be simplified to
                //(1->2)*y and (1->3)*(z+x)
                if (firstUserFirstShare.cost > secondUserShare.cost) {
                  final firstUserNewFirstShare = ShareEntity(
                    borrower: firstUserFirstShare.borrower,
                    lender: firstUserFirstShare.lender,
                    cost: firstUserFirstShare.cost - secondUserShare.cost,
                  );
                  final firstUserNewSecondShare = ShareEntity(
                    borrower: firstUserSecondShare.borrower,
                    lender: firstUserSecondShare.lender,
                    cost: firstUserSecondShare.cost + secondUserShare.cost,
                  );
                  debugPrint(
                      "******************\nsecond user share removed\ncurrent firstUserNewFirstShare: ${firstUserNewFirstShare.toString()}\n**************************");
                  debugPrint(
                      "******************\nsecond user share removed\ncurrent firstUserNewSecondShare: ${firstUserNewSecondShare.toString()}\n**************************");
                  secondUserShares.remove(secondUserShare);

                  firstUserShares.insert(j, firstUserNewFirstShare);
                  firstUserShares.remove(firstUserFirstShare);

                  firstUserShares.insert(firstUserShareWithTheSameLenderIndex,
                      firstUserNewSecondShare);
                  firstUserShares.remove(firstUserSecondShare);

                  j--; //to continue simplifying with other shares
                  break;
                }
                //(1->2)*(x) and (2->3)(x+y) and (1->3)*z can be simplified to
                //(2->3)*y and (1->3)*(z+x)
                else {
                  final secondUserNewShare = ShareEntity(
                    borrower: secondUserShare.borrower,
                    lender: secondUserShare.lender,
                    cost: secondUserShare.cost - firstUserFirstShare.cost,
                  );
                  final firstUserNewSecondShare = ShareEntity(
                    borrower: firstUserSecondShare.borrower,
                    lender: firstUserSecondShare.lender,
                    cost: firstUserSecondShare.cost + firstUserFirstShare.cost,
                  );

                  secondUserShares.insert(k, secondUserNewShare);
                  secondUserShares.remove(secondUserShare);
                  debugPrint(
                      "******************\n$firstUser first share removed\ncurrent secondUserShare: ${secondUserShare.toString()}\n**************************");
                  debugPrint(
                      "******************\n$firstUser first share removed\ncurrent firstUserNewSecondShare: ${firstUserNewSecondShare.toString()}\n**************************");
                  firstUserShares.remove(firstUserFirstShare);

                  firstUserShares.insert(firstUserShareWithTheSameLenderIndex,
                      firstUserNewSecondShare);
                  firstUserShares.remove(firstUserSecondShare);

                  j--; //because the Jth share has changed
                  break; //the target share has been fully simplified
                }
              }
              debugPrint(
                  "******************\nmoving to ${secondUserShare.borrower} share, k: $k\n**************************");
            }
            simplifiedShares.update(
              firstUserFirstShare.lender,
              (value) => secondUserShares,
            );
          }
          debugPrint(
              "******************\nmoving to next user shares, j: $j\n**************************");
        }
        debugPrint(
            "******************\nmoving to $firstUser next share\n**************************");
        simplifiedShares.update(firstUser, (value) => firstUserShares);
      }
      debugPrint(
          "******************\n$firstUser shares fully simplified\n**************************");
    }
    debugPrint(
        "******************\nend of settling up\n**************************");
    isLoading = false;
    setState(() {});
  }
}
