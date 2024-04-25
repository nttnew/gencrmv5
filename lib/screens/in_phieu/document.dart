// import 'package:flutter/services.dart';
// import 'package:htmltopdfwidgets/htmltopdfwidgets.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
//
// Future<Uint8List> generateDocument(PdfPageFormat format, String data) async {
//   final font = await PdfGoogleFonts.nunitoLight();
//   final fontBold = await PdfGoogleFonts.nunitoBold();
//   final fontItalic = await PdfGoogleFonts.nunitoLightItalic();
//   final fontItalicBold = await PdfGoogleFonts.nunitoBoldItalic();
//
//   final doc = pw.Document();
//
//   final widgets = await HTMLToPdf().convert(
//     data,
//   );
//
//   doc.addPage(
//     pw.MultiPage(
//       theme: pw.ThemeData.withFont(
//         base: font,
//         bold: fontBold,
//         italic: fontItalic,
//         boldItalic: fontItalicBold,
//       ),
//       build: (context) => widgets,
//     ),
//   );
//
//   return await doc.save();
// }
