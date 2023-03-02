import 'package:gen_crm/widgets/widgets.dart';
import 'package:flutter/material.dart';

class DetailContainer extends StatelessWidget {
  final Widget child;
  final Widget? bottom;
  final String? icon, message;
  final GlobalKey<ScaffoldState>? drawerKey;

  DetailContainer({required this.child, this.drawerKey, this.icon, this.bottom, this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WidgetHeaderBar(
              title: message!,
              icon: icon,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(23.0, 0.0, 23.0, 0),
                child: child,
              ),
              flex: 7,
            ),
            bottom ?? Container()
          ],
        ),
      ),
    );
  }
}
