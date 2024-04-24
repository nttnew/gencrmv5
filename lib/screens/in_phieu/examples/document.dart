import 'package:flutter/services.dart';
import 'package:htmltopdfwidgets/htmltopdfwidgets.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../menu/home/customer/widget/item_note.dart';

Future<Uint8List> generateDocument(PdfPageFormat format, String data) async {
  var myTheme = pw.ThemeData.withFont(
      // base: pw.Font.ttf(await rootBundle.load("assets/fonts/Open_Sans/static/OpenSans-Bold.ttfs")),
      );

  final pw.Document _pdf = pw.Document(theme: myTheme);
  final doc = pw.Document(theme: myTheme);
  String body = '''
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>HTML Tiếng Việt</title>
</head>
<body>
  <h1>Tiếng Việt</h1>
  <p>Đây là một đoạn văn bản tiếng Việt.</p>
</body>
</html>
''';

  final widgets = await HTMLToPdf().convert(
    body,
  );
  doc.addPage(
    pw.MultiPage(
      // theme: pw.ThemeData.withFont(
      //   base: Font.ttf(await rootBundle
      //       .load("assets/fonts/Open_Sans/static/OpenSans-Bold.ttf")),
      // ),
      build: (context) => widgets,
    ),
  );

  return await doc.save();
}
