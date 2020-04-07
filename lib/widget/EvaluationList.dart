import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_apraxia/controller/HttpConnector.dart';
import 'package:project_apraxia/model/Evaluation.dart';
import 'package:project_apraxia/page/EvaluationViewPage.dart';

class EvaluationList extends StatefulWidget {
  const EvaluationList({Key key}) : super(key: key);

  @override
  _EvaluationListState createState() => _EvaluationListState();
}

class _EvaluationListState extends State<EvaluationList> {
  HttpConnector httpConnector = new HttpConnector.instance();
  Future<List<Evaluation>> fetchEvaluations;
  DateFormat dateFormat = new DateFormat.yMMMMEEEEd();

  _EvaluationListState() {
    fetchEvaluations = httpConnector.getEvaluations();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Evaluation>>(
      future: fetchEvaluations,
      builder:
          (BuildContext context, AsyncSnapshot<List<Evaluation>> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        if (snapshot.hasData == false) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.data.isEmpty) {
          return Center(
            child: Text("No previous evaluations found for the current user."),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            Evaluation evaluation = snapshot.data[index];

            return Card(
              child: ListTile(
                title: Text(dateFormat.format(evaluation.dateCreated)),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EvaluationViewPage(evaluation: evaluation)),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
