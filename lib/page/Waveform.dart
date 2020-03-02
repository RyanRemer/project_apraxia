import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/LocalWSDCalculator.dart';
import 'package:project_apraxia/interface/IWSDCalculator.dart';
import 'package:project_apraxia/widget/WaveformPainter.dart';

class Waveform extends StatelessWidget {
  final IWSDCalculator wsdCalculator = new LocalWSDCalculator();
  final String soundUri;
  Future<List<double>> amplitudes;

  Waveform(this.soundUri) {
    if(soundUri == null) {
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
              painter: WaveformPainter(snapshot.data, color: Theme.of(context).primaryColor),
            );
          });
        } else {
          return Container();
        }
      },
    );
  }
}
