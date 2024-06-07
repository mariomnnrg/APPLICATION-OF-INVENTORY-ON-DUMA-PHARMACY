import 'package:aplikasi/functions/auth/logout.dart';
import 'package:aplikasi/page/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar TopBar(BuildContext context,
    {String title = 'Inventori Apotek Duma',
    List<Widget> actions = const [],
    Widget? lead,
    TabBar? tabBar}) {
  return AppBar(
    title: Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottom: tabBar,
    actions: (actions.isNotEmpty)
        ? actions
        : [
            IconButton(
                onPressed: () async {
                  if (await Logout()) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                      (Route<dynamic> route) => false,
                    );
                  } else {
                    showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                              title: const Text("Failed to logout"),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: const Text("OK"))
                              ],
                            ));
                  }
                },
                icon: const Icon(Icons.logout))
          ],
    leading: lead,
  );
}
