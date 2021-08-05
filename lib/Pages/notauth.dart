import 'package:codepandas/Classes/items.dart';
import 'package:codepandas/Drawer/drawer.dart';
import 'package:codepandas/Services/provider.dart';
import 'package:codepandas/device_check.dart';
import 'package:codepandas/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:html' as html;

import 'package:provider/provider.dart';

class NotAuthorizedPage extends StatelessWidget {
  const NotAuthorizedPage({Key? key}) : super(key: key);
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
        backgroundColor: const Color(0xff434343),
        appBar: const CustomAppBar(),
        body: FutureBuilder<List<Item>>(
          future:
              provider.db.getItems(provider.authService.auth.currentUser?.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<Item> items = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                    ),
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  items[index].fileName,
                                  style: TextStyle(fontSize: fontSize),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          provider.storage.downloadItem(
                                              items[index].downloadURL,
                                              items[index].fileName);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(0)),
                                            minimumSize: const Size(100, 45),
                                            primary: const Color(0xffF64747)),
                                        child: hideText
                                            ? const Icon(Icons.download_rounded)
                                            : Text(
                                                "Download",
                                                style: GoogleFonts.saira(
                                                    fontSize: fontSize),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                      )),
                                ],
                              ),
                            ],
                          ),
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
