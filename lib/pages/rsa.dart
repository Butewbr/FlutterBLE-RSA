import 'package:flutter/material.dart';

class rsaGenPage extends StatefulWidget {
  const rsaGenPage({super.key});

  @override
  State<rsaGenPage> createState() => rsaGenPageState();
}

class rsaGenPageState extends State<rsaGenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('LabSEC machinery',
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
            )),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        elevation: 0,
      ),
      body: Text('this is your key!'),
    );
  }
}
