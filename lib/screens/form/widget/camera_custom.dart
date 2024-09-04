import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/src/icon_constants.dart';
import '../../../../src/app_const.dart';
import '../../../../src/color.dart';
import '../../../../widgets/cupertino_loading.dart';
import '../../../widgets/pick_file_image.dart';

class CameraCustom extends StatefulWidget {
  @override
  _CameraCustomState createState() => _CameraCustomState();
}

class _CameraCustomState extends State<CameraCustom> {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  bool isCameraReady = false;
  int selectedCameraIdx = 0;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  void switchCamera() {
    selectedCameraIdx = selectedCameraIdx == 0 ? 1 : 0;
    _cameraController = CameraController(
      cameras![selectedCameraIdx],
      ResolutionPreset.high,
    );

    _cameraController!.initialize().then((_) {
      setState(() {});
    });
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(
      cameras![0],
      ResolutionPreset.high,
      enableAudio: false,
    );
    await _cameraController!.initialize();
    setState(() {
      isCameraReady = true;
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> captureImage() async {
    try {
      final data = await _cameraController!.takePicture();
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
            child: CameraPreview(_cameraController!),
          ),
        ),
        iconBackBlur(),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.only(
              bottom: 48,
              left: 32,
              right: 32,
              top: 24,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
              color: COLORS.BLACK.withOpacity(0.3),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () async {
                    final result = await getImageOne();
                    if (result != null) {
                      Navigator.pop(
                          context,
                          result
                              .path); // Trả về đường dẫn ảnh sau khi chụp và trở về màn hình trước
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    height: MediaQuery.of(context).size.width / 6,
                    width: MediaQuery.of(context).size.width / 6,
                    child: Image.asset(
                      ICONS.IC_GALLERY_PNG,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    captureImage();
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.width / 6,
                    width: MediaQuery.of(context).size.width / 6,
                    decoration: BoxDecoration(
                      color: COLORS.WHITE,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    switchCamera();
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    height: MediaQuery.of(context).size.width / 6,
                    width: MediaQuery.of(context).size.width / 6,
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: COLORS.BLACK.withOpacity(0.3),
                      ),
                      child: Image.asset(
                        ICONS.IC_CHANGE_CAMERA_PNG,
                        color: COLORS.WHITE,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
