import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_apraxia/controller/HttpConnector.dart';
import 'package:project_apraxia/model/Attempt.dart';
import 'package:project_apraxia/model/Evaluation.dart';

class EvaluationViewPage extends StatefulWidget {
  final Evaluation evaluation;

  EvaluationViewPage({@required this.evaluation, Key key}) : super(key: key);

  @override
  _EvaluationViewPageState createState() =>
      _EvaluationViewPageState(this.evaluation);
}

class _EvaluationViewPageState extends State<EvaluationViewPage> {
  final Evaluation evaluation;
  final HttpConnector httpConnector = HttpConnector.instance();
  final DateFormat dateFormat = new DateFormat.yMMMMEEEEd();
  Future fetchAttempts;

  _EvaluationViewPageState(this.evaluation) {
    fetchAttempts = httpConnector.getAttempts(evaluation.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Evaluation"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("ID"),
            trailing: Text(widget.evaluation.id),
          ),
          ListTile(
            title: Text("Age"),
            trailing: Text(widget.evaluation.age),
          ),
          ListTile(
            title: Text("Gender"),
            trailing: Text(widget.evaluation.gender),
          ),
          ListTile(
            title: Text("Impression"),
            trailing: Text(widget.evaluation.impression),
          ),
          ListTile(
            title: Text("Date Created"),
            trailing: Text(widget.evaluation.dateCreated),
          ),
          const Divider(),
          _buildAttempts(),
        ],
      ),
    );
  }

  FutureBuilder _buildAttempts() {
    return FutureBuilder(
      future: fetchAttempts,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(snapshot.error.toString()),
            ),
          );
        }

        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              Column(
                children: snapshot.data.map<Widget>((attempt) {
                  return ListTile(
                    leading: attempt.active
                        ? Icon(Icons.check_box)
                        : Icon(Icons.check),
                    title: Text(attempt.word),
                    trailing: Text(
                      attempt.wsd.toStringAsFixed(3),
                    ),
                  );
                }).toList(),
              ),
              const Divider(),
              ListTile(
                title: Text("Average WSD:"),
                trailing: Text(getAverageWSD(snapshot.data).toStringAsFixed(3)),
              )
            ],
          );
        } else {
          return ListTile(
            leading: CircularProgressIndicator(),
            title: Text("Loading Attempts..."),
          );
        }
      },
    );
  }

  double getAverageWSD(List<Attempt> attempts) {
    double sum = attempts
        .where((attempt) => attempt.active)
        .fold(0.0, (value, attempt) => value + attempt.wsd);

    return sum / attempts.length;
  }
}
