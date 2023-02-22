import 'package:flutter/material.dart';
import 'package:myapp/pages/ble.dart';
import 'package:myapp/pages/rsa.dart';
import 'package:myapp/pages/sign.dart';
import 'package:myapp/pages/verify.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:typed_data';
import 'package:pointycastle/export.dart' hide State, Padding;
import 'dart:convert';
import 'package:myapp/provider/theme_provider.dart';
import 'package:myapp/widget/theme_button.dart';
import 'package:provider/provider.dart';

void main() => runApp(ChangeNotifierProvider(
    create: (_) => ThemeProvider(),
    child: Consumer<ThemeProvider>(
      builder: (context, notifier, child) => MaterialApp(
          theme: notifier.isDarkMode ? MyThemes.darkTheme : MyThemes.lightTheme,
          initialRoute: '/home',
          routes: {
            '/home': (context) => Home(),
          }),
    )));

class Home extends StatefulWidget {
  Home();

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ScanResult> scanResultList = [];
  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> userPair = getEmptyKeyPair();
  String lastScanned = 'a';
  Uint8List signature = Uint8List(0);

  @override
  Widget build(BuildContext context) {
    Map scanData;
    dynamic keyData;

    return Scaffold(
        // backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text('Home',
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold,
              )),
          centerTitle: true,
          // backgroundColor: Colors.deepPurple,
          elevation: 0,
          actions: [
            Consumer<ThemeProvider>(
                builder: (context, notifier, child) =>
                    const ChangeThemeButton()),
          ],
        ),
        body: Center(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 36),
                  child: Text('App Challenge',
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        color: Theme.of(context).primaryColor,
                      )),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 18),
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.bluetooth,
                      color: Colors.white,
                    ),
                    label: const Text('BLE Devices',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          color: Colors.white,
                        )),
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
                    icon: const Icon(Icons.key, color: Colors.white),
                    label: const Text('Generate RSA Key Pair',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          color: Colors.white,
                        )),
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
                    icon:
                        const Icon(Icons.app_registration, color: Colors.white),
                    label: const Text('Sign List',
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            color: Colors.white)),
                    onPressed: () async {
                      signature = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              signPage(scanResultList, userPair, signature),
                        ),
                      );
                      setState(() {});

                      // print(signature);
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 18),
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.verified,
                      color: Colors.white,
                    ),
                    label: const Text('Verify Signature',
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            color: Colors.white)),
                    onPressed: base64.encode(signature) != '' &&
                            userPair != getEmptyKeyPair()
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => verifyPage(
                                    scanResultList, userPair, signature),
                              ),
                            );
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
