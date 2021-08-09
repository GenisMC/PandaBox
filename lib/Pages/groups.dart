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
              color: Colors.grey[400],
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: Center(
                  child: Text(
                widget.group.name.toUpperCase(),
                style: GoogleFonts.lato(fontSize: 20),
              ))),
          onTap: () {
            setState(() {
              showData = !showData;
            });
          },
        ),
        showData
            ? Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            "Users",
                            style: GoogleFonts.saira(fontSize: 20),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: GridView.builder(
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              itemCount: widget.group.users.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: Text(widget.group.users[index]),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            "Files",
                            style: GoogleFonts.saira(fontSize: 20),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: GridView.builder(
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              itemCount: widget.group.files.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: Text(widget.group.files[index]),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            : const SizedBox()
      ],
    );
  }
}
