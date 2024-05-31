import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            Card(
              margin: const EdgeInsets.all(10),
              color: Colors.grey.shade300,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.document_scanner),
                        const Text(
                          'Result',
                          style: TextStyle(fontSize: 18),
                        ),
                        InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: result));
                            SnackBar snackBar =
                                const SnackBar(content: Text('copied'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          },
                          child: const Icon(Icons.copy),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    result,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EntityDM {
  String name;
  String value;

  EntityDM(this.name, this.value);
}
