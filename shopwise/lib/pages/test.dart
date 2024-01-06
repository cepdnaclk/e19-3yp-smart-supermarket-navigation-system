
import 'package:flutter/material.dart';
import 'package:shopwise/pages/the_map.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:shopwise/services/mqtt_service.dart';




// import 'package:ndialog/ndialog.dart';

class MQTTClientTest extends StatefulWidget {
  const MQTTClientTest({Key? key}) : super(key: key);

  @override
  _MQTTClientTestState createState() => _MQTTClientTestState();
}

class _MQTTClientTestState extends State<MQTTClientTest> {
  
  
  bool isConnectionChanged = false;
  

  TextEditingController idTextController = TextEditingController();



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
    MQTT_Service.client.disconnect();
    super.dispose();
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

    // isConnected = await MQTT_Service.mqttConnect(idTextController.text.trim());
    
    MQTT_Service.isConnected = await MQTT_Service.mqttConnect(idTextController.text.trim());

    setState(() {
      isConnectionChanged = MQTT_Service.isConnected;
    });

    if (MQTT_Service.isConnected) {
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

    // if (isConnected) {
    //   // progressDialog.setTitle(Text("Connected"));
    //   // progressDialog.dismiss();
    // }

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

  // _connect() async {
  //   if (idTextController.text.trim().isNotEmpty) {
  //     // final ProgressDialog pr = ProgressDialog(context);

  //     // ProgressDialog progressDialog = ProgressDialog(context,
  //     //     blur: 0,
  //     //     dialogTransitionType: DialogTransitionType.Shrink,
  //     //     dismissable: false);
  //     // progressDialog.setLoadingWidget(CircularProgressIndicator(
  //     //   valueColor: AlwaysStoppedAnimation(Colors.red),
  //     // ));
  //     // progressDialog.setMessage(Text("wait, connecting to core"));
  //     // progressDialog.setTitle(Text("Connecting"));
  //     // progressDialog.show();

  //     // pr.show();

  //     // isConnected = await mqttConnect(idTextController.text.trim());

  //     // pr.hide().then((isHidden) {
  //     //   print(isHidden);
  //     // });
  //     // progressDialog.dismiss();
  //   }
  // }

  

 

  

  

  

 

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
              TheMap(directionStream: MQTT_Service.streamController.stream),
              // BarcodeReader()
            ],
          ),
        ),
      ),
    );
  }
}
