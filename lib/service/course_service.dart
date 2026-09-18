import 'package:flutter/foundation.dart';
import 'package:learnx_flutter/models/coures_model.dart';
import 'package:learnx_flutter/service/supabase_db_service.dart';

/// خدمة إدارة بيانات الكورسات والتفاعل مع الواجهات
class CourseService {
  static final CourseService _instance = CourseService._internal();
  factory CourseService() => _instance;
  CourseService._internal() {
    loadUserDataFromSupabase();
  }

  final SupabaseDbService _dbService = SupabaseDbService();

  /// مؤشرات القيم لتحديث الواجهة تلقائياً وبشكل تفاعلي
  final ValueNotifier<List<Results>> enrolledCoursesNotifier = ValueNotifier([]);
  final ValueNotifier<List<Results>> favoriteCoursesNotifier = ValueNotifier([]);
  final ValueNotifier<Map<String, double>> courseProgressNotifier = ValueNotifier({});

  /// خريطة لتتبع أرقام الدروس المكتملة لكل كورس
  final Map<String, Set<int>> _completedLessons = {};

  List<Results> get enrolledCourses => enrolledCoursesNotifier.value;
  List<Results> get favoriteCourses => favoriteCoursesNotifier.value;

  /// تحميل بيانات المستخدم من جداول Supabase عند فتح التطبيق أو تسجيل الدخول
  Future<void> loadUserDataFromSupabase() async {
    try {
      final enrolled = await _dbService.fetchEnrolledCourses();
      if (enrolled.isNotEmpty) {
        enrolledCoursesNotifier.value = enrolled;
      }

      final favorites = await _dbService.fetchFavoriteCourses();
      if (favorites.isNotEmpty) {
        favoriteCoursesNotifier.value = favorites;
      }

      final completed = await _dbService.fetchCompletedLessons();
      if (completed.isNotEmpty) {
        _completedLessons.clear();
        _completedLessons.addAll(completed);
      }
    } catch (e) {
      // التعامل مع الأخطاء بشفافية بدون إيقاف التفاعل
    }
  }

  /// التحقق مما إذا كان الكورس مشتركاً به
  bool isEnrolled(String? courseId) {
    if (courseId == null) return false;
    return enrolledCourses.any((c) => c.id == courseId);
  }

  /// تسجيل الاشتراك في الكورس والمزامنة مع Supabase
  bool enrollCourse(Results course) {
    if (course.id == null) return false;
    if (!isEnrolled(course.id)) {
      final updated = List<Results>.from(enrolledCoursesNotifier.value)..add(course);
      enrolledCoursesNotifier.value = updated;
      
      final updatedProgress = Map<String, double>.from(courseProgressNotifier.value);
      updatedProgress[course.id!] = 0.15;
      courseProgressNotifier.value = updatedProgress;

      // المزامنة مع Supabase في الخلفية
      _dbService.enrollCourse(course);
      return true;
    }
    return false;
  }

  /// التحقق مما إذا كان الكورس مضافاً للمفضلة
  bool isFavorite(String? courseId) {
    if (courseId == null) return false;
    return favoriteCourses.any((c) => c.id == courseId);
  }

  /// تبديل حالة إضافة/إزالة الكورس من المفضلة والمزامنة مع Supabase
  bool toggleFavorite(Results course) {
    if (course.id == null) return false;
    final updated = List<Results>.from(favoriteCoursesNotifier.value);
    final exists = updated.any((c) => c.id == course.id);
    if (exists) {
      updated.removeWhere((c) => c.id == course.id);
    } else {
      updated.add(course);
    }
    favoriteCoursesNotifier.value = updated;

    // المزامنة مع Supabase في الخلفية
    _dbService.toggleFavorite(course);
    return !exists;
  }

  /// جلب نسبة إنجاز الكورس (من 0.0 إلى 1.0)
  double getProgress(String? courseId) {
    if (courseId == null) return 0.0;
    return courseProgressNotifier.value[courseId] ?? 0.0;
  }

  /// التحقق مما إذا كان درس محدد مكتظاً بالنسبة لكورس معين
  bool isLessonCompleted(String courseId, int lessonIndex) {
    return _completedLessons[courseId]?.contains(lessonIndex) ?? false;
  }

  /// تبديل حالة إكمال الدرس وتحديث النسبة والمزامنة مع Supabase
  void toggleLessonCompleted(String courseId, int lessonIndex, int totalLessons) {
    if (!_completedLessons.containsKey(courseId)) {
      _completedLessons[courseId] = {};
    }

    final lessonSet = _completedLessons[courseId]!;
    final bool willBeCompleted = !lessonSet.contains(lessonIndex);

    if (willBeCompleted) {
      lessonSet.add(lessonIndex);
    } else {
      lessonSet.remove(lessonIndex);
    }

    final double progress = totalLessons > 0 ? lessonSet.length / totalLessons : 0.0;
    final updatedProgress = Map<String, double>.from(courseProgressNotifier.value);
    updatedProgress[courseId] = progress;
    courseProgressNotifier.value = updatedProgress;

    // المزامنة مع Supabase في الخلفية
    _dbService.toggleLessonCompleted(courseId, lessonIndex, willBeCompleted);
    _dbService.updateCourseProgress(courseId, progress);
  }

  /// جلب إجمالي عدد الدروس المكتملة لجميع الكورسات
  int get totalCompletedLessons {
    int total = 0;
    for (var set in _completedLessons.values) {
      total += set.length;
    }
    return total;
  }

  /// جلب إجمالي عدد الكورسات المكتملة بنسبة 100%
  int get completedCoursesCount {
    int count = 0;
    for (var course in enrolledCourses) {
      if (course.id != null && getProgress(course.id) >= 0.99) {
        count++;
      }
    }
    return count;
  }

  /// جلب عدد الشهادات المستحقة (شهادة واحدة لكل كورس مكتمل)
  int get earnedCertificatesCount {
    final completed = completedCoursesCount;
    return completed;
  }
}
