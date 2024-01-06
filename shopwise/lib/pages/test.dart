import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shopwise/pages/home.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:shopwise/widgets/barcode_scanner.dart';

import 'package:sn_progress_dialog/sn_progress_dialog.dart';

import 'dart:io';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client/mqtt_client.dart';

import 'package:flutter/services.dart' show rootBundle;

// import 'package:ndialog/ndialog.dart';

class MQTTClientTest extends StatefulWidget {
  const MQTTClientTest({Key? key}) : super(key: key);

  @override
  _MQTTClientTestState createState() => _MQTTClientTestState();
}

class _MQTTClientTestState extends State<MQTTClientTest> {
  String statusText = "Status Text";
  String location = "Location";

  StreamController<String> streamController = StreamController<String>();

  bool isConnected = false;
  TextEditingController idTextController = TextEditingController();

  final MqttServerClient client =
      MqttServerClient('a2yj8j5za4742r-ats.iot.eu-north-1.amazonaws.com', '');

  @override
  void initState() {
    // TODO: implement initState
    _connect_auto();
    print("init called");
    super.initState();
  }

  @override
  void dispose() {
    idTextController.dispose();
    _disconnect();
    super.dispose();
  }

  Future<bool> mqttConnect(String uniqueId) async {
    setStatus("Connecting to AWS IoT...");
    ByteData rootCA = await rootBundle.load('assets/certificates/RootCA.pem');
    ByteData deviceCert =
        await rootBundle.load('assets/certificates/DeviceCertificate.crt');
    ByteData privateKey =
        await rootBundle.load('assets/certificates/Private.key');

    SecurityContext context = SecurityContext.defaultContext;
    context.setTrustedCertificatesBytes(rootCA.buffer.asUint8List());
    context.useCertificateChainBytes(deviceCert.buffer.asUint8List());
    context.usePrivateKeyBytes(privateKey.buffer.asUint8List());

    client.securityContext = context;
    client.logging(on: true);
    client.keepAlivePeriod = 30;
    client.port = 8883;
    client.secure = true;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.pongCallback = pong;

    final MqttConnectMessage connMess =
        MqttConnectMessage().withClientIdentifier(uniqueId).startClean();
    client.connectionMessage = connMess;

    await client.connect();
    if (client != null &&
        client.connectionStatus!.state == MqttConnectionState.connected) {
      print("Connected to AWS successfully");
    } else {
      return false;
    }

    const topic = 'esp32/pub';
    client.subscribe(topic, MqttQos.atMostOnce);
    // var test = client.subscribe(topic, MqttQos.atMostOnce);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
      final String pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message!);
      print(
          'Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      setStatus(pt);
    });

    return true;
  }

  _connect_auto() async {
    // ProgressDialog pd = ProgressDialog(context: context);

    // pd.show(msg: "Connecting");
    // pd.show();
    // ProgressDialog progressDialog = ProgressDialog(context,
    //     blur: 0,
    //     dialogTransitionType: DialogTransitionType.Shrink,
    //     dismissable: true);
    // progressDialog.setLoadingWidget(
    //   CircularProgressIndicator(
    //     valueColor: AlwaysStoppedAnimation(Colors.red),
    //   ),
    // );
    // progressDialog.setMessage(Text("wait, connecting to core"));
    // progressDialog.setTitle(Text("Connecting"));

    isConnected = await mqttConnect(idTextController.text.trim());

    if (isConnected) {
      final snackBar = SnackBar(
        /// need to set following properties for best effect of awesome_snackbar_content
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Congratulations!',
          message: 'You are online',

          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
          contentType: ContentType.success,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        /// need to set following properties for best effect of awesome_snackbar_content
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Sorry!',
          message: 'Please check your internet connection.',

          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }

    // await mqttConnect("someunique").then((value) {
    //   if (value) {
    //     progressDialog.dismiss();
    //   }
    //   progressDialog.setLoadingWidget(null);
    //   progressDialog.setTitle(Text("Connected"));
    //   progressDialog.dismiss();
    // });

    if (isConnected) {
      // progressDialog.setTitle(Text("Connected"));
      // progressDialog.dismiss();
    }

    // try {

    //   print(isConnected);
    // } catch (e) {
    //   print('Error in mqttConnect: $e');
    // }

    // // isConnected = await mqttConnect(idTextController.text.trim());
    // // print(isConnected);
    // print("dismissing.................");
    // if (isConnected) {
    //   // pd.close();
    //   progressDialog.setBackgroundColor(Colors.red);
    //   progressDialog.setTitle(Text("Connected"));
    //   progressDialog.setMessage(Text("Connected to core"));
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     progressDialog.dismiss();
    //   });
    //   // progressDialog.dismiss();
    // } else {
    //   print('isConnected is false');
    // }
    // if (isConnected) {
    //   progressDialog.dismiss();
    // }
  }

  _connect() async {
    if (idTextController.text.trim().isNotEmpty) {
      // final ProgressDialog pr = ProgressDialog(context);

      // ProgressDialog progressDialog = ProgressDialog(context,
      //     blur: 0,
      //     dialogTransitionType: DialogTransitionType.Shrink,
      //     dismissable: false);
      // progressDialog.setLoadingWidget(CircularProgressIndicator(
      //   valueColor: AlwaysStoppedAnimation(Colors.red),
      // ));
      // progressDialog.setMessage(Text("wait, connecting to core"));
      // progressDialog.setTitle(Text("Connecting"));
      // progressDialog.show();

      // pr.show();

      // isConnected = await mqttConnect(idTextController.text.trim());

      // pr.hide().then((isHidden) {
      //   print(isHidden);
      // });
      // progressDialog.dismiss();
    }
  }

  void getJson(String message) {
    print("Trying.......................................................");
    print(message);
    try {
      dynamic json = jsonDecode(message);
      streamController.add(json['current_Location'].toString());
      setState(() {
        location = json['current_Location'].toString();
      });
      print(json);
    } catch (e) {
      print("Occurredd............");
      print(e);
    }
  }

  _disconnect() {
    client.disconnect();
  }

  void setStatus(String content) {
    // Map<String, dynamic> jsonobj = getJson(statusText);
    getJson(content);
    setState(() {
      statusText = content;
      // location = obj['current_Location'] as String;
      // location = jsonobj['current_Location'];
    });
    /*  Map<String, dynamic> jsonobj = getJson(statusText);
    setState(() {
      location = jsonobj['current_Location'];
    }); */
    // print(jsonobj['current_Location']);
  }

  void onConnected() {
    setStatus("Client connected");
  }

  void onDisconnected() {
    setStatus("Client disconnected");
    isConnected = false;
  }

  void pong() {
    print("ping response invoked");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Expanded(
          child: Column(
            children: [
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              //   child: TextFormField(
              //       enabled: !isConnected,
              //       controller: idTextController,
              //       decoration: InputDecoration(
              //           border: UnderlineInputBorder(),
              //           labelText: 'MQTT Client Id',
              //           labelStyle: TextStyle(fontSize: 10),
              //           suffixIcon: IconButton(
              //             icon: Icon(Icons.subdirectory_arrow_left),
              //             onPressed: _connect,
              //           ))),
              // ),
              // isConnected
              //     ? TextButton(
              //         onPressed: _disconnect, child: Text('Disconnect'))
              //     : Container(),
              // Text(statusText),
              // Text(location),
              HomePage(directionStream: streamController.stream),
              // BarcodeReader()
            ],
          ),
        ),
      ),
    );
  }
}
