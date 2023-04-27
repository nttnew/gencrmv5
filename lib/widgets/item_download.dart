import 'package:flutter/material.dart';
import 'package:gen_crm/src/models/model_generator/file_response.dart';

import 'item_file.dart';

class ItemDownload extends StatefulWidget {
  const ItemDownload({
    Key? key,
    required this.file,
    this.colors,
  }) : super(key: key);
  final FileDataResponse file;
  final Color? colors;

  @override
  State<ItemDownload> createState() => _ItemDownloadState();
}

class _ItemDownloadState extends State<ItemDownload> {
  bool isWeb = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          launchInBrowser(Uri.parse(widget.file.link ?? ""));
          setState(() {
            isWeb = true;
          });
        },
        child: !isWeb
            ? Icon(
                Icons.download,
                color: widget.colors ?? Colors.white,
              )
            : Icon(
                Icons.done,
                color: Colors.green,
              ));
  }
}
