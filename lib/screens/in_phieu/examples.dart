import 'dart:async';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'data.dart';
import 'examples/document.dart';

// const examples = <Example>[
//   Example('DOCUMENT', 'document.dart', generateDocument),
// ];

typedef LayoutCallbackWithData = Future<Uint8List> Function(
  PdfPageFormat pageFormat,
  String data,
);

class Example {
  const Example(this.name, this.file, this.builder, [this.needsData = false]);

  final String name;

  final String file;

  final LayoutCallbackWithData builder;

  final bool needsData;
}
