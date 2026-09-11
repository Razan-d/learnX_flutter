import 'package:flutter/material.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, "SignIn");
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "تخطي",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // الصورة
              Image.asset("assets/onBoarding.png", width: 300, height: 300),

              SizedBox(height: 20),

              // العنوان
              Text(
                "انضم إلى LearnX للبدء في درسك",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 20),

              // النص
              Text(
                "انضم إلينا وتعلّم من نخبة مدربينا!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 40),

              // الأزرار جنب بعض
              Row(
                children: [
                  // زر  تسجيل الدخول
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "SignIn");
                      },
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(0, 48, 150, 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          " تسجيل الدخول",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 10),

                  // زرانشاء حساب
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "SignUp");
                      },
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "إنشاء حساب",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
