import 'package:supabase_flutter/supabase_flutter.dart';

/// خدمة المصادقة وإدارة حسابات المستخدمين في Supabase Auth
class AuthServices {
  final supabase = Supabase.instance.client.auth;

  /// جلب بيانات كائن المستخدم الحالي المسجل
  User? get currentUser => supabase.currentUser;

  /// جلب الاسم الكامل للمستخدم الحالي
  String get userFullName {
    final meta = currentUser?.userMetadata;
    if (meta != null && meta['full_name'] != null && meta['full_name'].toString().isNotEmpty) {
      return meta['full_name'].toString();
    }
    if (currentUser?.email != null && currentUser!.email!.isNotEmpty) {
      return currentUser!.email!.split('@').first;
    }
    return "طالب LearnX";
  }

  /// جلب البريد الإلكتروني للمستخدم الحالي
  String get userEmail => currentUser?.email ?? "طالب@learnx.com";

  /// التحقق مما إذا كان المستخدم مسجلاً لدخوله حالياً
  bool get isLoggedIn => currentUser != null;

  /// إنشاء حساب جديد في Supabase
  Future<void> signUp(String fullName, String email, String password) async {
    await supabase.signUp(
      email: email.trim(),
      password: password.trim(),
      data: {
        'full_name': fullName.trim(),
      },
    );
  }

  /// تسجيل الدخول باستعمال البريد وكلمة المرور
  Future<void> signIn(String email, String password) async {
    await supabase.signInWithPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  /// تحديث بيانات الملف الشخصي (الاسم، البريد، كلمة المرور)
  Future<void> updateProfile({
    String? fullName,
    String? email,
    String? password,
  }) async {
    final Map<String, dynamic> metadata = {};
    if (fullName != null && fullName.trim().isNotEmpty) {
      metadata['full_name'] = fullName.trim();
    }

    final attributes = UserAttributes(
      email: (email != null && email.trim().isNotEmpty) ? email.trim() : null,
      password: (password != null && password.trim().isNotEmpty) ? password.trim() : null,
      data: metadata.isNotEmpty ? metadata : null,
    );

    await supabase.updateUser(attributes);
  }

  /// تسجيل الخروج من الحساب الحالي
  Future<void> signOut() async {
    await supabase.signOut();
  }
}