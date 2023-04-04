import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/widgets/widget_text.dart';

import '../src/models/model_generator/file_response.dart';
import '../src/src_index.dart';

class ItemFile extends StatefulWidget {
  const ItemFile({Key? key, required this.file, required this.functionMy})
      : super(key: key);
  final FileDataResponse file;
  final Function() functionMy;
  @override
  State<ItemFile> createState() => _ItemFileState();
}

class _ItemFileState extends State<ItemFile> {
  final String _localPath = '/storage/emulated/0/Download/';
  late final String _status;
  late final dio;

  @override
  void initState() {
    dio = Dio();
    _status = '0%';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: WidgetText(
              title: widget.file.name,
              style: AppStyle.DEFAULT_14,
              maxLine: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () {
              String name = widget.file.link.toString().split('/').last;
              String fullPath = _localPath + '/' + name;
              download2(dio, widget.file.link.toString(), fullPath);
            },
            child: _status == '0%'
                ? Icon(
                    Icons.download,
                    color: Colors.black,
                  )
                : _status == '100%'
                    ? Icon(
                        Icons.done,
                        color: Colors.green,
                      )
                    : WidgetText(title: _status),
          ),
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () => widget.functionMy(),
            child: WidgetContainerImage(
              image: 'assets/icons/icon_delete.png',
              width: 20,
              height: 20,
              fit: BoxFit.contain,
            ),
          )
        ],
      ),
    );
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
      _status = ((received / total * 100).toStringAsFixed(0) + "%");
      print(_status);
      setState(() {});
    }
  }
}
