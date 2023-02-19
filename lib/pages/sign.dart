import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:pointycastle/export.dart' as ptCastle hide State, Padding;
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:myapp/pages/seekey.dart';

class signPage extends StatefulWidget {
  List<ScanResult> scanResultList;
  ptCastle.AsymmetricKeyPair<ptCastle.RSAPublicKey, ptCastle.RSAPrivateKey>
      keyPair;
  String signatureString = '';

  signPage(this.scanResultList, this.keyPair);

  @override
  State<signPage> createState() => _signPageState();
}

class _signPageState extends State<signPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Generate RSA Key Pair',
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
            )),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        leading: BackButton(
          onPressed: () => Navigator.pop(context, widget.signatureString),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Sign BLE Device List',
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: Colors.deepPurple,
                )),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
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
                    print("scan result: ${widget.scanResultList}");
                    print("key pair: ${widget.keyPair}");

                    List<String> devicesID = [];

                    for (ScanResult result in widget.scanResultList) {
                      devicesID.add(result.device.id.toString());
                    }

                    String jsonData = json.encode(devicesID);

                    print("jsondata: $jsonData");

                    // Convert the JSON-encoded string to bytes
                    List<int> dataBytes = utf8.encode(jsonData);
                    print("databytes: $dataBytes");
                    Uint8List uint8DataBytes = Uint8List.fromList(dataBytes);
                    print("uint8databytes: $uint8DataBytes");

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
                    Uint8List signatureBytes = signature.bytes;

                    // Convert the signature to a Base64-encoded string
                    widget.signatureString = base64.encode(signatureBytes);

                    print(widget.signatureString);

                    setState(() {});
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: widget.signatureString != ''
                      ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                seeSignature(widget.signatureString),
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
                      )),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    disabledBackgroundColor: Colors.deepPurpleAccent[100],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: const Size(300, 1),
                  ),
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
  final String signature;

  const seeSignature(this.signature);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text('Generate RSA Key Pair',
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold,
              )),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
          elevation: 0,
        ),
        body: Scrollbar(
          thickness: 8,
          thumbVisibility: true,
          radius: const Radius.circular(4.0),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                signature,
                style: const TextStyle(fontFamily: "Oxygen", fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ));
  }
}
