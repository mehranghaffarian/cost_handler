import 'package:cost_handler/presentation/pages/add_cost_page.dart';
import 'package:cost_handler/presentation/pages/add_user/add_user_page.dart';
import 'package:cost_handler/presentation/pages/home_page.dart';
import 'package:cost_handler/presentation/pages/settle_up_page.dart';
import 'package:cost_handler/presentation/pages/test-page.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context){
    final color = Colors.red;
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color.fromRGBO(10, 155, 10, 1.0),
          onPrimary: Color.fromRGBO(18, 78, 1, 1.0),
          secondary: Color.fromRGBO(15, 130, 232, 1.0),
          onSecondary: Color.fromRGBO(18, 78, 1, 1.0),
          error: Color.fromRGBO(18, 78, 1, 1.0),
          onError: Color.fromRGBO(18, 78, 1, 1.0),
          background: Color.fromRGBO(0, 20, 50, 1.0),
          onBackground: Color.fromRGBO(119, 1, 186, 1.0),
          surface: Color.fromRGBO(5, 150, 120, 1.0),
          onSurface: Color.fromRGBO(103, 3, 121, 1.0),
        ),
      //   primaryColor: const Color.fromRGBO(65, 135, 44, 1.0),
      //   primaryColorDark: const Color.fromRGBO(18, 78, 1, 1.0),
      //   errorColor: const Color.fromRGBO(150, 20, 20, 1.0),
      //   backgroundColor: const Color.fromRGBO(126, 212, 142, 1.0),
      //   textTheme: const TextTheme(
      //     titleMedium: TextStyle(
      //       fontSize: 18,
      //       color: Color.fromRGBO(0, 0, 0, 1.0),
      //     ),
      //     titleSmall: TextStyle(
      //       fontSize: 15,
      //       color: Color.fromRGBO(0, 0, 0, 1.0),
      //     ),
      //     titleLarge: TextStyle(
      //       fontSize: 19,
      //       fontWeight: FontWeight.bold,
      //       color: Color.fromRGBO(0, 0, 0, 1.0),
      //     ),
      //   ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: TestPage.routeName,
      routes: {
        HomePage.routeName: (ctx) => HomePage(),
        AddUserPage.routeName: (ctx) => AddUserPage(),
        AddCostPage.routeName: (ctx) => const AddCostPage(),
        SettleUpPage.routeName: (ctx) => const SettleUpPage(),
        TestPage.routeName: (ctx) => TestPage(),
       },
    );
  }

}
