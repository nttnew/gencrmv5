import 'package:flutter/material.dart';

import '../../../src/src_index.dart';
import '../../../widgets/widgets.dart';

class AttachmentItem extends StatelessWidget {
  AttachmentItem({this.fileType, this.filePath, this.onDelete});
  String? fileType;
  String? filePath;
  Function()? onDelete;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.feed_outlined,
            size: AppValue.FONT_SIZE_20,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: WidgetText(
              title: filePath,
              style: AppStyle.DEFAULT_14,
              maxLine: 3,
              overflow: TextOverflow.visible,
            ),
          ),
          SizedBox(
            width: 12,
          ),
          GestureDetector(
            onTap: onDelete,
            child: Icon(Icons.delete_outline),
          )
        ],
      ),
    );
    // TODO: implement build
    throw UnimplementedError();
  }
}
