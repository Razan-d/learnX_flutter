import 'package:flutter/material.dart';
import 'package:learnx_flutter/models/coures_model.dart';
import 'package:learnx_flutter/service/course_service.dart';
import 'package:learnx_flutter/presentation/course_details_page.dart';

class FavoritesPage extends StatelessWidget {
  final VoidCallback? onExploreTap;

  const FavoritesPage({super.key, this.onExploreTap});

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
          "المفضلة",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<List<Results>>(
        valueListenable: courseService.favoriteCoursesNotifier,
        builder: (context, favoritesList, _) {
          if (favoritesList.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite_border_rounded,
                        size: 70,
                        color: Colors.red.shade400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "قائمة المفضلة فارغة",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                                  ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "احفظ الدورات المفضلة لديك بالضغط على أيقونة القلب في تفاصيل أي دورة لتصل إليها لاحقاً بسرعة!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                                  ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: onExploreTap,
                      icon: const Icon(Icons.explore, color: Colors.white),
                      label: const Text(
                        "استكشف الدورات الآن",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                                      ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favoritesList.length,
            itemBuilder: (context, index) {
              final course = favoritesList[index];

              return Card(
                elevation: 0.5,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: course.image != null
                        ? Image.network(
                            course.image!,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 70,
                              height: 70,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.school, color: Colors.blue),
                            ),
                          )
                        : Container(
                            width: 70,
                            height: 70,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.school, color: Colors.blue),
                          ),
                  ),
                  title: Text(
                    course.name ?? "بدون عنوان",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                              ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      children: [
                        if (course.rating != null) ...[
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            "${course.rating}",
                            style: const TextStyle(
                              fontSize: 12,
                                              ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        if (course.difficulty != null)
                          Text(
                            course.difficulty!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                                              ),
                          ),
                      ],
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () {
                      courseService.toggleFavorite(course);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseDetailsPage(course: course),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
