import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:pointycastle/export.dart' as ptCastle hide State, Padding;
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:myapp/pages/sign.dart';
import 'package:myapp/widget/theme_button.dart';

class verifyPage extends StatefulWidget {
  List<ScanResult> scanResultList;
  ptCastle.AsymmetricKeyPair<ptCastle.RSAPublicKey, ptCastle.RSAPrivateKey>
      keyPair;
  Uint8List signature;
  bool verification = false;
  bool tried = false;

  verifyPage(this.scanResultList, this.keyPair, this.signature);

  @override
  State<verifyPage> createState() => _verifyPageState();
}

class _verifyPageState extends State<verifyPage> {
  Future<bool> verifySignature() async {
    List<String> devicesID = [];

    // print("MODULUS: ${widget.keyPair.publicKey.modulus}");

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

    final verifier =
        ptCastle.RSASigner(ptCastle.SHA256Digest(), '0609608648016503040201');

    verifier.init(
        false,
        ptCastle.PublicKeyParameter<ptCastle.RSAPublicKey>(
            widget.keyPair.publicKey));

    return verifier.verifySignature(Uint8List.fromList(hash.bytes),
        ptCastle.RSASignature(widget.signature));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Verify a Signature',
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
            )),
        centerTitle: true,
        elevation: 0,
        leading: BackButton(
          onPressed: () => Navigator.pop(context, widget.signature),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            !widget.verification && !widget.tried
                ? Text('Verify Signature',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      color: Theme.of(context).primaryColor,
                    ))
                : widget.verification
                    ? const Text("The Signature is Valid",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          color: Colors.green,
                        ))
                    : const Text("The Signature is Invalid",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          color: Colors.red,
                        )),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.verified,
                    color: Colors.white,
                  ),
                  label: const Text('Verify Signature',
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        color: Colors.white,
                      )),
                  onPressed: () async {
                    widget.verification = await verifySignature();
                    // print(widget.verification);
                    widget.tried = true;
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
                      )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
