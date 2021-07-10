// To parse this JSON data, do
//
//     final taskList = taskListFromJson(jsonString);

import 'dart:convert';

TaskList taskListFromJson(String str) => TaskList.fromJson(json.decode(str));

String taskListToJson(TaskList data) => json.encode(data.toJson());

class TaskList {
  TaskList({
    this.data,
    this.message,
  });

  List<Datum> data;
  String message;

  factory TaskList.fromJson(Map<String, dynamic> json) => TaskList(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class Datum {
  Datum({
    this.id,
    this.task,
  });

  int id;
  String task;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        task: json["task"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "task": task,
      };
}
