import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:myapp/widget/theme_button.dart';

class blePage extends StatefulWidget {
  List<ScanResult> scanResultList;
  String lastScanned;

  blePage({Key? key, required this.scanResultList, this.lastScanned = 'a'})
      : super(key: key);

  @override
  _blePageState createState() => _blePageState();
}

class _blePageState extends State<blePage> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  bool _isScanning = false;

  @override
  initState() {
    super.initState();
    initBle();
  }

  void initBle() {
    flutterBlue.isScanning.listen((isScanning) {
      _isScanning = isScanning;
      setState(() {});
    });
  }

  scan() async {
    widget.lastScanned =
        DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now());
    if (!_isScanning) {
      widget.scanResultList.clear();
      flutterBlue.startScan(timeout: const Duration(seconds: 4));
      flutterBlue.scanResults.listen((results) {
        widget.scanResultList = results;
        setState(() {});
      });
    } else {
      flutterBlue.stopScan();
    }
  }

  Widget deviceName(ScanResult r) {
    String name = '';

    if (r.device.name.isNotEmpty) {
      name = r.device.name;
    } else {
      name = "Unnamed Device";
    }
    return Text(
      name,
      style: TextStyle(
        fontFamily: "Oxygen",
        color: Theme.of(context).primaryColorLight,
      ),
    );
  }

  Widget printLastScanned() {
    if (widget.lastScanned == 'a') {
      return Text(
        "No Scan History",
        style: TextStyle(
          fontFamily: "Oxygen",
          fontSize: 16,
          letterSpacing: 1.0,
          color: Theme.of(context).primaryColorLight,
        ),
        textAlign: TextAlign.center,
      );
    } else {
      return Text(
        "Last Scanned at:\n${widget.lastScanned}",
        style: TextStyle(
          fontFamily: "Oxygen",
          fontSize: 16,
          letterSpacing: 1.0,
          color: Theme.of(context).primaryColorLight,
        ),
        textAlign: TextAlign.center,
      );
    }
  }

  Widget circleIcon(ScanResult r) {
    return const CircleAvatar(
      backgroundColor: Colors.deepPurpleAccent,
      child: Icon(
        Icons.bluetooth_drive,
        color: Colors.white,
      ),
    );
  }

  Widget deviceTemplate(ScanResult r) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      // color: Colors.white,
      shadowColor: Colors.deepPurpleAccent,
      child: ListTile(
        leading: circleIcon(r),
        title: deviceName(r),
        subtitle: Text(
          "ID: ${r.device.id.id}",
          style: TextStyle(
            fontFamily: "Oxygen",
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        trailing: Text(
          "RSSI:\n${r.rssi.toString()}",
          style: TextStyle(
            fontFamily: "Oxygen",
            color: Theme.of(context).primaryColorDark,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Check BLE Devices',
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
            )),
        leading: BackButton(
          onPressed: () => Navigator.pop(context, {
            'scanResultList': widget.scanResultList,
            'lastScanned': widget.lastScanned
          }),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: _isScanning
                  ? const ScanningWidget()
                  : SizedBox(
                      child: widget.scanResultList.isEmpty &&
                              widget.lastScanned != 'a'
                          ? Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                "No Devices Found",
                                style: TextStyle(
                                  fontFamily: "Oxygen",
                                  fontSize: 18,
                                  letterSpacing: 1.0,
                                  color: Theme.of(context).primaryColorLight,
                                ),
                                textAlign: TextAlign.center,
                              ))
                          : ListView.builder(
                              itemCount: widget.scanResultList.length,
                              itemBuilder: (context, index) {
                                return deviceTemplate(
                                    widget.scanResultList[index]);
                              },
                              // separatorBuilder: (BuildContext context, int index) {
                              //   return Divider(
                              //     color: Colors.deepPurple[100],
                              //     height: 0,
                              //   );
                              // },
                            ),
                    )),
          const SizedBox(height: 8),
          printLastScanned(),
          const SizedBox(height: 16),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scan,
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 4,
        child: Icon(
          _isScanning ? Icons.bluetooth_disabled : Icons.bluetooth_audio,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ScanningWidget extends StatelessWidget {
  const ScanningWidget({super.key});

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
