import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:your_package/test.dart'; // replace with your actual file

class MockMqttServerClient extends Mock implements MqttServerClient {}

void main() {
  group('MQTT Client:', () {
    test('Should connect to the broker', () async {
      final mockClient = MockMqttServerClient();
      when(mockClient.connect()).thenAnswer((_) => Future.value());

      final service = MQTTService(client: mockClient);

      await service.connectToMQTT();

      verify(mockClient.connect()).called(1);
    });

    test('Should subscribe to a topic', () async {
      final mockClient = MockMqttServerClient();
      when(mockClient.connect()).thenAnswer((_) => Future.value());

      final service = MQTTService(client: mockClient);

      await service.connectToMQTT();

      verify(mockClient.subscribe('esp32/pub', MqttQos.atMostOnce)).called(1);
    });

    test('Should handle received messages', () async {
      final mockClient = MockMqttServerClient();
      when(mockClient.connect()).thenAnswer((_) => Future.value());

      final service = MQTTService(client: mockClient);

      await service.connectToMQTT();

      final message = MqttPublishMessage();
      message.payload =
          MqttByteBuffer(MqttByteBuffer.readBytes('Test message'.codeUnits));

      final receivedMessage =
          MqttReceivedMessage<MqttMessage>('esp32/pub', message);

      mockClient.updates!.add([receivedMessage]);

      expect(service.streamController.stream, emits('Test message'));
    });
  });
}
