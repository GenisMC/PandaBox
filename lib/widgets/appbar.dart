import 'package:codepandas/Services/provider.dart';
import 'package:codepandas/Extensions/device_check.dart';
import 'package:codepandas/Components/Icons/panda_icon_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderService>(context);

    double titleSize = 20;

    bool hideText = false;

    if (context.isPhone) {
      titleSize = 20;
      hideText = true;
    } else if (context.isTablet) {
      titleSize = 25;
      hideText = true;
    } else {
      titleSize = 40;
      hideText = false;
    }

    return AppBar(
      title: Material(
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/');
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  PandaIcon.foodpanda,
                  color: Colors.black,
                  size: titleSize,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("PANDABOX",
                    style: GoogleFonts.rubikMonoOne(
                        fontSize: titleSize, color: Colors.white)),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
      centerTitle: true,
      actions: [
        provider.userIn == false
            ? hideText
                ? IconButton(
                    onPressed: () async {
                      await provider.authService.signInwithGoogle();
                    },
                    icon: const Icon(Icons.login_rounded))
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: const Color(0xffDB3030)),
                    onPressed: () async {
                      await provider.authService.signInwithGoogle();
                    },
                    child: const Text("Log In"))
            : hideText
                ? IconButton(
                    onPressed: () async {
                      await provider.authService.signOutFromGoogle();
                    },
                    icon: const Icon(Icons.login_rounded))
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: const Color(0xffDB3030)),
                    onPressed: () async {
                      await provider.authService.signOutFromGoogle();
                    },
                    child: const Text("Log Out"))
      ],
      leading: provider.userIn == false ? Container() : null,
      backgroundColor: const Color(0xffF64747),
    );
  }
}
