import 'dart:async';
import 'dart:convert';
import 'dart:convert';
import 'dart:typed_data';
import 'package:shopwise/widgets/barcode_scanner.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'package:flutter/services.dart' show rootBundle;



class MQTT_Service {

  static String statusText = "Status Text";
  static String location = "Location";
  static bool isConnected = false;
   
/// Mock client can't be created with final client
    static final MqttServerClient client =
      MqttServerClient('a2yj8j5za4742r-ats.iot.eu-north-1.amazonaws.com', '');

static StreamController<String> streamController = StreamController<String>();



  static Future<bool> mqttConnect(String uniqueId) async {
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

  static void setStatus(String content) {
    getJson(content);
    statusText = content;

  }
  
  static void getJson(String message) {
    print("Trying.......................................................");
    print(message);
    try {
      dynamic json = jsonDecode(message);
      streamController.add(json['current_Location'].toString());

    
        location = json['current_Location'].toString();
     
      
      print(json);
    } catch (e) {
      print("Occurredd............");
      print(e);
    }
  }

  static void onConnected() {
    setStatus("Client connected");
 
  }

  static void onDisconnected() {


    setStatus("Client disconnected");
    isConnected = false;
  }

  static  void pong() {
    print("ping response invoked");
  }

  static void _disconnect() {
    client.disconnect();
  }
}