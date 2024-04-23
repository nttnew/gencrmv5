import 'package:flutter/services.dart';
import 'package:htmltopdfwidgets/htmltopdfwidgets.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../menu/home/customer/widget/item_note.dart';

Future<Uint8List> generateDocument(PdfPageFormat format, String data) async {
  var myTheme = pw.ThemeData.withFont(
    base: pw.Font.ttf(await rootBundle.load("assets/fonts/Open_Sans/static/OpenSans-Bold.ttfs")),
  );

  final pw.Document _pdf = pw.Document(theme: myTheme);
  final doc = pw.Document(theme: myTheme);
  String body = '''
  
<h1>Đỗ đức doanh မြန်မာဘာသာ</h1>
<p>This is a paragraph.</p>
<blockquote>This is a quote.</blockquote>
<ul>
  <li>First item</li>
  <li>Second item</li>
  <li>Third item</li>//todo
</ul>''';

  final widgets = await HTMLToPdf().convert(
    body,
  );
  doc.addPage(
    pw.MultiPage(
      theme: pw.ThemeData.withFont(
        base: Font.ttf(await rootBundle
            .load("assets/fonts/Open_Sans/static/OpenSans-Bold.ttf")),
      ),
      build: (context) => widgets,
    ),
  );

  return await doc.save();
}
