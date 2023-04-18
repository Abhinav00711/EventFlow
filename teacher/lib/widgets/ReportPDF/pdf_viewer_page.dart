import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
class PdfViewerPage extends StatelessWidget {
  final String path;
  const PdfViewerPage({required this.path}) ;

  @override
  Widget build(BuildContext context) {
    return PDFView(
      filePath: path,
    );
  }
}