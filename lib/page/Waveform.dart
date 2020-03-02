import 'package:flutter/material.dart';
import 'package:project_apraxia/model/Recording.dart';
import 'package:project_apraxia/controller/LocalWSDCalculator.dart';
import 'package:project_apraxia/interface/IWSDCalculator.dart';
import 'package:project_apraxia/widget/WaveformPainter.dart';

class Waveform extends StatefulWidget {
  final Recording selectedRecording;

  Waveform(this.selectedRecording);

  @override
  _WaveformState createState() => _WaveformState(this.selectedRecording);
}

class _WaveformState extends State<Waveform> {
  Future<List<double>> amplitudes;
  final Recording selectedRecording;

  _WaveformState(this.selectedRecording) {
    if (selectedRecording == null) {
      this.amplitudes = null;
    } else {
      IWSDCalculator wsdCalculator = new LocalWSDCalculator();
      this.amplitudes = wsdCalculator.getAmplitudes(selectedRecording.soundFile.path);
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
