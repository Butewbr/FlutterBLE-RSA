import 'package:flutter/material.dart';
import 'package:pointycastle/export.dart' hide State, Padding;
import 'dart:convert';
import 'package:myapp/widget/theme_button.dart';

class hugeText extends StatelessWidget {
  final AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> thePair;
  final int which;

  const hugeText(this.thePair, this.which);

  @override
  Widget build(BuildContext context) {
    String pvKey = thePair.privateKey.modulus.toString() +
        thePair.privateKey.privateExponent.toString();
    String pbKey = thePair.publicKey.modulus.toString() +
        thePair.publicKey.exponent.toString();

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
              child: which == 0
                  ? Text(
                      "-----BEGIN PRIVATE KEY-----\n${base64.encode(utf8.encode(pvKey))}\n-----END PRIVATE KEY-----",
                      style: TextStyle(
                        fontFamily: "Oxygen",
                        fontSize: 13,
                        color: Theme.of(context).primaryColorLight,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : Text(
                      "-----BEGIN PUBLIC KEY-----\n${base64.encode(utf8.encode(pbKey))}\n-----END PUBLIC KEY-----",
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
