import 'dart:async';
import 'package:flutter/material.dart';
// import 'login_api.dart';
import 'loginpage.dart';
// import 'semesterpage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> updatePassword(
    String instructorId, String oldPassword, String newPassword) async {
  var headers = {
    'Content-Type': 'application/json',
    'Cookie': 'token=YOUR_TOKEN_HERE', // Replace with your token
  };

  var requestBody = {
    "instructor_id": instructorId,
    "password": oldPassword,
    "new_password": newPassword,
  };

  var uri =
      Uri.parse('https://newsdcattendance.onrender.com/updatePassword');

  var response =
      await http.post(uri, headers: headers, body: jsonEncode(requestBody));

  if (response.statusCode == 200) {
    // print(await http.Response.fromStream(response).body);
    print("Successful");
    // Handle success, e.g., show a success message to the user
  } else {
    print(response.reasonPhrase);
    // Handle error, e.g., show an error message to the user
  }
  ;
  // var context;
  // showDialog<void>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Password Changed Successfully'),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               Text('Your password has been updated successfully.'),
  //               Text('You can now log in with your new password.'),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text('OK'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               Navigator.of(context).pushReplacement(MaterialPageRoute(
  //                 builder: (context) => LoginScreen(),
  //               ));
  //             },
  //           ),
  //         ],
  //       );
  //     });
}

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final instructorIdController = TextEditingController();
  final _streamController = StreamController<String>();
  final TextEditingController instructorIdController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  var instructor_id = "";
  void showSuccessDialogAndNavigate() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Password Changed Successfully'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Your password has been updated successfully.'),
                Text('You can now log in with your new password.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    instructorIdController.addListener(_checkInput);
  }

  @override
  void dispose() {
    instructorIdController.dispose();
    _streamController.close();
    super.dispose();
  }

  void _checkInput() {
    String value = instructorIdController.text.trim();
    RegExp regExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%$#@!]+');
    if (regExp.hasMatch(value)) {
      _streamController.add('Input must not contain special characters');
    } else {
      _streamController.add('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text("Forgot Password"),
        
      ),
      
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Center(
                    child: Image.asset(
                      "assets/images/img_ggsipulogo1.png",
                      height: 132.00,
                      width: 150.00,
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.fromLTRB(43, 5, 43, 0),
                        child: Text(
                          "Guru Gobind Singh Indraprastha University",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(43, 10, 43, 0),
                        child: Text(
                          "East Delhi Campus",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.fromLTRB(43, 10, 43, 0),
                              child: Text(
                                "Reset Your Password",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomCenter,
                              padding: EdgeInsets.all(15),
                              child: SizedBox(
                                height: 400,
                                width: 364,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  color: Color.fromRGBO(4, 29, 83, 1),
                                  child: Form(
                                      key: _formKey,
                                      child: Column(children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 20, right: 20, top: 50),
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1),
                                          ),
                                          alignment: Alignment.center,
                                          child: TextFormField(
                                            cursorColor: Colors.black,
                                            decoration: InputDecoration(
                                              icon: Icon(
                                                Icons.email,
                                              ),
                                              hintText: "Enter ID",
                                              enabledBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                            ),
                                            controller: instructorIdController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Enter your ID";
                                              } else if (value != null) {
                                                RegExp regExp = RegExp(
                                                    r'[!@#<>?":_`~;[\]\\|=+)(*&^%$#@!]+');
                                                if (regExp.hasMatch(value)) {
                                                  return 'Input must not contain special characters';
                                                }
                                              }
                                              return null;
                                            },
                                            onChanged: (value) {
                                              setState(() {
                                                instructor_id = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        StreamBuilder<String>(
                                          stream: _streamController.stream,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData &&
                                                snapshot.data!.isNotEmpty) {
                                              return Icon(
                                                Icons.error,
                                                color: Colors.red,
                                              );
                                            } else {
                                              return Container();
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(
                                                left: 20, right: 20, top: 10),
                                            padding: EdgeInsets.only(
                                                left: 20, right: 20),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 1),
                                            ),
                                            alignment: Alignment.center,
                                            child: TextFormField(
                                              cursorColor: Colors.black,
                                              decoration: InputDecoration(
                                                icon: Icon(
                                                  Icons.vpn_key,
                                                ),
                                                hintText: "Old Password ",
                                                enabledBorder: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                              ),
                                              controller: oldPasswordController,
                                            )),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 20, right: 20, top: 10),
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1),
                                          ),
                                          alignment: Alignment.center,
                                          child: TextFormField(
                                            cursorColor: Colors.black,
                                            decoration: InputDecoration(
                                              icon: Icon(
                                                Icons.vpn_key,
                                              ),
                                              hintText: "New Password",
                                              enabledBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                            ),
                                            controller: newPasswordController,
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 20, right: 20, top: 30),
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                minimumSize: Size(327, 69),
                                                backgroundColor: Color.fromRGBO(
                                                    0, 70, 121, 1),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                              ),
                                              child: Text(
                                                "Reset Password",
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              onPressed: () async {
                                                String instructorId =
                                                    instructorIdController.text;
                                                String oldPassword =
                                                    oldPasswordController.text;
                                                String newPassword =
                                                    newPasswordController.text;
                                                updatePassword(instructorId,
                                                    oldPassword, newPassword);
                                                showSuccessDialogAndNavigate();
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  // Perform reset password logic here
                                                }
                                              }),
                                        ),
                                      ])),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
