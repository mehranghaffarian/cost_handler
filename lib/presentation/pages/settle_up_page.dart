import 'package:cost_handler/core/session_database_helper.dart';
import 'package:cost_handler/domain/cost_entity.dart';
import 'package:cost_handler/domain/share_entity.dart';
import 'package:cost_handler/presentation/widgets/mg_appbar.dart';
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
    return Scaffold(
      appBar: const MGAppbar(title: "Settle Up"),
      body: isLoading
          ? const CircularProgressIndicator()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const Text("All shares:"),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 200,
                      child: ListView(
                        children: _buildSharesWidgets(shares),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text("Simplified Shares"),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 200,
                      child: ListView(
                        children: _buildSharesWidgets(simplifiedShares),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  _settleUp() {
    //calculating the shares
    for (CostEntity e in costs) {
      final costUsers = e.receiverUsersNames.split(", ");
      final costUsersLen = costUsers.length;
      //69
      debugPrint("******************\nline 69\n**************************");
      for (int i = 0; i < costUsersLen; i++) {
        final share = ShareEntity(
          borrower: costUsers[i],
          lender: e.spenderUserName,
          cost: e.cost / costUsersLen,
          description: e.description ?? "Unknown",
        );

        if (shares.containsKey(costUsers[i])) {
          shares.update(costUsers[i], (value) {
            value.add(share);
            return value;
          });
        } else {
          shares.putIfAbsent(costUsers[i], () => [share]);
        }
      }
    }
    simplifiedShares.addAll(shares);
    //89
    debugPrint("******************\nline 89\n**************************");
    // settling up
    for (int i = 0; i < simplifiedShares.length; i++) {
      final user = simplifiedShares.keys.elementAt(i);
      final userShares = simplifiedShares[user];

      if (userShares != null) {
        //96
        debugPrint("******************\nline 96\n**************************");
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
              shareWithSameLenderIndex > j) {
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
          //124
          debugPrint(
              "******************\nline 124\n**************************");
        }
        simplifiedShares.update(user, (value) => userShares);
      }
    }

    //simplifying shares, which has one rule
    //0. 1->2 and 2->3 and 1->3 can be simplified to (1->3) and removing one of the first two
    //127
    debugPrint("******************\nline 127\n**************************");
    for (int i = 0; i < simplifiedShares.length; i++) {
      final firstUser = simplifiedShares.keys.elementAt(i);
      final firstUserShares = simplifiedShares[firstUser];

      if (firstUserShares != null) {
        //133
        debugPrint("******************\nline 133\n**************************");
        for (int j = 0; j < firstUserShares.length; j++) {
          final firstUserFirstShare = firstUserShares[j];
          final secondUserShares = simplifiedShares[firstUserFirstShare.lender];

          if (secondUserShares != null) {
            for (int k = 0; k < secondUserShares.length; k++) {
              final secondUserShare = secondUserShares[k];
              final firstUserShareWithTheSameLenderIndex =
                  firstUserShares.lastIndexWhere(
                      (element) => element.lender == secondUserShare.lender);

              if (firstUserShareWithTheSameLenderIndex != -1 &&
                  firstUserShareWithTheSameLenderIndex > j) {
                final firstUserSecondShare =
                    firstUserShares[firstUserShareWithTheSameLenderIndex];
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

                  secondUserShares.remove(secondUserShare);
                  k--; //to continue simplifying with the new shares

                  firstUserShares.remove(firstUserFirstShare);
                  firstUserShares.insert(j, firstUserNewFirstShare);

                  firstUserShares.remove(firstUserSecondShare);
                  firstUserShares.insert(firstUserShareWithTheSameLenderIndex,
                      firstUserNewSecondShare);
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

                  secondUserShares.remove(secondUserShare);
                  secondUserShares.insert(k, secondUserNewShare);

                  firstUserShares.remove(firstUserFirstShare);

                  firstUserShares.remove(firstUserSecondShare);
                  firstUserShares.insert(firstUserShareWithTheSameLenderIndex,
                      firstUserNewSecondShare);
                  break; //the target share has been fully simplified
                }
              }
              //204
              debugPrint(
                  "******************\nline 204\n**************************");
            }
            simplifiedShares.update(
              firstUserFirstShare.lender,
              (value) => secondUserShares,
            );
          }
        }
        //214
        debugPrint("******************\nline 214\n**************************");
        simplifiedShares.update(firstUser, (value) => firstUserShares);
      }
      //207
      debugPrint("******************\nline 207\n**************************");
    }
    debugPrint("******************\nend of settling up\n**************************");
    isLoading = false;
    setState(() {});
  }
  /*
  2->1: 3
  3->1: 12
  2->1: 12
  1->3: 24
  2->3: 24

  3->1: 3
  2->3: 39

  2->1: 3
  2->3: 12
  1->3: 24
  * */

  List<Widget> _buildSharesWidgets(
      Map<String, List<ShareEntity>> targetShares) {
    final List<Widget> shareCards = [];
    final users = targetShares.keys.toList();

    for (String user in users) {
      final tempWidgets = shares[user]
          ?.map(
            (e) => Card(
              elevation: 5,
              child: Column(
                children: [
                  Text("Borrower: ${e.borrower}"),
                  const SizedBox(height: 10),
                  Text("Lender: ${e.lender}"),
                  const SizedBox(height: 10),
                  Text("Cost: ${e.cost}"),
                  const SizedBox(height: 10),
                  Text("Description: ${e.description}"),
                ],
              ),
            ),
          )
          .toList();
      if (tempWidgets != null) {
        shareCards.addAll(tempWidgets);
      }
      shareCards.add(Container(
        height: 20,
        color: Colors.cyan,
      ));
    }
    shareCards.add(const Text("End of shares"));

    return shareCards;
  }

  _printShares() {
    for (String user in shares.keys) {
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
}
