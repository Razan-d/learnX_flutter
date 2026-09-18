import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:learnx_flutter/models/coures_model.dart';
import 'package:learnx_flutter/service/course_service.dart';
import 'package:learnx_flutter/presentation/lesson_view_page.dart';

class CourseDetailsPage extends StatefulWidget {
  final Results course;

  const CourseDetailsPage({super.key, required this.course});

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  final CourseService _courseService = CourseService();

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    final isEnrolled = _courseService.isEnrolled(course.id);
    final isFavorite = _courseService.isFavorite(course.id);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "تفاصيل الكورس",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _courseService.toggleFavorite(course);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                      _courseService.isFavorite(course.id)
                          ? "تمت إضافة الكورس للمفضلة"
                          : "تمت إزالة الكورس من المفضلة",
                    ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Image Banner
            if (course.image != null)
              ClipRRect(
                child: Image.network(
                  course.image!,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: double.infinity,
                        height: 220,
                        color: Colors.white,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 220,
                    color: Colors.blue.shade50,
                    child: const Icon(
                      Icons.school,
                      size: 80,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    course.name ?? "عنوان الكورس غير متوفر",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                                height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Partners / Provider
                  if (course.partners != null && course.partners!.isNotEmpty) ...[
                    Row(
                      children: [
                        const Icon(Icons.school_outlined,
                            size: 20, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "المؤسسة: ${course.partners!.join(', ')}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                                                fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                  ],

                  // Badges Row (Rating, Level, Duration)
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      if (course.rating != null)
                        _buildInfoBadge(
                          icon: Icons.star_rounded,
                          color: Colors.amber.shade700,
                          label: "${course.rating} تقييم",
                        ),
                      if (course.difficulty != null)
                        _buildInfoBadge(
                          icon: Icons.signal_cellular_alt,
                          color: Colors.purple,
                          label: course.difficulty!,
                        ),
                      if (course.duration != null)
                        _buildInfoBadge(
                          icon: Icons.access_time_filled,
                          color: Colors.orange,
                          label: course.duration!,
                        ),
                      _buildInfoBadge(
                        icon: course.isFree == true
                            ? Icons.card_giftcard
                            : Icons.workspace_premium,
                        color: course.isFree == true
                            ? Colors.green
                            : Colors.blue,
                        label: course.isFree == true ? "مجاني" : "دورة احترافية",
                      ),
                    ],
                  ),
                  const Divider(height: 32),

                  // Tagline / Overview
                  const Text(
                    "نظرة عامة عن الكورس",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                              ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    course.tagline ??
                        "يقدم هذا المساق تدريباً شاملاً ومفصلاً لتعلم المهارات الأساسية والمتقدمة والتطبيق العملي لتمكينك من دخول سوق العمل.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                                height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Acquired Skills
                  if (course.skills != null && course.skills!.isNotEmpty) ...[
                    const Text(
                      "المهارات التي ستكتسبها:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                                  ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: course.skills!
                          .map(
                            (skill) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.blue.shade100),
                              ),
                              child: Text(
                                skill,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.blue,
                                                        fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Course Curriculum Preview
                  const Text(
                    "منهج الكورس والدروس:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                              ),
                  ),
                  const SizedBox(height: 10),
                  _buildCurriculumTile(
                      1, "المقدمة والأساسيات النظرية", "15 دقيقة"),
                  _buildCurriculumTile(
                      2, "إعداد بيئة العمل والتطبيقات الأولية", "30 دقيقة"),
                  _buildCurriculumTile(
                      3, "المفاهيم المتقدمة والممارسات الفضلى", "45 دقيقة"),
                  _buildCurriculumTile(
                      4, "المشروع التطبيقي النهائى والتقييم", "60 دقيقة"),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isEnrolled ? Colors.green.shade600 : Colors.blue.shade700,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              if (!isEnrolled) {
                _courseService.enrollCourse(course);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "تم الالتحاق بالكورس بنجاح! تم التوجيه للدروس",
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LessonViewPage(course: course),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isEnrolled ? Icons.play_circle_fill : Icons.school_rounded,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  isEnrolled ? "متابعة التعلم والدروس" : "التحاق بهذا الكورس الآن",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBadge({
    required IconData icon,
    required Color color,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.bold,
              ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurriculumTile(int number, String title, String duration) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: Colors.blue.shade100,
            child: Text(
              "$number",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Text(
            duration,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              ),
          ),
        ],
      ),
    );
  }
}
