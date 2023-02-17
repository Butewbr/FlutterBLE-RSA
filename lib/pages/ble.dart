import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:myapp/main.dart';

class blePage extends StatefulWidget {
  List<ScanResult> scanResultList;
  String lastScanned;

  static const routeName = '/extractArguments';

  blePage({required this.scanResultList, this.lastScanned = 'a'});

  @override
  _blePageState createState() => _blePageState();
}

class _blePageState extends State<blePage> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  // List<ScanResult> scanResultList = [];
  bool _isScanning = false;

  Map data = {};

  // String lastScanned = DateFormat('yyyy-MM-dd H:m:s')
  //     .format(DateTime.parse('2021-07-13T13:15:54.000000Z'));

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
    print(widget.lastScanned);
    widget.lastScanned =
        DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now());
    print(widget.lastScanned);
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
      style: const TextStyle(
        fontFamily: "Oxygen",
      ),
    );
  }

  Widget printLastScanned() {
    if (widget.lastScanned == 'a') {
      return const Text(
        "No Scan History",
        style: TextStyle(
          fontFamily: "Oxygen",
          fontSize: 16,
          letterSpacing: 1.0,
        ),
        textAlign: TextAlign.center,
      );
    } else {
      return Text(
        "Last Scanned at:\n${widget.lastScanned}",
        style: const TextStyle(
          fontFamily: "Oxygen",
          fontSize: 16,
          letterSpacing: 1.0,
        ),
        textAlign: TextAlign.center,
      );
    }
  }

  Widget circleIcon(ScanResult r) {
    return const CircleAvatar(
      backgroundColor: Colors.deepOrangeAccent,
      child: Icon(
        Icons.bluetooth_drive,
        color: Colors.white,
      ),
    );
  }

  Widget deviceTemplate(ScanResult r) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: Colors.white,
      shadowColor: Colors.deepOrangeAccent,
      child: ListTile(
        leading: circleIcon(r),
        title: deviceName(r),
        subtitle: Text(
          "ID: ${r.device.id.id}",
          style: const TextStyle(
            fontFamily: "Oxygen",
          ),
        ),
        trailing: Text(
          "RSSI:\n${r.rssi.toString()}",
          style: TextStyle(
            fontFamily: "Oxygen",
            color: Colors.grey[700],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Check BLE Devices',
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
            )),
        leading: BackButton(
          onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Home(
                      scanResultList: widget.scanResultList,
                      lastScanned: widget.lastScanned))),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
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
                          ? const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                "No Devices Found",
                                style: TextStyle(
                                  fontFamily: "Oxygen",
                                  fontSize: 18,
                                  letterSpacing: 1.0,
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
                              //     color: Colors.deepOrange[100],
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
        backgroundColor: Colors.deepOrangeAccent,
        elevation: 4,
        child: Icon(
            _isScanning ? Icons.bluetooth_disabled : Icons.bluetooth_audio),
      ),
    );
  }
}

class ScanningWidget extends StatelessWidget {
  const ScanningWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: SpinKitFadingCircle(
      size: 60,
      color: Colors.deepOrangeAccent,
      duration: Duration(seconds: 1),
    ));
  }
}
