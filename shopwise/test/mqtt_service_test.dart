import 'dart:async';

import 'package:flutter_test/flutter_test.dart' as ft;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:test/test.dart';
import 'package:shopwise/services/mqtt_service.dart'; // Replace with the actual path to your MQTT_Service file

import 'package:mockito/mockito.dart';

class MockMqttServerClient extends Mock implements MqttServerClient {}

void main() {
  ft.group('MQTT_Service', () {
    ft.testWidgets('Connects to MQTT server', (ft.WidgetTester tester) async {
      // Ensure Flutter services are initialized
      await tester.runAsync(() async {
        // Replace 'your_unique_id' with an actual unique identifier
        bool isConnected = await MQTT_Service.mqttConnect('your_unique_id');

        expect(isConnected, isTrue);
      });
    });

    tearDown(() {
      // Disconnect the client after each test
      if (MQTT_Service.client.connectionStatus!.state ==
          MqttConnectionState.connected) {
        MQTT_Service.client.disconnect();
      }
    });
  });
}
