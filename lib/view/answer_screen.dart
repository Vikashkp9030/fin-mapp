import 'package:fin_mapp/model/question_model.dart';
import 'package:flutter/material.dart';

class AnswerScreen extends StatelessWidget {
  final QuestionModel questionModel;
  const AnswerScreen({super.key, required this.questionModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: const Text(
          'Answer',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...?questionModel.schema?.fields?.map((e) {
                int i = questionModel.schema?.fields?.indexWhere((element) =>
                        element.schema?.label == e.schema?.label) ??
                    -1;
                return questionAnswer(data: e, inx1: i);
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget questionAnswer({required Fields data, required int inx1, int? idx2}) {
    if (data.type == 'Section') {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...?data.schema?.fields?.map((e) {
              int? i = data.schema?.fields?.indexWhere(
                  (element) => element.schema?.label == e.schema?.label);
              return questionAnswer(data: e, inx1: inx1, idx2: i);
            })
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question ${inx1 + 1}.${idx2 != null ? (idx2 + 1) : ''} : ${data.schema!.label}',
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          ),
          const SizedBox(
            height: 8,
          ),
          Text('Answer : ${data.schema!.answer ?? ''}'),
        ],
      ),
    );
  }
}
