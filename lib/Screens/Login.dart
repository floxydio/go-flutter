import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:dio/dio.dart';
import 'package:gotercrud/Utils/Constant.dart';
import 'Home.dart';
import 'package:flutter/gestures.dart';
import 'package:gotercrud/Models/Login_model.dart';

import 'Register.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  var dio = Dio();

  var baseURL = url;

  String nama;

  Future<LoginModel> postLogin(String email, String password) async {
    Map<String, dynamic> data = {"email": email, "password": password};
    try {
      final response = await dio.post("$baseURL/api/login",
          data: data,
          options: Options(contentType: Headers.formUrlEncodedContentType));

      print("Respon -> ${response.data} + ${response.statusCode}");

      if (response.statusCode == 200) {
        final log = LoginModel.fromJson(response.data);

        return log;
      }
    } catch (e) {
      print("Failed To Load $e");
    }
  }

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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Login Area",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  FormBuilder(
                    key: _fbKey,
                    child: Column(
                      children: [
                        FormBuilderTextField(
                          validators: [FormBuilderValidators.email()],
                          controller: emailController,
                          attribute: "_",
                          decoration: InputDecoration(
                              labelText: "Email",
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.only(left: 20.0)),
                        ),
                        SizedBox(height: 20),
                        FormBuilderTextField(
                          obscureText: true,
                          validators: [FormBuilderValidators.required()],
                          controller: passwordController,
                          attribute: "_",
                          decoration: InputDecoration(
                              labelText: "Password",
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.only(left: 20.0)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Dont Have Account ? ',
                                style: TextStyle(color: Colors.black54),
                              ),
                              TextSpan(
                                  text: 'Sign Up',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  new Register()));
                                    },
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blueAccent,
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () async {
                              await postLogin(emailController.text,
                                      passwordController.text)
                                  .then((value) => {
                                        if (value != null)
                                          {
                                            setState(() {
                                              nama = value.name;

                                              Navigator.pushReplacement(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          new Home(
                                                              nama: nama)));
                                            })
                                          }
                                      });
                            },
                            child: Text("Login"),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
