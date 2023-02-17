import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/export.dart' hide State, Padding;

// AsymmetricKeyPair<PublicKey, PrivateKey> generateRSAKeyPair(
//     {int bitLength = 2048}) {
//   final keyParams =
//       RSAKeyGeneratorParameters(BigInt.from(65537), bitLength, 64);
//   final secureRandom = SecureRandom('Fortuna');
//   final keyGen = RSAKeyGenerator()
//     ..init(ParametersWithRandom(keyParams, secureRandom));
//   return keyGen.generateKeyPair();
// }

AsymmetricKeyPair<PublicKey, PrivateKey> generateKeyPair() {
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

  return keyPair;
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
  final userPair = generateKeyPair();

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
                      userPair != emptyKey
                          ? Text(
                              "${userPair.privateKey}${userPair.privateKey}",
                              style: const TextStyle(
                                fontFamily: "Oxygen",
                                fontSize: 16,
                                letterSpacing: 1.0,
                              ),
                              textAlign: TextAlign.center,
                            )
                          : const Text(
                              "N/A",
                              style: TextStyle(
                                fontFamily: "Oxygen",
                                fontSize: 16,
                                letterSpacing: 1.0,
                              ),
                              textAlign: TextAlign.center,
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
                      userPair != emptyKey
                          ? Text(
                              "${userPair.publicKey}${userPair.publicKey}",
                              style: const TextStyle(
                                fontFamily: "Oxygen",
                                fontSize: 16,
                                letterSpacing: 1.0,
                              ),
                              textAlign: TextAlign.center,
                            )
                          : const Text(
                              "N/A",
                              style: TextStyle(
                                fontFamily: "Oxygen",
                                fontSize: 16,
                                letterSpacing: 1.0,
                              ),
                              textAlign: TextAlign.center,
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
              onPressed: () {},
            ),
          ]),
    );
  }
}
