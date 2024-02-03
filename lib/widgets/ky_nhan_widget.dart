import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/widget_text.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import '../../l10n/key_text.dart';
import '../src/models/model_generator/add_customer.dart';

class KyNhan extends StatefulWidget {
  const KyNhan({
    Key? key,
    required this.data,
    required this.listPoint,
  }) : super(key: key);
  final ChuKyModelResponse? data;
  final List<Point>? listPoint;
  @override
  State<KyNhan> createState() => _KyNhanState();
}

class _KyNhanState extends State<KyNhan> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 2,
    penColor: COLORS.BLACK,
    exportBackgroundColor: Colors.transparent,
    exportPenColor: COLORS.BLACK,
    onDrawStart: () {},
    onDrawEnd: () {},
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {});
    if (widget.listPoint != null) _controller.value = widget.listPoint ?? [];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> exportImage(BuildContext context) async {
    if (_controller.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(getT(KeyT.you_have_not_done_the_sign_yet)),
        ),
      );
      return;
    }

    final Uint8List? data = await _controller.toPngBytes(
        height: 300,
        width:
            int.tryParse((MediaQuery.of(context).size.width - 80).toString()));
    if (data == null) {
      return;
    }

    if (!mounted) return;
    final imageData =
        await _controller.toPngBytes(); // must be called in async method
    var imageEncoded = base64.encode(imageData!); // returns base64 string

    _controller.toPngBytes().then((data) {
      imageEncoded = base64.encode(data!);
    });
    List<Point> exportedPoints = _controller.points;

    Navigator.pop(context, [
      ChuKyModelResponse(
        widget.data?.doituongky,
        widget.data?.nhanhienthi,
        widget.data?.giatrimacdinh,
        imageEncoded,
        widget.data?.id,
      ),
      exportedPoints
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.only(
              bottom: 15,
            ),
            child: WidgetText(
              title:
                  '${getT(KeyT.electronic_signature)}: ${widget.data?.nhanhienthi}',
              style: AppStyle.DEFAULT_18_BOLD,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              border: Border.all(color: COLORS.ffBEB4B4),
              borderRadius: BorderRadius.all(Radius.circular(6))),
          child: Signature(
            key: const Key('signature'),
            controller: _controller,
            height: 300,
            width: MediaQuery.of(context).size.width - 80,
            backgroundColor: Colors.grey.withOpacity(0.1),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            //SHOW EXPORTED IMAGE IN NEW ROUTE
            _buttonKyNhan(() => exportImage(context),
                '${getT(KeyT.done)}',
                color: COLORS.TEXT_COLOR, textColor: COLORS.WHITE),
            _buttonKyNhan(
              () {
                setState(() => _controller.clear());
              },
              '${getT(KeyT.sign_again)}',
              textColor: COLORS.WHITE,
              color: COLORS.RED,
            ),
            _buttonKyNhan(() {
              setState(() => Get.back());
            }, '${getT(KeyT.close)}'),
          ],
        ),
      ],
    );
  }

  Widget _buttonKyNhan(
    Function() onTap,
    String textBtn, {
    Color? color,
    Color? textColor,
  }) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        margin: EdgeInsets.only(left: 8, top: 15),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: color ?? COLORS.WHITE,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: color ?? textColor ?? COLORS.TEXT_COLOR,
            )),
        child: WidgetText(
            title: textBtn,
            style: TextStyle(
              fontFamily: "Quicksand",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor ?? COLORS.TEXT_COLOR,
            )),
      ),
    );
  }
}
