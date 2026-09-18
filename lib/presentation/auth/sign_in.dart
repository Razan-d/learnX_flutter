import 'package:flutter/material.dart';
import 'package:learnx_flutter/service/auth.dart';

// نموذج (Object) لتخزين بيانات تسجيل الدخول
// class UserLogin {
//   final String email;
//   final String password;

//   UserLogin({this.email = "razan@g.com", this.password = "123456"});
// }

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthServices auth = AuthServices();
  // مفتاح الـ Form للتحقق من المدخلات
  final _formKey = GlobalKey<FormState>();

  // Controllers لحفظ النصوص المدخلة
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // متغير للتحكم في إظهار/إخفاء كلمة المرور
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // شريط أعلى الصفحة
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // رجوع للصفحة السابقة
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),

      // ScrollView حتى لا تختفي العناصر
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),

          // نموذج الإدخال
          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // عنوان الصفحة
                Text(
                  "تسجيل الدخول",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),

                Text(
                  "يرجى تسجيل الدخول باستخدام حسابك ",
                  style: TextStyle(fontSize: 15),
                ),

                SizedBox(height: 30),

                // ------------------------------
                // حقل البريد الإلكتروني
                // ------------------------------
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
                      controller: emailController, // ربط الحقل بالـ Controller

                      decoration: InputDecoration(
                        hintText: "ادخل البريد الالكتروني",
                        prefixIcon: Icon(Icons.email),

                        // الحدود العادية
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),

                        // عند التركيز
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),

                        // حدود الخطأ
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),

                        // حدود الخطأ عند التركيز
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),

                        // شكل نص الخطأ
                        errorStyle: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // التحقق من صحة البريد
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "البريد مطلوب";
                        }
                        if (!value.contains("@")) {
                          return "البريد غير صالح";
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                SizedBox(height: 25),

                // ------------------------------
                // حقل كلمة المرور + إظهار/إخفاء
                // ------------------------------
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
                      controller: passwordController,

                      // إخفاء أو إظهار كلمة المرور
                      obscureText: !isPasswordVisible,

                      decoration: InputDecoration(
                        hintText: "*******",
                        prefixIcon: Icon(Icons.password),

                        // زر العين لإظهار/إخفاء كلمة المرور
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),

                        // الحدود العادية
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),

                        // عند التركيز
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),

                        // حدود الخطأ
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),

                        // حدود الخطأ عند التركيز
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),

                        // شكل نص الخطأ
                        errorStyle: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // التحقق من صحة كلمة المرور
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "كلمة المرور مطلوبة";
                        }
                        if (value.length < 6) {
                          return "كلمة المرور يجب أن تكون 6 أحرف على الأقل";
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                SizedBox(height: 30),

                // ------------------------------
                // زر تسجيل الدخول
                // ------------------------------
                GestureDetector(
                  onTap: ()async{
                    if (_formKey.currentState!.validate()) {
                      try{
                      await auth.signIn(emailController.text.trim(), passwordController.text.trim());                                              
                      print("user sign in");
                        // نجاح تسجيل الدخول
                        if(mounted){
                        showDialog(
                          context:context,
                          builder: (context){
                          return AlertDialog(
                            // title: Text(
                            //   "تم تسجيل الدخول بنجاح",
                            //   style: TextStyle(
                            //     fontSize: 15,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                            content: Text(
                              "تم تسجيل الدخول بنجاح",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    "Home",
                                    (route) => false,
                                  );
                                },
                                child: Text("حسناً"),
                              ),
                            ],
                          );
                          }
                        );
                        }

                        // Navigator.pushNamed(context, "Home");

                      } catch (e) {
                        // رسالة خطأ عند عدم تطابق البيانات
                        if(mounted){
                        showDialog(
                          context:context,
                          builder: (context){
                          return AlertDialog(
                            title: Text(
                              "خطأ",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            content:Text(
                              "البريد أو كلمة المرور غير صحيحة",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("حسناً"),
                              ),
                            ],
                          );
                          
                          }
                        );
                        }

                        print("Login Failed");
                      }
                    }
                  },

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

                // ------------------------------
                // فاصل نصي
                // ------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 80, child: Divider(color: Colors.grey)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "أو سجّل الدخول باستخدام",
                        style: TextStyle(
                          fontSize: 15,
                          ),
                      ),
                    ),
                    SizedBox(width: 80, child: Divider(color: Colors.grey)),
                  ],
                ),

                SizedBox(height: 20),

                // ------------------------------
                // تسجيل الدخول عبر فيسبوك
                // ------------------------------
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
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                              ),
                        ),
                        SizedBox(width: 15),
                        Image.asset("assets/icon _facebookpng.png", width: 30),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // ------------------------------
                // تسجيل الدخول عبر قوقل
                // ------------------------------
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
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                              ),
                        ),
                        SizedBox(width: 15),
                        Image.asset("assets/icon_google.png", width: 40),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 40),

                // ------------------------------
                // الانتقال لصفحة التسجيل
                // ------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ليس لديك حساب؟",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
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
      ),
    );
  }
}
