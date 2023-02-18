import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/export.dart' hide State, Padding;
import 'package:myapp/pages/seekey.dart';

AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateKeyPair() {
  final keyParams = RSAKeyGeneratorParameters(BigInt.from(65537), 2048, 64);
  final secureRandom = FortunaRandom();
  final random = Random.secure();
  final seeds = <int>[];
  for (var i = 0; i < 32; i++) {
    seeds.add(random.nextInt(255));
  }
  secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));
  final keyGenerator = RSAKeyGenerator();
  keyGenerator.init(ParametersWithRandom(keyParams, secureRandom));
  final keyPair = keyGenerator.generateKeyPair();
  final publicKey = keyPair.publicKey as RSAPublicKey;
  final privateKey = keyPair.privateKey as RSAPrivateKey;

  return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(publicKey, privateKey);
}

AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> getEmptyKeyPair() {
  final emptyPublicKey = RSAPublicKey(BigInt.zero, BigInt.zero);
  final emptyPrivateKey =
      RSAPrivateKey(BigInt.zero, BigInt.zero, BigInt.zero, BigInt.zero);
  return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(
      emptyPublicKey, emptyPrivateKey);
}

class rsaGenPage extends StatefulWidget {
  const rsaGenPage({super.key});

  @override
  State<rsaGenPage> createState() => rsaGenPageState();
}

class rsaGenPageState extends State<rsaGenPage> {
  final emptyKey = getEmptyKeyPair();
  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> userPair = getEmptyKeyPair();

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
        backgroundColor: Colors.deepOrange,
        elevation: 0,
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Your Keys:',
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: Colors.deepOrange,
                )),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Private Key:",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      letterSpacing: 1.0,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                        child: Icon(
                          Icons.vpn_key_outlined,
                          color: Colors.deepOrange,
                          size: 28,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: userPair == emptyKey
                            ? null
                            : () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => hugeText(userPair, 0),
                                  ),
                                ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrangeAccent,
                          disabledBackgroundColor: Colors.deepOrangeAccent[100],
                        ),
                        child: const Text("Click to See",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.white,
                            )),
                      )
                    ],
                  ),
                  const Text(
                    "Public Key:",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      letterSpacing: 1.0,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                        child: Icon(
                          Icons.vpn_key,
                          color: Colors.deepOrange,
                          size: 30,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: userPair == emptyKey
                            ? null
                            : () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        hugeText(userPair, 1))),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrangeAccent,
                          disabledBackgroundColor: Colors.deepOrangeAccent[100],
                        ),
                        child: const Text("Click to See",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.white,
                            )),
                      )
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.generating_tokens),
              label: const Text('Generate New Pair',
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
                userPair = generateKeyPair();
                setState(() {});
              },
            ),
          ]),
    );
  }
}
