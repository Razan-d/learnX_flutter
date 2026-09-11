import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed:() {
          Navigator.pop(context);
        },
         icon: Icon(Icons.arrow_back, color: Colors.black,),
         ),
      ),
      body: ListView(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // العنوان
                  Text(
                    "تسجيل الدخول",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "يرجى تسجيل الدخول باستخدام حسابك ",
                    style: TextStyle(fontSize: 15),
                  ),

                  SizedBox(height: 30),

                  // البريد
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        " البريد الالكتروني",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "ادخل البريد الالكتروني",
                          prefixIcon: Icon(Icons.email),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),

                  // كلمة المرور
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        " كلمة المرور",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "*******",
                          prefixIcon: Icon(Icons.password),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        "نسيت كلمة المرور؟",
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ),
                  ),

                  SizedBox(height: 30),

                  // زر تسجيل الدخول
                  GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 48, 150, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "تسجيل الدخول",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 25),

                  // الفاصل
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 80, child: Divider(color: Colors.grey)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "أو سجّل الدخول باستخدام",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      SizedBox(width: 80, child: Divider(color: Colors.grey)),
                    ],
                  ),

                  SizedBox(height: 20),

                  // فيسبوك
                  GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "تسجيل الدخول باستخدام فيسبوك",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          SizedBox(width: 15),
                          Image.asset(
                            "assets/icon _facebookpng.png",
                            width: 30,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  // قوقل
                  GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "تسجيل الدخول باستخدام قوقل",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                          SizedBox(width: 15),
                          Image.asset("assets/icon_google.png", width: 40),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 40),

                  // تسجيل جديد
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("ليس لديك حساب؟", style: TextStyle(fontSize: 15)),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "SignUp");
                        },
                        child: Text(
                          "سجّل هنا",
                          style: TextStyle(
                            fontSize: 15,
                            color: Color.fromRGBO(0, 48, 150, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
