import 'package:flutter/material.dart';
import  'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  String _locationMessage = "";

  void _submitData(String _l, String _t){
    String _location= _l;
    String _timestamp=_t;

    Firestore.instance.collection('Data').document()
        .setData({ 'Location': _location, 'timestamp': _timestamp });
  }

  void _getCurrentLocation() async {

    Position _position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    String sLocation =  _position.latitude.toString() + ', ' + _position.longitude.toString();
    String sTimestamp = new DateTime.now().millisecondsSinceEpoch.toString();
    //_locationMessage = "$sLocation, $sTimestamp";
    _submitData(sLocation, sTimestamp);
    print("Location recorded.");
    setState(() {
      _locationMessage = "$sLocation, $sTimestamp";
    });
  }


  int _tGap = 5;
  int _tRange = 12;
  // 5s * 12 = 60s = 1 min
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'LocRec',
        home: Scaffold(
            appBar: AppBar(
                title: Text("Location recorder")
            ),
            body: Align(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(_locationMessage),
                    FlatButton (
                        onPressed: ()  async {
                          for(var i = 0;i < _tRange;i++){

                            await _getCurrentLocation();
                            sleep(Duration(seconds:_tGap));
                          }
                          print("Recording finished.");
                        },
                        color: Colors.green,
                        child: Text("Start record")
                    )
                  ]),
            )
        )
    );
  }
}
