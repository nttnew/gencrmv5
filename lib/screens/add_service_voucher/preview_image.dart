import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:photo_view/photo_view.dart';

import '../../src/src_index.dart';

class PreviewImage extends StatefulWidget {
  const PreviewImage({Key? key, required this.file}) : super(key: key);
  final File file;

  @override
  State<PreviewImage> createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: AppValue.heights * 0.1,
        backgroundColor: HexColor("#D0F1EB"),
        title: Text("Preview image",
            style: TextStyle(
                color: Colors.black,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w700,
                fontSize: 16)),
        leading: _buildBack(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.grey,
          child: PhotoView(
              imageProvider: FileImage(widget.file)),
        ),
      ),
    );
  }

  _buildBack() {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: Image.asset(
        ICONS.ICON_BACK,
        height: 28,
        width: 28,
        color: COLORS.BLACK,
      ),
    );
  }
}
