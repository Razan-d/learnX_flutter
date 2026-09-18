import 'package:flutter/material.dart';
import 'package:learnx_flutter/models/coures_model.dart';
import 'package:learnx_flutter/service/course_service.dart';
import 'package:learnx_flutter/presentation/lesson_view_page.dart';

/// شاشة دوراتي المشترك بها مع الفلترة حسب الحالة (الكل، مكتمل، غير مكتمل)
class MyCoursesPage extends StatefulWidget {
  final VoidCallback? onExploreTap;

  const MyCoursesPage({super.key, this.onExploreTap});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  // المؤشر المحدد للفلترة: 0 = اشتراكات الدورات (الكل)، 1 = مكتمل، 2 = غير مكتمل
  int _selectedFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    final courseService = CourseService();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        title: const Text(
          "دوراتي المشترك بها",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<List<Results>>(
        valueListenable: courseService.enrolledCoursesNotifier,
        builder: (context, enrolledList, _) {
          return ValueListenableBuilder<Map<String, double>>(
            valueListenable: courseService.courseProgressNotifier,
            builder: (context, progressMap, _) {
              if (enrolledList.isEmpty) {
                return _buildEmptyState(
                  title: "لم تشترك في أي دورة حتى الآن",
                  subtitle:
                      "تصفح مئات الدورات المتاحة في مختلف المجالات وانضم اليوم لبدء رحلة التعلم!",
                  showExploreButton: true,
                );
              }

              // تصفية الدورات المكتملة وغير المكتملة
              final completedCourses = enrolledList
                  .where((c) => courseService.getProgress(c.id) >= 0.99)
                  .toList();
              final inProgressCourses = enrolledList
                  .where((c) => courseService.getProgress(c.id) < 0.99)
                  .toList();

              // القائمة المعروضة بناءً على الفلتر المحدد
              List<Results> filteredList;
              if (_selectedFilterIndex == 1) {
                filteredList = completedCourses;
              } else if (_selectedFilterIndex == 2) {
                filteredList = inProgressCourses;
              } else {
                filteredList = enrolledList;
              }

              return Column(
                children: [
                  // شريط خيارات الفلترة الأنيقة مع الأعداد
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        _buildFilterChip(
                          index: 0,
                          label: "اشتراكات الدورات",
                          count: enrolledList.length,
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          index: 1,
                          label: "مكتمل",
                          count: completedCourses.length,
                          color: Colors.green.shade700,
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          index: 2,
                          label: "غير مكتمل",
                          count: inProgressCourses.length,
                          color: Colors.orange.shade800,
                        ),
                      ],
                    ),
                  ),

                  // قائمة الكورسات أو رسالة القائمة الفارغة
                  Expanded(
                    child: filteredList.isEmpty
                        ? _buildEmptyState(
                            title: _selectedFilterIndex == 1
                                ? "لا توجد دورات مكتملة حتى الآن"
                                : "لا توجد دورات غير مكتملة",
                            subtitle: _selectedFilterIndex == 1
                                ? "واصل المشاهدة والتعلم لإتمام دوراتك وحصولك على الشهادات المستحقة!"
                                : "تهانينا! لقد أكملت جميع الدورات المشترك بها بنجاح 🎉",
                            showExploreButton: false,
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final course = filteredList[index];
                              final double progress =
                                  courseService.getProgress(course.id);
                              final int percent = (progress * 100).toInt();
                              return _buildCourseCard(
                                  course, progress, percent);
                            },
                          ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  /// بناء زر الفلترة التفاعلي مع العداد
  Widget _buildFilterChip({
    required int index,
    required String label,
    required int count,
    Color? color,
  }) {
    final bool isSelected = _selectedFilterIndex == index;
    final activeColor = color ?? Colors.blue.shade700;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilterIndex = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? activeColor : Colors.grey.shade300,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.white : Colors.black87,
                      ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.25)
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "$count",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black87,
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// بناء واجهة الشاشة الفارغة عند عدم وجود كورسات
  Widget _buildEmptyState({
    required String title,
    required String subtitle,
    required bool showExploreButton,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.menu_book_rounded,
                size: 60,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                  ),
            ),
            if (showExploreButton) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: widget.onExploreTap,
                icon: const Icon(Icons.search, color: Colors.white),
                label: const Text(
                  "استكشف الدورات المتاحة",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                          ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// بناء كرت الكورس مع شريط التقدم وزر المتابعة
  Widget _buildCourseCard(Results course, double progress, int percent) {
    final bool isCompleted = percent >= 99;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: course.image != null
                    ? Image.network(
                        course.image!,
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 140,
                          color: Colors.blue.shade50,
                          child: const Icon(Icons.school,
                              size: 50, color: Colors.blue),
                        ),
                      )
                    : Container(
                        height: 140,
                        color: Colors.blue.shade50,
                        child: const Icon(Icons.school,
                            size: 50, color: Colors.blue),
                      ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.green : Colors.blue.shade800,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isCompleted ? "مكتمل 100%" : "مُنجَز $percent%",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                              ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.name ?? "عنوان غير متوفر",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                          ),
                ),
                const SizedBox(height: 8),

                // Progress Indicator Bar
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isCompleted ? Colors.green : Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "$percent%",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                                  ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Continue / Review Action Button
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isCompleted ? Colors.green.shade700 : Colors.blue.shade700,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LessonViewPage(course: course),
                        ),
                      );
                    },
                    icon: Icon(
                      isCompleted ? Icons.check_circle : Icons.play_circle_fill,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: Text(
                      isCompleted ? "مراجعة الدروس" : "متابعة الدروس الآن",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                                  ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
