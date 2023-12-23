import 'dart:convert';

import 'package:fin_mapp/model/question_model.dart';
import 'package:fin_mapp/view/answer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var questionModel = QuestionModel();
  @override
  void initState() {
    super.initState();
    loadData();
  }

  int index = -1;
  Future<void> loadData() async {
    String data =
        await rootBundle.loadString('assets/json_file/Questions.json');
    setState(() {
      questionModel = QuestionModel.fromJson(json.decode(data));
      if (questionModel.schema != null &&
          questionModel.schema!.fields != null &&
          questionModel.schema!.fields!.isNotEmpty) {
        index = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.82,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'About Loan',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      if (index != questionModel.schema?.fields?.length)
                        Row(
                          children: [
                            ...?questionModel.schema?.fields?.map(
                              (e) {
                                int idx = questionModel.schema?.fields
                                        ?.indexWhere((element) =>
                                            element.schema?.name ==
                                            e.schema?.name) ??
                                    -1;
                                return Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: idx == 0 ? 0 : 8),
                                    child: Divider(
                                      thickness: 4,
                                      color: idx <= index
                                          ? Colors.blue
                                          : Colors.black45,
                                    ),
                                  ),
                                );
                              },
                            ).toList()
                          ],
                        ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                          height: 600,
                          child:
                              SingleChildScrollView(child: questionAnswer())),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              backAndNextButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget questionAnswer() {
    if (questionModel.schema?.fields?[index].type == 'Section') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Text(
              '${index + 1}. ${questionModel.schema?.fields?[index].schema?.label}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            ...?questionModel.schema?.fields?[index].schema?.fields?.map((e) {
              if (e.type == 'SingleChoiceSelector' ||
                  e.type == 'SingleSelect') {
                int idx = questionModel.schema?.fields?[index].schema?.fields
                        ?.indexWhere((element) =>
                            element.schema?.label == e.schema?.label) ??
                    -1;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        '${index + 1}.${idx + 1}. ${e.schema?.label}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                    ...?e.schema?.options?.map((e1) => optionField(
                        data: e1,
                        isSection: questionModel.schema?.fields?[index].type ==
                            'Section',
                        idx: questionModel.schema?.fields?[index].schema?.fields
                                ?.indexWhere((element) =>
                                    element.schema?.name == e.schema?.name) ??
                            -1)),
                  ],
                );
              }
              return numericField(
                  data: e,
                  idx: questionModel.schema?.fields?[index].schema?.fields
                          ?.indexWhere((element) =>
                              element.schema?.name == e.schema?.name) ??
                      -1);
            })
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${index + 1}. ${questionModel.schema?.fields?[index].schema?.label}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            ...?questionModel.schema?.fields?[index].schema?.options?.map((e) =>
                optionField(
                    data: e,
                    idx: questionModel.schema?.fields?[index].schema?.options
                            ?.indexWhere((element) => element.key == e.key) ??
                        -1)),
          ],
        ),
      );
    }
  }

  Widget numericField({required Fields data, required int idx}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 16,
        ),
        Text('${index + 1}.${idx + 1}. ${data.schema?.label}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        const SizedBox(
          height: 16,
        ),
        TextFormField(
          initialValue: questionModel
              .schema!.fields![index].schema!.fields![idx].schema!.answer,
          cursorColor: Colors.deepOrangeAccent,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepOrangeAccent),
            ),
            hintText: 'Answer',
          ),
          onChanged: (val) {
            questionModel.schema!.fields![index].schema!.fields![idx].schema!
                .answer = val;
          },
        ),
      ],
    );
  }

  Widget optionField(
      {required Options data, required int idx, bool isSection = false}) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: (isSection &&
                  questionModel.schema!.fields![index].schema!.fields![idx]
                          .schema!.answer ==
                      data.value)
              ? Colors.deepOrangeAccent
              : questionModel.schema!.fields![index].schema!.answer ==
                      data.value
                  ? Colors.deepOrangeAccent
                  : Colors.black26,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        leading: Radio<bool>(
          value: true,
          toggleable: true,
          activeColor: Colors.deepOrangeAccent,
          groupValue: isSection
              ? questionModel.schema!.fields![index].schema!.fields![idx]
                      .schema!.answer ==
                  data.value
              : questionModel.schema!.fields![index].schema!.answer ==
                  data.value,
          onChanged: (bool? value) {
            if (isSection) {
              if (questionModel.schema!.fields![index].schema!.fields![idx]
                      .schema!.answer ==
                  data.value) {
                setState(() {
                  questionModel.schema!.fields![index].schema!.fields![idx]
                      .schema!.answer = null;
                });
              } else {
                setState(() {
                  questionModel.schema!.fields![index].schema!.fields![idx]
                      .schema!.answer = data.value;
                });
              }
            } else {
              if (questionModel.schema!.fields![index].schema!.answer ==
                  data.value) {
                setState(() {
                  questionModel.schema!.fields![index].schema!.answer = null;
                });
              } else {
                setState(() {
                  questionModel.schema!.fields![index].schema!.answer =
                      data.value;
                });
              }
            }
          },
        ),
        title: Text(
          data.value ?? '',
          style: TextStyle(
              color: questionModel.schema!.fields![index].schema!.answer ==
                      data.value
                  ? Colors.deepOrangeAccent
                  : null),
        ),
      ),
    );
  }

  Widget backAndNextButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
            onPressed: () {
              if (index > 0) {
                setState(() {
                  if (index == 1) {
                    loadData();
                  }
                  index--;
                });
              }
            },
            child: const Text(
              '< Back',
              style: TextStyle(color: Colors.black54),
            )),
        FloatingActionButton(
          backgroundColor: Colors.deepOrangeAccent,
          onPressed: () {
            if (questionModel.schema != null &&
                questionModel.schema!.fields != null &&
                questionModel.schema!.fields!.length - 1 > index &&
                (questionModel.schema?.fields?[index].type == 'Section' ||
                    questionModel.schema!.fields![index].schema!.answer !=
                        null)) {
              setState(() {
                if (questionModel.schema!.fields![index].schema!.answer ==
                    'Balance transfer & Top-up') {
                  questionModel.schema!.fields!.removeWhere((element) =>
                      element.schema?.name ==
                      'Existing bank where loan exists');
                }
                index++;
              });
            } else if (questionModel.schema!.fields!.length - 1 == index) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AnswerScreen(
                          questionModel: questionModel,
                        )),
              ).then((value) => loadData);
            } else {
              showSnackbar(context);
            }
          },
          child: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
          ),
        )
      ],
    );
  }

  void showSnackbar(BuildContext context) {
    final snackBar = SnackBar(
      content: const Text(
        'Please select answer',
        style: TextStyle(color: Colors.white),
      ),
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.up,
      backgroundColor: Colors.redAccent,
      action: SnackBarAction(
        label: 'Cancel',
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
