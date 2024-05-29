import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.scanner,
                          size: 25,
                          color: Colors.grey,
                        ),
                        Text("scan")
                      ],
                    ),
                    onTap: () {},
                  ),
                  InkWell(
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.document_scanner,
                          size: 25,
                          color: Colors.grey,
                        ),
                        Text("recognize")
                      ],
                    ),
                    onTap: () {},
                  ),
                  InkWell(
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_sharp,
                          size: 25,
                          color: Colors.grey,
                        ),
                        Text("enhance")
                      ],
                    ),
                    onTap: () {},
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
                    onTap: () {},
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
