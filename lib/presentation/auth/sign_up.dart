import 'package:flutter/material.dart';
import 'package:learnx_flutter/service/auth.dart';

// نموذج بيانات التسجيل
// class UserSignUp {
//   final String fullName;
//   final String email;
//   final String password;

//   UserSignUp({
//     required this.fullName,
//     required this.email,
//     required this.password,
//   });
// }

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  AuthServices auth = AuthServices();
  // مفتاح الـ Form
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // إظهار/إخفاء كلمة المرور
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),

      // إصلاح مشكلة اختفاء العناصر
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),

          child: Form(
            key: _formKey, // ربط الـ Form

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // العنوان
                Text(
                  " إنشاء حساب",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  " أنشئ حساباً لتبدأ رحلتك التعليمية ",
                  style: TextStyle(fontSize: 15),
                ),

                SizedBox(height: 30),

                // ------------------------------
                // الاسم الكامل
                // ------------------------------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      " الاسم الكامل",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),

                    TextFormField(
                      controller: fullNameController,
                      decoration: InputDecoration(
                        hintText: "ادخل الاسم الكامل",
                        prefixIcon: Icon(Icons.person),
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

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "الاسم مطلوب";
                        }
                        if (value.length < 3) {
                          return "الاسم يجب أن يكون أطول من 3 أحرف";
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // ------------------------------
                // البريد الإلكتروني
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
                      controller: emailController,
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

                SizedBox(height: 20),

                // ------------------------------
                // كلمة المرور
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
                      obscureText: !isPasswordVisible,

                      decoration: InputDecoration(
                        hintText: "*******",
                        prefixIcon: Icon(Icons.password),

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

                SizedBox(height: 25),

                // ------------------------------
                // تأكيد كلمة المرور
                // ------------------------------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      " تأكيد كلمة المرور",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),

                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: !isConfirmPasswordVisible,

                      decoration: InputDecoration(
                        hintText: "*******",
                        prefixIcon: Icon(Icons.password),

                        suffixIcon: IconButton(
                          icon: Icon(
                            isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              isConfirmPasswordVisible =
                                  !isConfirmPasswordVisible;
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

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "يرجى تأكيد كلمة المرور";
                        }
                        if (value != passwordController.text) {
                          return "كلمة المرور غير متطابقة";
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                SizedBox(height: 30),

                // ------------------------------
                // زر إنشاء الحساب
                // ------------------------------
                GestureDetector(
                  onTap: () async{
                    if (_formKey.currentState!.validate()) {
                      try{
                     await auth.signUp(fullNameController.text.trim(),emailController.text.trim(), passwordController.text.trim());                       

                      print("User Created");
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
                              "تم أنشاء الحساب بنجاح",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  Navigator.pushNamed(context, "SignIn");
                                },
                                child: Text("حسناً"),
                              ),
                            ],
                          );
                          }
                        );
                        }
                    } catch (e){
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
                              ),
                            ),
                            content: Text(
                              "يرجى تعبئة جميع الحقول بشكل صحيح",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                          ),
                          actions: [
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                },
                                child: Text("حسناً"),
                                  ),
                            ],
                          );
                          
                          }
                        );
                        }
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
                      " إنشاء حساب",
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
                // الفاصل
                // ------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 80, child: Divider(color: Colors.grey)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "أو سجّل باستخدام",
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
                // فيسبوك
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
                          "سجّل باستخدام فيسبوك",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
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
                // قوقل
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
                          "  سجّل باستخدام قوقل",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
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
                // تسجيل الدخول
                // ------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "هل لديك حساب بالفعل؟ ",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "SignIn");
                      },
                      child: Text(
                        "سجّل الدخول هنا",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color.fromRGBO(0, 48, 150, 1),
                          fontWeight: FontWeight.bold,
                          ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
