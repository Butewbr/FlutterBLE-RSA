import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:myapp/pages/rsa.dart';
import 'package:pointycastle/export.dart' as ptCastle hide State, Padding;
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:myapp/widget/theme_button.dart';

class signPage extends StatefulWidget {
  List<ScanResult> scanResultList;
  ptCastle.AsymmetricKeyPair<ptCastle.RSAPublicKey, ptCastle.RSAPrivateKey>
      keyPair;
  Uint8List signature;

  signPage(this.scanResultList, this.keyPair, this.signature);

  @override
  State<signPage> createState() => _signPageState();
}

class _signPageState extends State<signPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign List',
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
            )),
        centerTitle: true,
        elevation: 0,
        leading: BackButton(
          onPressed: () => Navigator.pop(context, widget.signature),
        ),
        actions: const [
          ChangeThemeButton(),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Sign BLE Device List',
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: Theme.of(context).primaryColor,
                )),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.app_registration,
                    color: Colors.white,
                  ),
                  label: const Text('Sign List',
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        color: Colors.white,
                      )),
                  onPressed: () async {
                    // print("scan result: ${widget.scanResultList}");
                    // print(
                    //     "pvkey modulus: ${widget.keyPair.privateKey.modulus}");
                    // print("pbkey modulus: ${widget.keyPair.publicKey.modulus}");

                    if (widget.keyPair == getEmptyKeyPair()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            'Your key pair is empty!',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                      return;
                    }

                    List<String> devicesID = [];

                    for (ScanResult result in widget.scanResultList) {
                      devicesID.add(result.device.id.toString());
                    }

                    String jsonData = json.encode(devicesID);

                    // print("jsondata: $jsonData");

                    // Convert the JSON-encoded string to bytes
                    List<int> dataBytes = utf8.encode(jsonData);
                    // print("databytes: $dataBytes");
                    Uint8List uint8DataBytes = Uint8List.fromList(dataBytes);
                    // print("uint8databytes: $uint8DataBytes");

                    // Create a SHA-256 hash of the data
                    Digest hash = sha256.convert(uint8DataBytes);

                    // Sign the hash with the private key
                    ptCastle.RSASigner signer = ptCastle.RSASigner(
                        ptCastle.SHA256Digest(), "0609608648016503040201");
                    signer.init(
                        true,
                        ptCastle.PrivateKeyParameter<ptCastle.RSAPrivateKey>(
                            widget.keyPair.privateKey));
                    ptCastle.RSASignature signature = signer
                        .generateSignature(Uint8List.fromList(hash.bytes));

                    widget.signature = signature.bytes;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.green,
                        content: Text(
                          'List Signed!',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );

                    setState(() {});
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: base64.encode(widget.signature) != ''
                      ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                seeSignature(widget.signature),
                          ))
                      : null,
                  icon: const Icon(
                    Icons.remove_red_eye,
                    color: Colors.white,
                  ),
                  label: const Text('See Signature',
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        color: Colors.white,
                        // color: Colors.white,
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class seeSignature extends StatelessWidget {
  final Uint8List signature;

  const seeSignature(this.signature);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text('Generate RSA Key Pair',
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold,
              )),
          centerTitle: true,
          elevation: 0,
          actions: const [
            ChangeThemeButton(),
          ],
        ),
        body: Scrollbar(
          thickness: 8,
          thumbVisibility: true,
          radius: const Radius.circular(4.0),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                base64.encode(signature),
                style: TextStyle(
                  fontFamily: "Oxygen",
                  fontSize: 13,
                  color: Theme.of(context).primaryColorLight,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ));
  }
}
