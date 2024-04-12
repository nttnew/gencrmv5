import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gen_crm/l10n/key_text.dart';
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../src/app_const.dart';
import '../../src/color.dart';

/// Represents InPhieuScreen for Navigation
class InPhieuScreen extends StatefulWidget {
  @override
  _InPhieuScreen createState() => _InPhieuScreen();
}

class _InPhieuScreen extends State<InPhieuScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            isCarCrm() ? COLORS.PRIMARY_COLOR1 : COLORS.PRIMARY_COLOR,
        title: Text(
          getT(
            KeyT.in_phieu,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Colors.white,
            ),
            onPressed: () {
              _pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            isCarCrm() ? COLORS.PRIMARY_COLOR1 : COLORS.PRIMARY_COLOR,
        child: const Icon(
          Icons.print,
          color: Colors.white,
        ),
        onPressed: () async {
          String pdfUrl = 'http://www.pdf995.com/samples/pdf.pdf';

          await Printing.layoutPdf(
            onLayout: (_) async {
              // Tải dữ liệu của tệp PDF từ đường dẫn trên mạng
              final pdfData =
                  await NetworkAssetBundle(Uri.parse(pdfUrl)).load(pdfUrl);

              // Trả về dữ liệu PDF để in
              return pdfData.buffer.asUint8List();
            },
          );
        },
      ),
      body: SfPdfViewer.network(
        'http://www.pdf995.com/samples/pdf.pdf',
        key: _pdfViewerKey,
      ),
    );
  }
}
