import 'package:codepandas/Drawer/drawer.dart';
import 'package:codepandas/widgets/appbar.dart';
import 'package:flutter/material.dart';

class Groups extends StatelessWidget {
  const Groups({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(), drawer:  DrawerMain(), body: const Center(
          child: Text(
            "WORK IN PROGRESS",
            style: TextStyle(fontSize: 50),
          ),
        ));
  }
}
