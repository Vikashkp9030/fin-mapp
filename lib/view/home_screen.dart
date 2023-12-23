import 'package:fin_mapp/controller/home_controller.dart';
import 'package:fin_mapp/model/question_model.dart';
import 'package:fin_mapp/view/answer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({super.key});
  @override
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: controller,
        builder: (_) => Scaffold(
              body: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
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
                            if (controller.index !=
                                controller.questionModel.schema?.fields?.length)
                              Row(
                                children: [
                                  ...?controller.questionModel.schema?.fields
                                      ?.map(
                                    (e) {
                                      int idx = controller
                                              .questionModel.schema?.fields
                                              ?.indexWhere((element) =>
                                                  element.schema?.name ==
                                                  e.schema?.name) ??
                                          -1;
                                      return Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: idx == 0 ? 0 : 8),
                                          child: Divider(
                                            thickness: 4,
                                            color: idx <= controller.index
                                                ? Colors.green
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
                            questionAnswer(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: backAndNextButton(context),
            ));
  }

  Widget questionAnswer() {
    if (controller.questionModel.schema?.fields?[controller.index].type ==
        'Section') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Text(
              '${controller.index + 1}. ${controller.questionModel.schema?.fields?[controller.index].schema?.label}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            ...?controller
                .questionModel.schema?.fields?[controller.index].schema?.fields
                ?.map((e) {
              if (e.type == 'SingleChoiceSelector' ||
                  e.type == 'SingleSelect') {
                int idx = controller.questionModel.schema
                        ?.fields?[controller.index].schema?.fields
                        ?.indexWhere((element) =>
                            element.schema?.label == e.schema?.label) ??
                    -1;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        '${controller.index + 1}.${idx + 1}. ${e.schema?.label}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                    ...?e.schema?.options?.map((e1) => optionField(
                        data: e1,
                        isSection: controller.questionModel.schema
                                ?.fields?[controller.index].type ==
                            'Section',
                        idx: controller.questionModel.schema
                                ?.fields?[controller.index].schema?.fields
                                ?.indexWhere((element) =>
                                    element.schema?.name == e.schema?.name) ??
                            -1)),
                  ],
                );
              }
              return numericField(
                  data: e,
                  idx: controller.questionModel.schema
                          ?.fields?[controller.index].schema?.fields
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
              '${controller.index + 1}. ${controller.questionModel.schema?.fields?[controller.index].schema?.label}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            ...?controller
                .questionModel.schema?.fields?[controller.index].schema?.options
                ?.map((e) => optionField(
                    data: e,
                    idx: controller.questionModel.schema
                            ?.fields?[controller.index].schema?.options
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
        Text('${controller.index + 1}.${idx + 1}. ${data.schema?.label}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        const SizedBox(
          height: 16,
        ),
        TextFormField(
          initialValue: controller.questionModel.schema!
              .fields![controller.index].schema!.fields![idx].schema!.answer,
          cursorColor: Colors.deepOrangeAccent,
          keyboardType: controller.questionModel.schema!
                      .fields![controller.index].schema!.fields![idx].type ==
                  'Numeric'
              ? TextInputType.number
              : TextInputType.text,
          inputFormatters: controller.questionModel.schema!
                      .fields![controller.index].schema!.fields![idx].type ==
                  'Numeric'
              ? [
                  FilteringTextInputFormatter.digitsOnly,
                ]
              : null,
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
            controller.questionModel.schema!.fields![controller.index].schema!
                .fields![idx].schema!.answer = val;
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
                  controller.questionModel.schema!.fields![controller.index]
                          .schema!.fields![idx].schema!.answer ==
                      data.value)
              ? Colors.deepOrangeAccent
              : controller.questionModel.schema!.fields![controller.index]
                          .schema!.answer ==
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
              ? controller.questionModel.schema!.fields![controller.index]
                      .schema!.fields![idx].schema!.answer ==
                  data.value
              : controller.questionModel.schema!.fields![controller.index]
                      .schema!.answer ==
                  data.value,
          onChanged: (bool? value) {
            if (isSection) {
              if (controller.questionModel.schema!.fields![controller.index]
                      .schema!.fields![idx].schema!.answer ==
                  data.value) {
                controller.questionModel.schema!.fields![controller.index]
                    .schema!.fields![idx].schema!.answer = null;
                controller.update();
              } else {
                controller.questionModel.schema!.fields![controller.index]
                    .schema!.fields![idx].schema!.answer = data.value;
                controller.update();
              }
            } else {
              if (controller.questionModel.schema!.fields![controller.index]
                      .schema!.answer ==
                  data.value) {
                controller.questionModel.schema!.fields![controller.index]
                    .schema!.answer = null;
                controller.update();
              } else {
                controller.questionModel.schema!.fields![controller.index]
                    .schema!.answer = data.value;
                controller.update();
              }
            }
          },
        ),
        title: Text(
          data.value ?? '',
          style: TextStyle(
              color: controller.questionModel.schema!.fields![controller.index]
                          .schema!.answer ==
                      data.value
                  ? Colors.deepOrangeAccent
                  : null),
        ),
      ),
    );
  }

  Widget backAndNextButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
              onPressed: () {
                if (controller.index > 0) {
                  if (controller.index == 1) {
                    controller.loadData();
                  }
                  controller.index--;
                  controller.update();
                }
              },
              child: const Text(
                '< Back',
                style: TextStyle(color: Colors.black54),
              )),
          FloatingActionButton(
            backgroundColor: Colors.deepOrangeAccent,
            onPressed: () {
              if (controller.questionModel.schema != null &&
                  controller.questionModel.schema!.fields != null &&
                  controller.questionModel.schema!.fields!.length - 1 >
                      controller.index &&
                  (controller.questionModel.schema?.fields?[controller.index]
                              .type ==
                          'Section' ||
                      controller.questionModel.schema!.fields![controller.index]
                              .schema!.answer !=
                          null)) {
                if (controller.questionModel.schema!.fields![controller.index]
                        .schema!.answer ==
                    'Balance transfer & Top-up') {
                  controller.questionModel.schema!.fields!.removeWhere(
                      (element) =>
                          element.schema?.name ==
                          'Existing bank where loan exists');
                }
                controller.index++;
                controller.update();
              } else if (controller.questionModel.schema!.fields!.length - 1 ==
                  controller.index) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AnswerScreen(
                            questionModel: controller.questionModel,
                          )),
                ).then((value) => controller.loadData);
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
      ),
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
