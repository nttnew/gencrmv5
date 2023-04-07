import 'package:flutter/material.dart';

class NewsScreen extends StatefulWidget {
  final bool? isBack;

  const NewsScreen({Key? key, this.isBack}) : super(key: key);
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text("new"),
        ),
      ),
    );
  }
}
