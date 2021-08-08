import 'package:codepandas/Classes/app_user.dart';
import 'package:codepandas/Classes/items.dart';
import 'package:codepandas/Drawer/drawer.dart';
import 'package:codepandas/Services/provider.dart';
import 'package:codepandas/device_check.dart';
import 'package:codepandas/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Groups extends StatelessWidget {
  const Groups({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderService>(context);

    MediaQueryData query = MediaQuery.of(context);

    int crossAxisCount = 2;
    double fontSize = 12;
    bool hideText = false;

    if (context.isPhone) {
      crossAxisCount = 2;
      fontSize = 10;
      hideText = true;
    } else if (context.isTablet) {
      crossAxisCount = 3;
      fontSize = 12;
      hideText = true;
    } else if (context.isDesktop) {
      crossAxisCount = 4;
      fontSize = 14;
      hideText = false;
    } else if (context.isHiRes) {
      crossAxisCount = 5;
      fontSize = 16;
      hideText = false;
    }

    return Scaffold(
        appBar: const CustomAppBar(),
        drawer: DrawerMain(),
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
