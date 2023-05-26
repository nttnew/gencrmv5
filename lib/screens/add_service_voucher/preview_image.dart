import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gen_crm/src/models/model_generator/file_response.dart';
import 'package:photo_view/photo_view.dart';
import '../../src/src_index.dart';
import '../../widgets/appbar_base.dart';
import '../../widgets/item_download.dart';

class PreviewImage extends StatefulWidget {
  const PreviewImage({
    Key? key,
    required this.file,
    this.isNetwork = false,
  }) : super(key: key);
  final File file;
  final bool isNetwork;

  @override
  State<PreviewImage> createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppbarBaseNormal('Preview image'),
      body: Center(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.grey,
              child: widget.isNetwork
                  ? PhotoView(imageProvider: NetworkImage(widget.file.path))
                  : PhotoView(imageProvider: FileImage(widget.file)),
            ),
            if (widget.isNetwork)
              Positioned(
                  right: 26,
                  bottom: 50,
                  child: ItemDownload(
                    file: FileDataResponse(link: widget.file.path),
                  )),
          ],
        ),
      ),
    );
  }
}
