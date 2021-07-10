import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:dio/dio.dart';
import 'package:gotercrud/Utils/Constant.dart';
import 'Login.dart';
import 'EditPage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:gotercrud/Models/TaskList_model.dart';

class Home extends StatefulWidget {
  final String nama;
  const Home({Key key, this.nama}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var dio = Dio();

  var baseURL = url;

  Future<dynamic> sendMotivasi(String tsk) async {
    Map<String, dynamic> body = {
      "task": tsk,
    };

    try {
      Response response = await dio.post("$baseURL/api/create/task",
          data: body,
          options: Options(contentType: Headers.formUrlEncodedContentType));

      print("Respon -> ${response.data} + ${response.statusCode}");

      return response;
    } catch (e) {
      print("Error di -> $e");
    }
  }

  Future<dynamic> deletePost(int id) async {
    var response = await dio.delete(
      '$baseURL/api/deletetask/${id}',
    );

    print(" ${response.data}");
    return response.data;
  }

  List<Task> tsk = [];

  @override
  void initState() {
    super.initState();
    getData();
    _getData();
  }

  Future<TaskList> getData() async {
    var response = await dio.get('$baseURL/api/task');

    print(" ${response.data}");
    if (response.statusCode == 200) {
      var f = TaskList.fromJson(response.data);
      setState(() {
        f.data.forEach((element) {
          tsk.add(Task(id: element.id, task: element.task));
        });
      });
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<void> _getData() async {
    setState(() {
      getData();
      tsk.clear();
    });
  }

  TextEditingController taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 1.2,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hallo, ${widget.nama} ^-^",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    TextButton(
                        child: Icon(Icons.logout),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (BuildContext context) => Login()));
                        })
                  ],
                ),
                SizedBox(height: 20), // <-- Kasih Jarak Tinggi : 50px
                FormBuilderTextField(
                  controller: taskController,
                  attribute: "_",
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.only(left: 10),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      onPressed: () async {
                        await sendMotivasi(taskController.text.toString())
                            .then((value) => {
                                  if (value != null)
                                    {
                                      Flushbar(
                                        message: "Berhasil Submit",
                                        duration: Duration(seconds: 2),
                                        backgroundColor: Colors.greenAccent,
                                        flushbarPosition: FlushbarPosition.TOP,
                                      ).show(context)
                                    }
                                });

                        _getData();

                        print("Sukses");
                      },
                      child: Text("Submit")),
                ),
                TextButton(
                  child: Icon(Icons.refresh),
                  onPressed: () {
                    _getData();
                  },
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: tsk.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(tsk[index].task),
                            Row(
                              children: [
                                TextButton(
                                  child: Icon(Icons.settings),
                                  onPressed: () {
                                    String id;
                                    String isi_motivasi;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              EditPage(
                                                  id: tsk[index].id,
                                                  task: tsk[index].task),
                                        ));
                                  },
                                ),
                                TextButton(
                                  child: Icon(Icons.delete),
                                  onPressed: () {
                                    print(tsk[index].id.toString());
                                    deletePost(tsk[index].id).then((value) => {
                                          if (value != null)
                                            {
                                              Flushbar(
                                                message: "Berhasil Delete",
                                                duration: Duration(seconds: 2),
                                                backgroundColor:
                                                    Colors.redAccent,
                                                flushbarPosition:
                                                    FlushbarPosition.TOP,
                                              ).show(context)
                                            }
                                        });

                                    _getData();
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}

class Task {
  Task({
    this.id,
    this.task,
  });

  int id;
  String task;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        task: json["task"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "task": task,
      };
}
