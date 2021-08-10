import 'package:codepandas/Classes/app_user.dart';
import 'package:codepandas/Classes/user_group.dart';
import 'package:codepandas/Drawer/drawer.dart';
import 'package:codepandas/Services/provider.dart';
import 'package:codepandas/device_check.dart';
import 'package:codepandas/widgets/appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Groups extends StatelessWidget {
  const Groups({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderService>(context);

    return Scaffold(
        backgroundColor: const Color(0xff434343),
        appBar: const CustomAppBar(),
        drawer: const DrawerMain(),
        body: FutureBuilder<AppUser>(
          future: provider.db
              .getCurrentUser(provider.authService.auth.currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                var groups = snapshot.data!.groups;
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (BuildContext context, int i) {
                      return CardWidget(group: groups[i]);
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

class CardWidget extends StatefulWidget {
  const CardWidget({Key? key, required this.group}) : super(key: key);

  final UserGroup group;

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  bool showData = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: Container(
              color: const Color(0xff6D6D6D),
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
                      child: Text(
                        widget.group.name.toUpperCase(),
                        style: GoogleFonts.lato(fontSize: 20),
                      ),
                    ),
                  ),
                  const Positioned(
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xffE2E2E2),
                      size: 55,
                    ),
                    right: 10,
                  )
                ],
              )),
          onTap: () {
            setState(() {
              showData = !showData;
            });
          },
        ),
        showData
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  groupSection("Users", widget.group.users, 3),
                  groupSection("Files", widget.group.files, 5)
                ],
              )
            : const SizedBox()
      ],
    );
  }

  Widget groupSection(String title, List<dynamic> objects, int flex) {
    bool isSmall = false;
    double fontSize = 20;

    if (context.isPhone) {
      isSmall = true;
      fontSize = 15;
    } else if (context.isTablet) {
      isSmall = true;
      fontSize = 18;
    } else if (context.isDesktop) {
      isSmall = false;
      fontSize = 20;
    } else if (context.isHiRes) {
      isSmall = false;
      fontSize = 22;
    }

    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.saira(
                          fontSize: fontSize, color: Colors.white),
                    ),
                    isSmall
                        ? const Icon(Icons.add, color: Colors.white)
                        : ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                primary: const Color(0xffE2E2E2)),
                            child: Row(
                              children: [
                                const Icon(Icons.add, color: Colors.black),
                                Text(
                                  "Add",
                                  style: GoogleFonts.saira(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                ),
                itemCount: objects.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Card(
                      child: Text(
                        objects[index],
                        style: GoogleFonts.lato(fontSize: fontSize / 1.2),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
