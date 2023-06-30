import 'package:flutter/material.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:url_launcher/url_launcher.dart';
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
  bool _status = false;

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
                launchInBrowser(Uri.parse(widget.file.link ?? ''));

                setState(() {
                  _status = true;
                });
              },
              child: !_status
                  ? Icon(
                      Icons.download,
                      color: COLORS.BLACK,
                    )
                  : Icon(
                      Icons.done,
                      color: Colors.green,
                    )),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () => widget.functionMy(),
            child: WidgetContainerImage(
              image: ICONS.IC_DELETE_PNG,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
          )
        ],
      ),
    );
  }
}

Future<void> launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $url');
  }
}
