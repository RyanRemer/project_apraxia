import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/LocalWSDCalculator.dart';
import 'package:project_apraxia/interface/IWSDCalculator.dart';
import 'package:project_apraxia/widget/AppTheme.dart';
import 'package:project_apraxia/widget/WaveformPainter.dart';

class Waveform extends StatefulWidget {
  final String soundUri;

  Waveform(this.soundUri, {Key key}) : super(key: key);

  @override
  _WaveformState createState() {
    return new _WaveformState(this.soundUri);
    }
}

class _WaveformState extends State<Waveform> {
  final IWSDCalculator wsdCalculator = new LocalWSDCalculator();
  Future<List<double>> amplitudes;

  _WaveformState(String soundUri) {
    if (soundUri == null) {
      this.amplitudes = null;
    } else {
      this.amplitudes = wsdCalculator.getAmplitudes(soundUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: amplitudes,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return CustomPaint(
              size: Size(constraints.biggest.width, constraints.biggest.height),
              painter: WaveformPainter(snapshot.data,
                  color: AppTheme.of(context).primaryLight),
            );
          });
        } else {
          return Container();
        }
      },
    );
  }
}
