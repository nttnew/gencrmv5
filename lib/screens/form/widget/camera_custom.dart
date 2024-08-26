import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../../../src/app_const.dart';
import '../../../../src/color.dart';
import '../../../../widgets/cupertino_loading.dart';

class CameraCustom extends StatefulWidget {
  @override
  _CameraCustomState createState() => _CameraCustomState();
}

class _CameraCustomState extends State<CameraCustom> {
  CameraController? controller;
  List<CameraDescription>? cameras;
  bool isCameraReady = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    controller = CameraController(
      cameras![0],
      ResolutionPreset.high,
      enableAudio: false,
    );
    await controller!.initialize();
    setState(() {
      isCameraReady = true;
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> captureImage() async {
    try {
      final data = await controller!.takePicture();
      Navigator.pop(context,
          data.path); // Trả về đường dẫn ảnh sau khi chụp và trở về màn hình trước
    } catch (e) {
      Navigator.pop(context);
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isCameraReady) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: CupertinoLoading(),
        ),
      );
    }
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Center(
          child: Transform.scale(
            scale: 1.2,
            child: CameraPreview(controller!),
          ),
        ),
        iconBackBlur(),
        GestureDetector(
          onTap: () {
            captureImage();
          },
          child: Container(
            height: MediaQuery.of(context).size.width / 6,
            width: MediaQuery.of(context).size.width / 6,
            margin: EdgeInsets.only(bottom: 48),
            decoration: BoxDecoration(
              color: COLORS.WHITE,
              shape: BoxShape.circle,
              boxShadow: boxShadow1,
            ),
          ),
        )
      ],
    );
  }
}
