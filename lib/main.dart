import 'package:flutter/material.dart';
import 'package:myapp/pages/ble.dart';
import 'package:myapp/pages/rsa.dart';
import 'package:myapp/pages/sign.dart';
import 'package:myapp/pages/verify.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:typed_data';
import 'package:pointycastle/export.dart' hide State, Padding;
import 'dart:convert';

void main() => runApp(MaterialApp(initialRoute: '/home', routes: {
      '/home': (context) => Home(
            scanResultList: [],
          ),
    }));

class Home extends StatefulWidget {
  List<ScanResult> scanResultList;
  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> userPair = getEmptyKeyPair();
  String lastScanned;

  Home({required this.scanResultList, this.lastScanned = 'a'});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Uint8List signature = Uint8List(0);

  @override
  Widget build(BuildContext context) {
    Map scanData;
    dynamic keyData;
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(vertical: 36),
                child: const Text('App Challenge',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      color: Colors.deepPurple,
                    )),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 18),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.bluetooth),
                  label: const Text('BLE Devices',
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                      )),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: const Size(300, 1),
                  ),
                  onPressed: () async {
                    scanData = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => blePage(
                          scanResultList: widget.scanResultList,
                          lastScanned: widget.lastScanned,
                        ),
                      ),
                    );
                    widget.scanResultList = scanData['scanResultList'];
                    widget.lastScanned = scanData['lastScanned'];
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 18),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.key),
                  label: const Text('Generate RSA Key Pair',
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                      )),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: const Size(300, 1),
                  ),
                  onPressed: () async {
                    keyData = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => rsaGenPage(
                          widget.userPair,
                        ),
                      ),
                    );
                    widget.userPair = keyData;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 18),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.app_registration),
                  label: const Text('Sign List',
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                      )),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: const Size(300, 1),
                  ),
                  onPressed: () async {
                    signature = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => signPage(
                            widget.scanResultList, widget.userPair, signature),
                      ),
                    );
                    setState(() {});

                    print(signature);
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 18),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.verified),
                  label: const Text('Verify Signature',
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                      )),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    disabledBackgroundColor: Colors.deepPurpleAccent[100],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: const Size(300, 1),
                  ),
                  onPressed: base64.encode(signature) != ''
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => verifyPage(
                                  widget.scanResultList,
                                  widget.userPair,
                                  signature),
                            ),
                          );
                        }
                      : null,
                ),
              ),
            ],
          ),
        ));
  }
}
