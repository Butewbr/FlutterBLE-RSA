import 'package:flutter/material.dart';
import 'package:myapp/pages/ble.dart';
import 'package:myapp/pages/rsa.dart';
import 'package:myapp/pages/sign.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:pointycastle/export.dart' hide State, Padding;

void main() => runApp(MaterialApp(initialRoute: '/home', routes: {
      '/home': (context) => Home(
            scanResultList: [],
          ),
    }));

class Home extends StatelessWidget {
  List<ScanResult> scanResultList;
  String lastScanned;

  Home({required this.scanResultList, this.lastScanned = 'a'});

  @override
  Widget build(BuildContext context) {
    AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> userPair = getEmptyKeyPair();
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
                          scanResultList: scanResultList,
                          lastScanned: lastScanned,
                        ),
                      ),
                    );
                    scanResultList = scanData['scanResultList'];
                    lastScanned = scanData['lastScanned'];
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
                          userPair,
                        ),
                      ),
                    );
                    userPair = keyData;
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
                    String signature = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            signPage(scanResultList, userPair),
                      ),
                    );
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
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: const Size(300, 1),
                  ),
                  onPressed: () {
                    print('clicked button!');
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
