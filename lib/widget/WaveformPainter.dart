import 'package:flutter/material.dart';
import 'dart:math';
class WaveformPainter extends CustomPainter {

  final List<double> amplitudesForWaveform;
  Paint painter;
  final Color color;
  final double strokeWidth;

  WaveformPainter(this.amplitudesForWaveform,
  {this.strokeWidth = 1.0, this.color = Colors.black}) {
    painter = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {

    final pathToDraw = drawPoints(normalizeData(amplitudesForWaveform), size);
    canvas.drawPath(pathToDraw, painter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  List<double> normalizeData(List<double> data) {
    List<double> newData = new List();

    var maxValue = 0.5;
    
    for (var i = 0; i < data.length; i++) {
      var currVal = data[i];
      newData.add(currVal / maxValue);
    }

    return newData;
  }

  Path drawPoints(List<double> data, Size size) {
    final middleOfFrame = size.height / 2;

    List<Offset> points = [];

    final partOfFrameForEachPoint = size.width / data.length;

    for (var i = 0; i < data.length; i++) {
      var currVal = data[i];
      points.add(Offset(partOfFrameForEachPoint * i, middleOfFrame - middleOfFrame * currVal));
    }

    final path = Path();
    path.moveTo(0, middleOfFrame);
    points.forEach((o) => path.lineTo(o.dx, o.dy));
    path.lineTo(size.width, middleOfFrame);

    path.close();
    return path;
  }
}