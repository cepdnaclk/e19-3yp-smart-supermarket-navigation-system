import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:navigation/home.dart';

import 'dart:io';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client/mqtt_client.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:navigation/test.dart';

import 'package:ndialog/ndialog.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   StreamController<String> streamController = StreamController<String>();

//   // MQTT Configuration
//   static const String awsIoTEndpoint =
//       'a2yj8j5za4742r-ats.iot.eu-north-1.amazonaws.com';
//   static const int awsIoTPort = 8883;
//   static const String clientId = '3yp-device01';
//   static const String topic = 'esp32/pub';

//   MqttServerClient? client;

//   @override
//   void initState() {
//     super.initState();
//     connectToMQTT(); // Connect to MQTT when the app starts
//   }

//   @override
//   void dispose() {
//     client?.disconnect();
//     super.dispose();
//   }

//   Future<void> connectToMQTT() async {
//     // Create the client
//     client = MqttServerClient.withPort(awsIoTEndpoint, clientId, awsIoTPort);

//     // Set secure
//     client!.secure = true;
//     client!.keepAlivePeriod = 20;
//     client!.setProtocolV311();
//     client!.logging(on: false);

//     // Set the security context
//     final rootCaBytes = await rootBundle.load('assets/certs/RootCA.pem');
//     final deviceCertBytes =
//         await rootBundle.load('assets/certs/DeviceCertificate.crt');
//     final privateKeyBytes = await rootBundle.load('assets/certs/Private.key');

//     final context = SecurityContext.defaultContext;
//     context.setTrustedCertificatesBytes(rootCaBytes.buffer.asUint8List());
//     context.useCertificateChainBytes(deviceCertBytes.buffer.asUint8List());
//     context.usePrivateKeyBytes(privateKeyBytes.buffer.asUint8List());
//     client!.securityContext = context;

//     // Setup the connection Message
//     final connMess = MqttConnectMessage().withClientIdentifier(clientId);
//     client!.connectionMessage = connMess;

//     // Connect the client
//     try {
//       print('MQTT client connecting to AWS IoT using certificates....');
//       await client!.connect();
//     } on Exception catch (e) {
//       print('MQTT client exception - $e');
//       client!.disconnect();
//       exit(-1);
//     }

//     if (client!.connectionStatus!.state == MqttConnectionState.connected) {
//       print('MQTT client connected to AWS IoT');

//       //test subject
//       await MqttUtilities.asyncSleep(1);
//       const topic = 'esp32/sub';
//       final builder = MqttClientPayloadBuilder();
//       builder.addString('Hello from 3YP');
//       client!.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);

//       // Subscribe to the topic
//       client!.subscribe(topic, MqttQos.atMostOnce);

//       print('Subscribed');

//       // Print incoming messages from the subscribed topic
//       client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
//         try {
//           final recMess = c[0].payload as MqttPublishMessage;
//           final pt =
//               MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
//           print(
//               'Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
//           streamController.add(
//               pt); // Assuming you want to add received messages to the stream
//         } catch (e) {
//           print('Exception in message handling: $e');
//         }
//       });
//     } else {
//       print(
//           'ERROR MQTT client connection failed - disconnecting, state is ${client!.connectionStatus!.state}');
//       client!.disconnect();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomePage(directionStream: streamController.stream),
//     );
//   }
// }

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MQTT ESP32CAM VIEWER',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: MQTTClient(),
    );
  }
}

class MQTTClient extends StatefulWidget {
  const MQTTClient({Key? key}) : super(key: key);

  @override
  _MQTTClientState createState() => _MQTTClientState();
}

class _MQTTClientState extends State<MQTTClient> {
  String statusText = "Status Text";
  bool isConnected = false;
  TextEditingController idTextController = TextEditingController();

  final MqttServerClient client =
      MqttServerClient('a2yj8j5za4742r-ats.iot.eu-north-1.amazonaws.com', '');

  @override
  void dispose() {
    idTextController.dispose();
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: SafeArea(
  //       child: Column(
  //         children: [header(), body(), footer()],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return MQTTClientTest();
  }

  Widget header() {
    return Expanded(
      child: Container(
        child: Text(
          'ESP32CAM Viewer\n- AWS IoT -',
          style: TextStyle(
              fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      flex: 3,
    );
  }

  Widget body() {
    return Expanded(
      child: Container(
        color: Colors.black26,
        child: Row(
          children: [
            Expanded(
              child: Container(
                color: Colors.black,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: TextFormField(
                          enabled: !isConnected,
                          controller: idTextController,
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'MQTT Client Id',
                              labelStyle: TextStyle(fontSize: 10),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.subdirectory_arrow_left),
                                onPressed: _connect,
                              ))),
                    ),
                    isConnected
                        ? TextButton(
                            onPressed: _disconnect, child: Text('Disconnect'))
                        : Container()
                  ],
                ),
              ),
              flex: 3,
            ),
            Expanded(
              child: Container(color: Colors.white),
              flex: 7,
            )
          ],
        ),
      ),
      flex: 20,
    );
  }

  Widget footer() {
    return Expanded(
      child: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: Text(
          statusText,
          style: TextStyle(
              fontWeight: FontWeight.normal, color: Colors.amberAccent),
        ),
      ),
      flex: 1,
    );
  }

  _connect() async {
    if (idTextController.text.trim().isNotEmpty) {
      ProgressDialog progressDialog = ProgressDialog(context,
          blur: 0,
          dialogTransitionType: DialogTransitionType.Shrink,
          dismissable: false);
      progressDialog.setLoadingWidget(CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.red),
      ));
      progressDialog.setMessage(Text("wait, connecting to core"));
      progressDialog.setTitle(Text("Connecting"));
      progressDialog.show();

      isConnected = await mqttConnect(idTextController.text.trim());
      progressDialog.dismiss();
    }
  }

  _disconnect() {
    client.disconnect();
  }

  Future<bool> mqttConnect(String uniqueId) async {
    setStatus("Connecting to AWS IoT...");
    ByteData rootCA = await rootBundle.load('assets/certs/RootCA.pem');
    ByteData deviceCert =
        await rootBundle.load('assets/certs/DeviceCertificate.crt');
    ByteData privateKey = await rootBundle.load('assets/certs/Private.key');

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

  void setStatus(String content) {
    setState(() {
      statusText = content;
    });
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
}
