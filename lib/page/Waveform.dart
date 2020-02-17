import 'package:flutter/material.dart';
import 'package:project_apraxia/model/Recording.dart';
import 'package:project_apraxia/controller/LocalWSDCalculator.dart';
import 'package:project_apraxia/interface/IWSDCalculator.dart';
import 'package:project_apraxia/widget/WaveformPainter.dart';
import 'package:project_apraxia/data/WaveformStorage.dart';

class Waveform extends StatelessWidget {
  final IWSDCalculator wsdCalculator = new LocalWSDCalculator();
  WaveformStorage waveformStorage = WaveformStorage();
  Recording selectedRecording;
  Future<List<double>> amplitudes;

  Waveform(this.selectedRecording) {
    this.amplitudes =
        waveformStorage.wsdGetAmplitudes(selectedRecording) ?? new List();
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
              painter: WaveformPainter(snapshot.data),
            );
          });
        } else {
          return Container();
        }
      },
    );
  }
}
