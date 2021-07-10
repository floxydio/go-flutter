import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:convert';

import 'package:gotercrud/Utils/Constant.dart';
import 'package:flushbar/flushbar.dart';
import 'package:gotercrud/Models/TaskList_model.dart';

import 'package:flushbar/flushbar.dart';
import 'package:dio/dio.dart';

class EditPage extends StatefulWidget {
  final int id;
  final String task;
  const EditPage({Key key, this.id, this.task}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  String baseurl = url;

  var dio = Dio();
  Future<dynamic> putPost(String task) async {
    Map<String, dynamic> data = {"task": task};
    var response = await dio.put('$baseurl/api/task/${widget.id}',
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ));

    print("---> ${response.data} + ${response.statusCode}");

    return response.data;
  }

  TextEditingController taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit"),
      ),
      body: SafeArea(
          child: Container(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${widget.task}"),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.4,
                  child: FormBuilderTextField(
                    attribute: "_",
                    controller: taskController,
                    decoration: InputDecoration(
                      labelText: "New Data",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.only(left: 10),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      putPost(taskController.text).then((value) => {
                            if (value != null)
                              {
                                Navigator.pop(context),
                                Flushbar(
                                  message: "Berhasil Update & Refresh dlu",
                                  duration: Duration(seconds: 5),
                                  backgroundColor: Colors.green,
                                  flushbarPosition: FlushbarPosition.TOP,
                                ).show(context)
                              }
                          });
                    },
                    child: Text("Submit"))
              ],
            ),
          ),
        ),
      )),
    );
  }
}
