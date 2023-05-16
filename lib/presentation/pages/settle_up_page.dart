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
                      child: ListView(children: _buildSharesWidgets()),
                    ),
                    const SizedBox(height: 30),
                    const Text("Simplified Shares"),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 200,
                      child: ListView(children: _buildSettleUpReport()),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  _settleUp() {
    //calculating the shares
    debugPrint(
        '\n\n**********************************\ncosts len: ${costs.length}\n');
    //costs.map((e)
    for (CostEntity e in costs) {
      final costUsers = e.receiverUsersNames.split(", ");
      final costUsersLen = costUsers.length;
      debugPrint(
          "\n\n**********************************\ncurrent cost receivers: ${e.receiverUsersNames}\n");

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
    // settling up

    //adding the shares with the same lender and borrower
    for (int i = 0; i < simplifiedShares.length; i++) {
      final user = simplifiedShares.keys.elementAt(i);
      final userShares = simplifiedShares[user];

      if (userShares != null) {
        final userSharesIterator = userShares.iterator;
        while (userSharesIterator.moveNext()) {
          final share = userSharesIterator.current;
          final shareWithSameLenderIndex = userShares
              .indexWhere((element) => element.lender == share.lender);
          if (shareWithSameLenderIndex != -1) {
            userShares.add(
              ShareEntity(
                borrower: share.borrower,
                lender: share.lender,
                cost: share.cost + userShares[shareWithSameLenderIndex].cost,
              ),
            );
            userShares.remove(share);
            userShares.removeAt(shareWithSameLenderIndex);
          }
        }
        simplifiedShares.update(user, (value) => userShares);
      }
    }

    //simplifying shares, which has two rules
    //1. 1->2 and 2->3 can be simplified to 1->3
    //2. 1->2 and 2->1 can be simplified to empty ?!
    for (int i = 0; i < simplifiedShares.length; i++) {
      final firstUser = simplifiedShares.keys.elementAt(i);
      final firstUserShares = simplifiedShares[firstUser];

      if (firstUserShares != null) {
        final firstUserSharesIterator = firstUserShares.iterator;
        while(firstUserSharesIterator.moveNext()){
          final firstUserShare = firstUserSharesIterator.current;
          final secondUserShares = simplifiedShares[firstUserShare.lender];

          if (secondUserShares != null) {
            final secondUserSharesIterator =  secondUserShares.iterator;
            while(secondUserSharesIterator.moveNext()) {
              final secondUserShare = secondUserSharesIterator.current;
              //implementing the second rule
              if (secondUserShare.lender == firstUser) {
                secondUserShares.remove(secondUserShare);
                firstUserShares.remove(firstUserShare);
                if (firstUserShare.cost > secondUserShare.cost) {
                  final firstUserNewShare = ShareEntity(
                    borrower: firstUserShare.borrower,
                    lender: firstUserShare.lender,
                    cost: firstUserShare.cost - secondUserShare.cost,
                  );
                  firstUserShares.add(
                    firstUserNewShare,
                  );
                } else {
                  secondUserShares.add(
                    ShareEntity(
                      borrower: secondUserShare.borrower,
                      lender: secondUserShare.lender,
                      cost: secondUserShare.cost - firstUserShare.cost,
                    ),
                  );
                }
              }
              //implementing first rule
              else {
                secondUserShares.remove(secondUserShare);
                firstUserShares.remove(firstUserShare);
                if (firstUserShare.cost > secondUserShare.cost) {
                  final firstUserNewShare = ShareEntity(
                    borrower: firstUserShare.borrower,
                    lender: firstUserShare.lender,
                    cost: firstUserShare.cost - secondUserShare.cost,
                  );
                  firstUserShares.add(firstUserNewShare);
                } else {
                  secondUserShares.add(
                    ShareEntity(
                      borrower: secondUserShare.borrower,
                      lender: secondUserShare.lender,
                      cost: secondUserShare.cost - firstUserShare.cost,
                    ),
                  );
                }
              }
            }
            simplifiedShares.update(
              firstUserShare.lender,
              (value) => secondUserShares,
            );
          }
        }
        simplifiedShares.update(firstUser, (value) => firstUserShares);
      }
    }

    isLoading = false;
    setState(() {});
  }

  List<Widget> _buildSharesWidgets() {
    final List<Widget> shareCards = [];
    final userShares = shares.keys.toList();

    for (String user in userShares) {
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

  _buildSettleUpReport() {
    return [const Text("FU2")];
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
