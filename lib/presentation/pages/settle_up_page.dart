import 'package:cost_handler/core/session_database_helper.dart';
import 'package:cost_handler/domain/cost_entity.dart';
import 'package:cost_handler/domain/share_entity.dart';
import 'package:cost_handler/presentation/widgets/mg_appbar.dart';
import 'package:flutter/material.dart';

class SettleUpPage extends StatefulWidget {
  const SettleUpPage({Key? key}) : super(key: key);

  @override
  State<SettleUpPage> createState() => _SettleUpPageState();
}

class _SettleUpPageState extends State<SettleUpPage> {
  var isLoading = true;
  List<CostEntity> costs = [];
  Map<String, ShareEntity> shares = {};

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
      appBar: MGAppbar(title: "Add User"),
      body: isLoading
          ? CircularProgressIndicator()
          : SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    itemBuilder: (_, index) => _buildShareWidget(index),
                    itemCount: shares.length,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                      itemBuilder: (_, index) => _buildSettleIpReport(index)),
                ],
              ),
            ),
    );
  }

  _settleUp() {
    //calculating the shares
    costs.map((e) {
      final costUsers = e.receiverUsersNames.split(", ");
      final costUsersLen = costUsers.length;

      for (int i = 0; i < costUsersLen; i++) {

      }
    });

    //really settling up


    isLoading = false;
    setState(() {});
  }

  _buildShareWidget(int index) {
    return Text("FU1");
  }

  _buildSettleIpReport(int index) {
    return Text("FU2");
  }
}
