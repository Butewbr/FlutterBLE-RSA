import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/export.dart' hide State, Padding;
import 'package:myapp/pages/seekey.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myapp/widget/theme_button.dart';

AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> getEmptyKeyPair() {
  final emptyPublicKey = RSAPublicKey(BigInt.zero, BigInt.zero);
  final emptyPrivateKey =
      RSAPrivateKey(BigInt.zero, BigInt.zero, BigInt.zero, BigInt.zero);
  return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(
      emptyPublicKey, emptyPrivateKey);
}

class rsaGenPage extends StatefulWidget {
  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> userPair;

  rsaGenPage(this.userPair);

  @override
  State<rsaGenPage> createState() => rsaGenPageState();
}

class rsaGenPageState extends State<rsaGenPage> {
  final emptyKey = getEmptyKeyPair();
  bool isGenerating = false;
  int keySize = 2048;

  Future generateRSAPair(int size) async {
    final keyParams = RSAKeyGeneratorParameters(BigInt.from(65537), size, 64);
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

    widget.userPair =
        AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(publicKey, privateKey);

    return;
  }

  Future loadingScreen(int size) async {
    // setState(() {
    //   isGenerating = true;
    // });

    await Future.delayed(const Duration(seconds: 1));

    await generateRSAPair(size);
    setState(() {
      isGenerating = false;
    });
  }

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
        leading: BackButton(
          onPressed: () => Navigator.pop(context, widget.userPair),
        ),
        actions: const [
          ChangeThemeButton(),
        ],
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isGenerating
                ? Text('Generating Key Pair',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      color: Theme.of(context).primaryColor,
                    ))
                : widget.userPair == emptyKey
                    ? Text('You have no Keys',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          color: Theme.of(context).primaryColor,
                        ))
                    : Text('Your Keys:',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          color: Theme.of(context).primaryColor,
                        )),
            isGenerating
                ? const GeneratingWidget()
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Private Key:",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            letterSpacing: 1.0,
                            color: Theme.of(context).primaryColorLight,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16),
                              child: Icon(
                                Icons.vpn_key_outlined,
                                color: Theme.of(context).primaryColor,
                                size: 28,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: widget.userPair == emptyKey
                                  ? null
                                  : () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              hugeText(widget.userPair, 0),
                                        ),
                                      ),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(1, 1),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                              ),
                              child: const Text("Click to See Your Private Key",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colors.white,
                                  )),
                            )
                          ],
                        ),
                        Text(
                          "Public Key:",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            letterSpacing: 1.0,
                            color: Theme.of(context).primaryColorLight,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16),
                              child: Icon(
                                Icons.vpn_key,
                                color: Theme.of(context).primaryColor,
                                size: 30,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: widget.userPair == emptyKey
                                  ? null
                                  : () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              hugeText(widget.userPair, 1))),
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(1, 1),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12)),
                              child: const Text("Click to See your Public Key",
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
              icon: const Icon(Icons.generating_tokens, color: Colors.white),
              label: const Text('Generate New Pair',
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 16,
                    color: Colors.white,
                  )),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                minimumSize: const Size(300, 1),
              ),
              onPressed: !isGenerating
                  ? () async => {
                        keySize = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AskSizeWidget(),
                            )),
                        setState(() {
                          isGenerating = true;
                        }),
                        // await Future.delayed(const Duration(seconds: 1)),
                        loadingScreen(keySize),
                      }
                  : null,
            ),
          ]),
    );
  }
}

class AskSizeWidget extends StatefulWidget {
  const AskSizeWidget({super.key});

  @override
  State<AskSizeWidget> createState() => _AskSizeWidgetState();
}

class _AskSizeWidgetState extends State<AskSizeWidget> {
  int keySize = 2048;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Enter the Key Size:",
                  style: TextStyle(
                    fontFamily: "Oxygen",
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 2.0,
                    color: Theme.of(context).primaryColor,
                  )),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                style: TextStyle(color: Theme.of(context).primaryColorLight),
                decoration: InputDecoration(
                  labelText: "Key Size",
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurpleAccent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple[200]!),
                  ),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple)),
                  hintText: '2048',
                  hintStyle: TextStyle(color: Colors.deepPurple[200]),
                ),
                validator: (value) {
                  if (int.parse(value!) < 512 || int.parse(value) > 4096) {
                    return "Enter a value between 512 and 4096";
                  } else {
                    return null;
                  }
                },
                keyboardType: const TextInputType.numberWithOptions(
                    signed: false, decimal: false),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly // Only allow digits
                ],
                onSaved: (value) => setState(() => keySize = int.parse(value!)),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  onPressed: () {
                    final isValid = formKey.currentState!.validate();

                    if (isValid) {
                      formKey.currentState!.save();
                      Navigator.pop(context, keySize);
                    }
                  },
                  child: const Text(
                    "Submit",
                    style:
                        TextStyle(fontFamily: "Poppins", color: Colors.white),
                  )),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancel",
                    style:
                        TextStyle(fontFamily: "Poppins", color: Colors.white),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class GeneratingWidget extends StatelessWidget {
  const GeneratingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: SpinKitFadingFour(
      size: 60,
      color: Colors.deepPurpleAccent,
      duration: Duration(seconds: 1),
    ));
  }
}
