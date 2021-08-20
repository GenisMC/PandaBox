import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerMain extends StatelessWidget {
  const DrawerMain({Key? key}) : super(key: key);

  final double labelSize = 20;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 2,
      child: ListView(
        children: [
          DrawerHeader(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.account_circle_rounded,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Panda Wheezes",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          )),
          listTileBP(Icons.home, "Home", context, "/"),
          listTileBP(Icons.upload_rounded, "Upload", context, "/upload"),
          listTileBP(Icons.map_rounded, "Discover", context, "/discover"),
          listTileBP(Icons.group_rounded, "Groups", context, "/groups"),
          listTileBP(Icons.settings, "Settings", context, "/settings"),
        ],
      ),
    );
  }

  Widget listTileBP(
      IconData icon, String text, BuildContext context, String route) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
            child: Icon(icon, color: Colors.white, size: labelSize * 1.5),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style:
                  GoogleFonts.saira(color: Colors.white, fontSize: labelSize),
            ),
          ),
          const Spacer(),
        ],
      ),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      hoverColor: const Color(0xffDB3030),
    );
  }
}
