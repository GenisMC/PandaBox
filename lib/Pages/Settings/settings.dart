import 'package:codepandas/components/Drawer/drawer.dart';
import 'package:codepandas/widgets/appbar.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: CustomAppBar(),
        drawer: DrawerMain(),
        body: Center(
          child: Text(
            "WORK IN PROGRESS",
            style: TextStyle(fontSize: 50),
          ),
        ));
  }
}
