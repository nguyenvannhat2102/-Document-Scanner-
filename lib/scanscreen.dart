import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mlkit_entity_extraction/google_mlkit_entity_extraction.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ScanScreen extends StatefulWidget {
  File image;
  ScanScreen(this.image);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  late TextRecognizer textRecognizer;
  late EntityExtractor entityExtractor;
  String result = "";
  List<EntityDM> entitiesList = [];

  @override
  void initState() {
    super.initState();
    textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    entityExtractor =
        EntityExtractor(language: EntityExtractorLanguage.english);
    doTextRecognition();
  }

  @override
  void dispose() {
    // Hủy bỏ các tài nguyên
    super.dispose();
  }

  doTextRecognition() async {
    InputImage image = InputImage.fromFile(this.widget.image);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(image);

    result = recognizedText.text;
    entitiesList.clear();

    final List<EntityAnnotation> annotations =
        await entityExtractor.annotateText(result);

    result = "";
    for (final annotation in annotations) {
      annotation.start;
      print(annotation.start);
      annotation.end;
      print(annotation.end);
      annotation.text;
      print(annotation.text);
      for (final entity in annotation.entities) {
        // entity.type;
        // entity.rawValue;
        result += entity.type.name + '\n' + annotation.text + '\n\n';
        entitiesList.add(EntityDM(entity.type.name, annotation.text));
      }
    }
    print(result);
    setState(() {
      result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
              child: Image.file(this.widget.image),
            ),
            // Image.file(this.widget.image),
            ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Container(
                    height: 70,
                    color: Colors.grey.shade300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Icon(
                            entitiesList[index].iconData,
                            size: 25,
                            color: Colors.black,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            entitiesList[index].value,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(
                                  text: entitiesList[index].value));
                              SnackBar sn =
                                  const SnackBar(content: Text('copied'));
                              ScaffoldMessenger.of(context).showSnackBar(sn);
                            },
                            child: const Icon(
                              Icons.copy,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: entitiesList.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
            ),
            // Card(
            //   margin: const EdgeInsets.all(10),
            //   color: Colors.grey.shade300,
            //   child: Column(
            //     children: [
            //       Container(
            //         padding: const EdgeInsets.all(8),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             const Icon(Icons.document_scanner),
            //             const Text(
            //               'Result',
            //               style: TextStyle(fontSize: 18),
            //             ),
            //             InkWell(
            //               onTap: () {
            //                 Clipboard.setData(ClipboardData(text: result));
            //                 SnackBar snackBar =
            //                     const SnackBar(content: Text('copied'));
            //                 ScaffoldMessenger.of(context)
            //                     .showSnackBar(snackBar);
            //               },
            //               child: const Icon(Icons.copy),
            //             ),
            //           ],
            //         ),
            //       ),
            //       Text(
            //         result,
            //         style: const TextStyle(fontSize: 18),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class EntityDM {
  String name;
  String value;
  IconData? iconData;

  EntityDM(this.name, this.value) {
    if (name == 'phone') {
      iconData = Icons.phone;
    } else if (name == 'address') {
      iconData = Icons.location_on;
    } else if (name == 'email') {
      iconData = Icons.email;
    } else if (name == 'url') {
      iconData = Icons.web;
    } else {
      iconData = Icons.ac_unit_outlined;
    }
  }
}
