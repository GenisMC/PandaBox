import 'package:codepandas/Classes/app_user.dart';
import 'package:codepandas/Drawer/drawer.dart';
import 'package:codepandas/Services/provider.dart';
import 'package:codepandas/device_check.dart';
import 'package:codepandas/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Groups extends StatelessWidget {
  const Groups({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderService>(context);

    int crossAxisCount = 2;

    if (context.isPhone) {
      crossAxisCount = 2;
    } else if (context.isTablet) {
      crossAxisCount = 3;
    } else if (context.isDesktop) {
      crossAxisCount = 4;
    } else if (context.isHiRes) {
      crossAxisCount = 5;
    }

    return Scaffold(
        appBar: const CustomAppBar(),
        drawer: const DrawerMain(),
        body: FutureBuilder<List<AppUser>>(
          future: provider.db.getUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<AppUser> users = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                    ),
                    itemCount: users.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Card(
                        child: Center(
                          child: Text(users[i].name),
                        ),
                      );
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
