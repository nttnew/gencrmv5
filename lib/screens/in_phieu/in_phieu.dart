import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gen_crm/l10n/key_text.dart';
import 'package:get/get.dart';
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
  final String link = Get.arguments[0];
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
          String pdfUrl = link;

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
        link,
        key: _pdfViewerKey,
      ),
    );
  }
}
//
// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:url_launcher/url_launcher.dart' as ul;
//
// import 'data.dart';
// import 'examples.dart';
// import 'examples/document.dart';
//
// class InPhieuScreen extends StatefulWidget {
//   const InPhieuScreen({Key? key}) : super(key: key);
//
//   @override
//   InPhieuScreenState createState() {
//     return InPhieuScreenState();
//   }
// }
//
// class InPhieuScreenState extends State<InPhieuScreen>
//     with SingleTickerProviderStateMixin {
//   int _tab = 0;
//   TabController? _tabController;
//   final String dataHTML = Get.arguments[0];
//   PrintingInfo? printingInfo;
//
//   // var _data = const CustomData();
//   var _hasData = false;
//   var _pending = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _init();
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//   }
//
//   Example example = Example('DOCUMENT', 'document.dart', generateDocument);
//
//   Future<void> _init() async {
//     final info = await Printing.info();
//
//     _tabController = TabController(
//       vsync: this,
//       length: 1,
//       initialIndex: _tab,
//     );
//     _tabController!.addListener(() {
//       if (_tab != _tabController!.index) {
//         setState(() {
//           _tab = _tabController!.index;
//         });
//       }
//       if (!_hasData && !_pending) {
//         _pending = true;
//         askName(context).then((value) {
//           if (value != null) {
//             setState(() {
//               // _data = CustomData(name: value);
//               _hasData = true;
//               _pending = false;
//             });
//           }
//         });
//       }
//     });
//
//     setState(() {
//       printingInfo = info;
//     });
//   }
//
//   void _showPrintedToast(BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Document printed successfully'),
//       ),
//     );
//   }
//
//   void _showSharedToast(BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Document shared successfully'),
//       ),
//     );
//   }
//
//   Future<void> _saveAsFile(
//     BuildContext context,
//     LayoutCallback build,
//     PdfPageFormat pageFormat,
//   ) async {
//     final bytes = await build(pageFormat);
//
//     final appDocDir = await getApplicationDocumentsDirectory();
//     final appDocPath = appDocDir.path;
//     final file = File('$appDocPath/document.pdf');
//     print('Save as file ${file.path} ...');
//     await file.writeAsBytes(bytes);
//     await OpenFile.open(file.path);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     pw.RichText.debug = true;
//
//     if (_tabController == null) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     final actions = <PdfPreviewAction>[
//       if (!kIsWeb)
//         PdfPreviewAction(
//           icon: const Icon(Icons.save),
//           onPressed: _saveAsFile,
//         )
//     ];
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Flutter PDF Demo'),
//       ),
//       body: PdfPreview(
//         maxPageWidth: 700,
//         build: (format) => example.builder(format, dataHTML),
//         actions: actions,
//         onPrinted: _showPrintedToast,
//         onShared: _showSharedToast,
//       ),
//     );
//   }
//
//   Future<String?> askName(BuildContext context) {
//     return showDialog<String>(
//         barrierDismissible: false,
//         context: context,
//         builder: (context) {
//           final controller = TextEditingController();
//
//           return AlertDialog(
//             title: const Text('Please type your name:'),
//             contentPadding: const EdgeInsets.symmetric(horizontal: 20),
//             content: TextField(
//               decoration: const InputDecoration(hintText: '[your name]'),
//               controller: controller,
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   if (controller.text != '') {
//                     Navigator.pop(context, controller.text);
//                   }
//                 },
//                 child: const Text('OK'),
//               ),
//             ],
//           );
//         });
//   }
// }
//
// import 'dart:io';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:printing/printing.dart';
// import 'package:html/parser.dart';
//
// class InPhieuScreen extends StatefulWidget {
//   const InPhieuScreen({Key? key}) : super(key: key);
//
//   @override
//   State<InPhieuScreen> createState() => _PrintScreenState();
// }
//
// class _PrintScreenState extends State<InPhieuScreen> {
//   final pdf = pw.Document();
//
//   String body = '''
//   <h1>Hà Ngọc lực</h1>
//    <h2>Hà Ngọc lực</h2>
//   ''';
//
//   String _parseHtmlString(String htmlString) {
//     final document = parse(htmlString);
//     final String? parsedString =
//         parse(document.body?.text).documentElement?.text;
//
//     return parsedString ?? '';
//   }
//
//   Future<Uint8List> generaxtePdf(PdfPageFormat format, String title) async {
//     final pdf = pw.Document(
//         // version: PdfVersion.pdf_1_5, compress: true
//     );
//     final font = await PdfGoogleFonts.nunitoExtraLight();
//
//     // Chuyển đổi widget Flutter thành widget PDF
//     pdf.addPage(pw.Page(
//         pageFormat: format,
//         build: (context) {
//           return pw.Column(children: [
//             pw.SizedBox(
//                 width: double.infinity,
//                 child: pw.FittedBox(
//                   child: pw.Text(_parseHtmlString(title),
//                       style: pw.TextStyle(font: font)),
//                 )),
//             // pw.SizedBox(height: 20),
//             // pw.Flexible(child: pw.FlutterLogo())
//           ]);
//         },
//         orientation: pw.PageOrientation.landscape));
//     // pdf.addPage(
//     //   pw.Page(
//     //     build: (pw.Context context) => pw.Center(
//     //       child: pw.Html(
//     //         data: body,
//     //       ),
//     //     ),
//     //   ),
//     // );
//     return pdf.save();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: PdfPreview(
//         build: (format) {
//           return generaxtePdf(format, body);
//         },
//       ),
//       // home: Stack(
//       //   fit: StackFit.expand,
//       //   children: [
//       //     ImageFiltered(
//       //       imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
//       //       child: FlutterLogo(),
//       //     ),
//       //     Center(
//       //       child: FlutterLogo(),
//       //     )
//       //   ],
//       // ),
//     );
//   }
// }
