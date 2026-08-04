

import 'package:flutter/material.dart';
// import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../data/app_config/app_config.dart';
import '../../models/ebook_model.dart';
class EbookReaderScreen extends StatefulWidget {
  final EbookModel ebook;

  const EbookReaderScreen({
    super.key,
    required this.ebook,
  });



  @override
  State<EbookReaderScreen> createState() => _EbookReaderScreenState();
}

class _EbookReaderScreenState extends State<EbookReaderScreen> {


  // @override
  // void initState() {
  //   super.initState();
  //
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     secureScreen();
  //   });
  // }
  //
  //
  // Future<void> secureScreen() async {
  //   if (Platform.isAndroid) {
  //     await FlutterWindowManager.addFlags(
  //       FlutterWindowManager.FLAG_SECURE,
  //     );
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ebook.title),
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Text(
                  widget.ebook.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  widget.ebook.description,
                  maxLines: 3,

                ),
              ],
            ),
          ),

          Expanded(
            child: SfPdfViewer.network(
              "${AppConfig.pdfBaseUrl}${widget.ebook.pdfFile}",
            ),
          ),
        ],
      ),
    );
  }
}