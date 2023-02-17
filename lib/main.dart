import 'package:flutter/material.dart';
import 'package:myapp/pages/ble.dart';
import 'package:myapp/pages/rsa.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() => runApp(MaterialApp(
      initialRoute: '/home',
      routes: {
        '/home': (context) => Home(
              scanResultList: [],
            ),
        '/ble': (context) => blePage(
              scanResultList: [],
            ),
        '/rsa': (context) => rsaGenPage(),
      },
    ));

class Home extends StatelessWidget {
  List<ScanResult> scanResultList;
  String lastScanned;

  Home({required this.scanResultList, this.lastScanned = 'a'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('LabSEC Mobile Challenge',
        //       style: TextStyle(
        //         fontFamily: "Poppins",
        //         fontWeight: FontWeight.bold,
        //       )),
        //   centerTitle: true,
        //   backgroundColor: Colors.deepOrange,
        //   elevation: 0,
        // ),
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
                      color: Colors.deepOrange,
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
                    backgroundColor: Colors.deepOrangeAccent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: const Size(300, 1),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => blePage(
                          scanResultList: scanResultList,
                          lastScanned: lastScanned,
                        ),
                      ),
                    );
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
                    backgroundColor: Colors.deepOrangeAccent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: const Size(300, 1),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/rsa');
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
                    backgroundColor: Colors.deepOrangeAccent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: const Size(300, 1),
                  ),
                  onPressed: () {
                    print('clicked button!');
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
                    backgroundColor: Colors.deepOrangeAccent,
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
