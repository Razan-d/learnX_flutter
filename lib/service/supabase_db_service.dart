import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:learnx_flutter/models/coures_model.dart';

/// خدمة التعامل الموحدة مع قاعدة بيانات Supabase
/// تتولى جميع عمليات (إضافة، تعديل، حذف، جلب) للجداول: profiles, courses, enrollments, favorites, lesson_progress.
class SupabaseDbService {

  final SupabaseClient _supabase = Supabase.instance.client;

  /// معرف المستخدم الحالي المسجل
  String? get currentUserId => _supabase.auth.currentUser?.id;

  // ========================================================
  // 1. جدول الدورات (COURSES TABLE)
  // ========================================================

  /// حفظ أو تحديث بيانات دورة في جدول `courses` في Supabase
  Future<void> saveCourse(Results course) async {
    if (course.id == null) return;
    try {
      await _supabase.from('courses').upsert({
        'id': course.id,
        'name': course.name,
        'url': course.url,
        'slug': course.slug,
        'type': course.type,
        'difficulty': course.difficulty,
        'duration': course.duration,
        'rating': course.rating,
        'review_count': course.reviewCount,
        'partners': course.partners,
        'skills': course.skills,
        'is_free': course.isFree,
        'is_coursera_plus': course.isCourseraPlus,
        'image': course.image,
        'tagline': course.tagline,
      });
    } catch (e) {
      // التعامل مع الأخطاء بدون تعطيل التطبيق أثناء عدم الاتصال
    }
  }

  /// جلب قائمة جميع الدورات المخزنة من Supabase
  Future<List<Results>> fetchCourses() async {
    try {
      final response = await _supabase.from('courses').select();
      return (response as List).map((json) => Results.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // ========================================================
  // 2. جدول الاشتراكات والتقدم (ENROLLMENTS TABLE & PROGRESS)
  // ========================================================

  /// جلب الدورات التي اشترك فيها المستخدم الحالي من Supabase
  Future<List<Results>> fetchEnrolledCourses() async {
    final userId = currentUserId;
    if (userId == null) return [];
    try {
      final response = await _supabase
          .from('enrollments')
          .select('courses (*)')
          .eq('user_id', userId);

      final List<Results> list = [];
      for (var item in response) {
        if (item['courses'] != null) {
          list.add(Results.fromJson(item['courses']));
        }
      }
      return list;
    } catch (e) {
      return [];
    }
  }

  /// تسجيل اشتراك المستخدم في دورة معينة في Supabase
  Future<bool> enrollCourse(Results course) async {
    final userId = currentUserId;
    if (userId == null || course.id == null) return false;
    try {
      await saveCourse(course);

      await _supabase.from('enrollments').upsert({
        'user_id': userId,
        'course_id': course.id,
        'progress': 0.15,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  /// تحديث نسبة إنجاز الدورة للمستخدم في Supabase
  Future<void> updateCourseProgress(String courseId, double progress) async {
    final userId = currentUserId;
    if (userId == null) return;
    try {
      await _supabase
          .from('enrollments')
          .update({'progress': progress})
          .eq('user_id', userId)
          .eq('course_id', courseId);
    } catch (e) {
      // معالجة الخطأ بشفافية
    }
  }

  // ========================================================
  // 3. جدول المفضلة (FAVORITES TABLE)
  // ========================================================

  /// جلب قائمة الدورات المفضلة للمستخدم الحالي من Supabase
  Future<List<Results>> fetchFavoriteCourses() async {
    final userId = currentUserId;
    if (userId == null) return [];
    try {
      final response = await _supabase
          .from('favorites')
          .select('courses (*)')
          .eq('user_id', userId);

      final List<Results> list = [];
      for (var item in response) {
        if (item['courses'] != null) {
          list.add(Results.fromJson(item['courses']));
        }
      }
      return list;
    } catch (e) {
      return [];
    }
  }

  /// تبديل حالة إضافة/إزالة الدورة من المفضلة في Supabase
  Future<bool> toggleFavorite(Results course) async {
    final userId = currentUserId;
    if (userId == null || course.id == null) return false;
    try {
      await saveCourse(course);

      final existing = await _supabase
          .from('favorites')
          .select()
          .eq('user_id', userId)
          .eq('course_id', course.id!)
          .maybeSingle();

      if (existing != null) {
        await _supabase
            .from('favorites')
            .delete()
            .eq('user_id', userId)
            .eq('course_id', course.id!);
        return false;
      } else {
        await _supabase.from('favorites').insert({
          'user_id': userId,
          'course_id': course.id,
        });
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  // ========================================================
  // 4. جدول تقدم الدروس المكتملة (LESSON PROGRESS TABLE)
  // ========================================================

  /// تحديد الدرس كمكتمل أو غير مكتمل في جدول `lesson_progress`
  Future<void> toggleLessonCompleted(String courseId, int lessonIndex, bool isCompleted) async {
    final userId = currentUserId;
    if (userId == null) return;
    try {
      if (isCompleted) {
        await _supabase.from('lesson_progress').upsert({
          'user_id': userId,
          'course_id': courseId,
          'lesson_index': lessonIndex,
          'is_completed': true,
        });
      } else {
        await _supabase
            .from('lesson_progress')
            .delete()
            .eq('user_id', userId)
            .eq('course_id', courseId)
            .eq('lesson_index', lessonIndex);
      }
    } catch (e) {
      // معالجة الخطأ بشفافية
    }
  }

  /// جلب خريطة جميع أرقام الدروس المكتملة لكل كورس للمستخدم الحالي
  Future<Map<String, Set<int>>> fetchCompletedLessons() async {
    final userId = currentUserId;
    if (userId == null) return {};
    try {
      final response = await _supabase
          .from('lesson_progress')
          .select('course_id, lesson_index')
          .eq('user_id', userId);

      final Map<String, Set<int>> result = {};
      for (var item in response) {
        final String cId = item['course_id'];
        final int lIndex = (item['lesson_index'] as num).toInt();
        if (!result.containsKey(cId)) {
          result[cId] = {};
        }
        result[cId]!.add(lIndex);
      }
      return result;
    } catch (e) {
      return {};
    }
  }
}
