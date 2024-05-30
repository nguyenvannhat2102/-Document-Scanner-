import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scanapp/recognizerscreen.dart';
import 'package:scanapp/scanscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ImagePicker imagePicker;
  bool scan = false;
  bool recognize = true;
  bool enhance = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 50, bottom: 15, left: 5, right: 5),
      child: Column(
        children: [
          Card(
            child: Container(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.scanner,
                          size: 25,
                          color: scan ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          "scan",
                          style: TextStyle(
                            color: scan ? Colors.blue : Colors.grey,
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        scan = true;
                        recognize = false;
                        enhance = false;
                      });
                    },
                  ),
                  InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.document_scanner,
                          size: 25,
                          color: recognize ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          "recognize",
                          style: TextStyle(
                            color: recognize ? Colors.blue : Colors.grey,
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        scan = false;
                        recognize = true;
                        enhance = false;
                      });
                    },
                  ),
                  InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_sharp,
                          size: 25,
                          color: enhance ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          "enhance",
                          style: TextStyle(
                            color: enhance ? Colors.blue : Colors.grey,
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        scan = false;
                        recognize = false;
                        enhance = true;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Card(
            color: Colors.black,
            child: Container(
              height: MediaQuery.of(context).size.height - 300,
            ),
          ),
          Card(
            child: Container(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    child: const Icon(
                      Icons.rotate_left,
                      size: 45,
                      color: Colors.grey,
                    ),
                    onTap: () {},
                  ),
                  InkWell(
                    child: const Icon(
                      Icons.camera,
                      size: 50,
                      color: Colors.grey,
                    ),
                    onTap: () {},
                  ),
                  InkWell(
                    child: const Icon(
                      Icons.image_outlined,
                      size: 45,
                      color: Colors.grey,
                    ),
                    onTap: () async {
                      XFile? xFile = await imagePicker.pickImage(
                          source: ImageSource.gallery);
                      if (xFile != null) {
                        File image = File(xFile.path);
                        if (recognize) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return RecognizerScreen(image);
                              },
                            ),
                          );
                        } else if (scan) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ScanScreen(image);
                              },
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
