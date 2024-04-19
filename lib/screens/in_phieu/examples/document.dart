import 'package:htmltopdfwidgets/htmltopdfwidgets.dart';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../data.dart';

Future<Uint8List> generateDocument(PdfPageFormat format, String data) async {
  final doc = pw.Document(
      // pageMode: PdfPageMode.outlines,
      );
  String body = '''
<h1>Đỗ đức doanh</h1>
  <p>This is a paragraph.</p>
  <img src="image.jpg" alt="Example Image" />
  <blockquote>This is a quote.</blockquote>
  <ul>
    <li>First item</li>
    <li>Second item</li>
    <li>Third item</li>
  </ul>''';

  final widgets = await HTMLToPdf().convert(body);
  doc.addPage(pw.MultiPage(build: (context) => widgets));

  final font1 = true
      ? pw.Font.helvetica()
      : await PdfGoogleFonts.openSansRegular();
  final font2 = true
      ? pw.Font.helveticaBold()
      : await PdfGoogleFonts.openSansBold();

  return await doc.save();
}
