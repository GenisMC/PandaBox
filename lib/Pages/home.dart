import 'package:codepandas/Classes/items.dart';
import 'package:codepandas/Drawer/drawer.dart';
import 'package:codepandas/Services/provider.dart';
import 'package:codepandas/device_check.dart';
import 'package:codepandas/widgets/appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:html' as html;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderService>(context);

    MediaQueryData query = MediaQuery.of(context);

    void deleteItem(String docId, String fileName) {
      provider.db.deleteItem(docId);
      provider.storage.deleteFile(fileName);
      provider.db.getItems();
      setState(() {});
    }

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
        drawer: DrawerMain(),
        body: FutureBuilder<List<Item>>(
          future: provider.db.getItems(),
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
                                  items[index].displayName,
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
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      child: const Icon(
                                        Icons.close_rounded,
                                        color: Color(0xffF32424),
                                        size: 25,
                                      ),
                                      onTap: () {
                                        deleteItem(items[index].docId,
                                            items[index].fileName);
                                      },
                                    ),
                                  )
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
