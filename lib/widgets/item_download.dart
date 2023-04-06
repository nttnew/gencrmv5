import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/src/models/model_generator/file_response.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

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
  final String _localPath = '/storage/emulated/0/Download/';
  late final BehaviorSubject<String> _status;
  late final dio;

  @override
  void initState() {
    super.initState();
    dio = Dio();
    _status = BehaviorSubject.seeded('0%');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: _status,
        builder: (context, snapshot) {
          final status = snapshot.data ?? '';
          return GestureDetector(
            onTap: () async {
              if (status == '0%') {
                if (Platform.isAndroid) {
                  String name = widget.file.link.toString().split('/').last;
                  String localPath = '';
                  if (Platform.isAndroid) {
                    localPath = _localPath;
                  } else {
                    final tempDir = await getApplicationDocumentsDirectory();
                    localPath = tempDir.path;
                  }
                  String fullPath = localPath + name;
                  download2(dio, widget.file.link.toString(), fullPath);
                } else {
                  _status.add('100%');
                  launchUrlBase(widget.file.link ?? "");
                }
              }
            },
            child: status == '0%'
                ? Icon(
                    Icons.download,
                    color: widget.colors ?? Colors.white,
                  )
                : status == '100%'
                    ? Icon(
                        Icons.done,
                        color: Colors.green,
                      )
                    : WidgetText(title: status),
          );
        });
  }

  Future download2(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      _status.add((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  @override
  void dispose() {
    _status.close();
    super.dispose();
  }
}
