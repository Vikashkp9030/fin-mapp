import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../model/question_model.dart';

class HomeController extends GetxController {
  var questionModel = QuestionModel();
  int index = -1;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    String data =
        await rootBundle.loadString('assets/json_file/Questions.json');
    questionModel = QuestionModel.fromJson(json.decode(data));
    if (questionModel.schema != null &&
        questionModel.schema!.fields != null &&
        questionModel.schema!.fields!.isNotEmpty) {
      index = 0;
      update();
    }
  }
}
