import 'package:flutter/material.dart';
// import 'package:rsa_encrypt/rsa_encrypt.dart';
// import 'package:pointycastle/api.dart' as crypto;

// //Future to hold our KeyPair
// Future<crypto.AsymmetricKeyPair> futureKeyPair;

// //to store the KeyPair once we get data from our future
// crypto.AsymmetricKeyPair keyPair;

// Future<crypto.AsymmetricKeyPair<crypto.PublicKey, crypto.PrivateKey>>
//     getKeyPair() {
//   var helper = RsaKeyHelper();
//   return helper.computeRSAKeyPair(helper.getSecureRandom());
// }

class rsaGenPage extends StatefulWidget {
  const rsaGenPage({super.key});

  @override
  State<rsaGenPage> createState() => rsaGenPageState();
}

class rsaGenPageState extends State<rsaGenPage> {
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
                    children: const [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                        child: Icon(
                          Icons.vpn_key_outlined,
                          color: Colors.deepOrange,
                          size: 28,
                        ),
                      ),
                      Text(
                        "N/A",
                        style: TextStyle(
                          fontFamily: "Oxygen",
                          fontSize: 16,
                          letterSpacing: 1.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
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
                    children: const [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                        child: Icon(
                          Icons.vpn_key,
                          color: Colors.deepOrange,
                          size: 30,
                        ),
                      ),
                      Text(
                        "N/A",
                        style: TextStyle(
                          fontFamily: "Oxygen",
                          fontSize: 16,
                          letterSpacing: 1.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
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
