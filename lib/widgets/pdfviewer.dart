import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PdfViewer extends StatelessWidget {
  final String? pdfUrl;

  const PdfViewer(this.pdfUrl, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // String? pdfUrl = docSnapshot?.data()?.values.toList()[0].toString();
    if (kDebugMode) {
      print("pdfUrl => $pdfUrl");
    }
    return Scaffold(
      appBar: AppBar(
          title: Text(''),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back))),
      body: FutureBuilder<PDFDocument?>(
        builder: (_, snapshot) {
          if (snapshot.data == null) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            if (kDebugMode) {
              print("EXCEPTION => ${snapshot.error}");
            }
          }

          if (snapshot.requireData == null) {
            return const Center(
              child: Text("No cv available for this user"),
            );
          }
          return Center(
            child: PDFViewer(document: snapshot.requireData!),
          );
        },
        future: PDFDocument.fromURL(pdfUrl!),
      ),
    );
  }
}
