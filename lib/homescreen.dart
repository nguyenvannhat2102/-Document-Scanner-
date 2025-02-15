import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scanapp/CardScanner.dart';
import 'package:scanapp/recognizerscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ImagePicker imagePicker;
  late List<CameraDescription> _cameras;
  late CameraController controller;
  bool scan = false;
  bool recognize = true;
  bool enhance = false;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    initializeCamera();
  }

  bool isInit = false;
  Future initializeCamera() async {
    _cameras = await availableCameras();
    controller = CameraController(_cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        isInit = true;
      });
    });
  }

  processImage(File image) async {
    final editedImage = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageCropper(
          image: image.readAsBytesSync(), //Uint8List of image
        ),
      ),
    );
    image.writeAsBytes(editedImage);
    if (recognize) {
      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
        return RecognizerScreen(image);
      }));
    } else if (scan) {
      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
        return CardScanner(image);
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Scan App',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.scanner,
                    size: 30,
                    color: scan ? Colors.blue : Colors.black,
                  ),
                  // Text(
                  //   'Scan',
                  //   style: TextStyle(
                  //     color: scan ? Colors.blue : Colors.black,
                  //   ),
                  // )
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
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.document_scanner,
                    size: 30,
                    color: recognize ? Colors.blue : Colors.black,
                  ),
                  // Text(
                  //   'Recognize',
                  //   style: TextStyle(
                  //     color: recognize ? Colors.blue : Colors.black,
                  //   ),
                  // )
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
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Card(
              color: Colors.black,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 300,
                      child: isInit
                          ? AspectRatio(
                              aspectRatio: controller.value.aspectRatio,
                              child: CameraPreview(controller),
                            )
                          : Container(),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 300,
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      "assets/f1.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    height: 2,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.all(20),
                  ).animate(onPlay: (controller) => controller.repeat()).moveY(
                      begin: 0,
                      end: MediaQuery.of(context).size.height - 320,
                      duration: 2000.ms)
                ],
              ),
            ),
            Card(
              color: Colors.white,
              child: SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      child: const Icon(
                        Icons.rotate_left,
                        size: 35,
                        color: Colors.black,
                      ),
                      onTap: () {},
                    ),
                    InkWell(
                      child: const Icon(
                        Icons.camera,
                        size: 50,
                        color: Colors.black,
                      ),
                      onTap: () async {
                        await controller.takePicture().then((value) {
                          if (value != null) {
                            File image = File(value.path);
                            processImage(image);
                          }
                        });
                      },
                    ),
                    InkWell(
                      child: const Icon(
                        Icons.image_outlined,
                        size: 35,
                        color: Colors.black,
                      ),
                      onTap: () async {
                        XFile? xfile = await imagePicker.pickImage(
                            source: ImageSource.gallery);
                        if (xfile != null) {
                          File image = File(xfile.path);
                          processImage(image);
                        }
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
