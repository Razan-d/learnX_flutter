import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:learnx_flutter/models/coures_model.dart';

/// الصفحة الرئيسية لاستكشاف الكورسات والبحث عنها
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // حالة التحميل الحالية للبيانات
  bool isLoading = true;

  // رسالة الخطأ في حال تعثر جلب البيانات من الـ API
  String? errorMessage;

  // قائمة الكورسات المسترجعة من الـ API
  List<Results> courses = [];

  // متحكم نص البحث
  final TextEditingController _searchController = TextEditingController();

  // التصنيف المحدد حالياً من شريط الفلترة
  String _selectedCategory = "Python";

  // قائمة التصنيفات المقترحة للفلترة السريعة
  final List<String> _categories = [
    "Python",
    "Flutter",
    "Web",
    "AI",
    "Data Science",
    "Design",
  ];

  @override
  void initState() {
    super.initState();
    // إدخال النص الافتراضي في مربع البحث وجلب البيانات لأول مرة
    _searchController.text = _selectedCategory;
    getData(_selectedCategory);
  }

  @override
  void dispose() {
    // التخلص من متحكم النص لمنع تسريب الذاكرة
    _searchController.dispose();
    super.dispose();
  }

  /// دالة جلب بيانات الكورسات من RapidAPI باستخدام مكتبة Dio
  Future<void> getData([String? query]) async {
    final searchQuery = query ?? _searchController.text.trim();
    if (searchQuery.isEmpty) return;

    // بدء حالة التحميل وتصفير الأخطاء السابقة
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    // إعداد Dio وتحديد مهلة الاتصال
    final dio = Dio(
      // BaseOptions(
      //   connectTimeout: const Duration(seconds: 10),
      //   receiveTimeout: const Duration(seconds: 10),
      // ),
    );

    try {
      // إرسال طلب GET إلى API كورسيرا على RapidAPI
      // في الموقع كان حاطين post بدل الget لعملية البحث
      final response = await dio.post(
        "https://coursera-course-data-api.p.rapidapi.com/coursera/v1/search",
        queryParameters: {"query": searchQuery},
        options: Options(
          headers: {
            "X-RapidAPI-Key":
                "751d785166msha1f44a67c0c6928p14e109jsn4723cf2da470",
            "X-RapidAPI-Host": "coursera-course-data-api.p.rapidapi.com",
            "Content-Type": "application/json",
          },
        ),
      );

      // التأكد من أن الـ Widget ما زالت موجودة في الشجرة قبل تحديث الواجهة
      if (!mounted) return;

      if (response.statusCode == 200 && response.data != null) {
        // تحويل البيانات المستلمة إلى نموذج CouresModel
        final courseModel = CouresModel.fromJson(response.data);
        setState(() {
          courses = courseModel.data?.results ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "حدث خطأ أثناء جلب البيانات من الخادم";
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage =
            "فشل الاتصال بالشبكة. يرجى التحقق من الاتصال والمحاولة مجدداً.";
        isLoading = false;
      });
    }
  }

  /// عند اختيار تصنيف من أزرار الفلترة السريعة
  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _searchController.text = category;
    });
    getData(category);
  }

  /// عرض نافذة تفاصيل الكورس السفلية عند الضغط على كرت الكورس
  void _showCourseDetails(Results course) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ListView(
          children: [
           Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // مؤشر السحب في أعلى النافذة
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // صورة الكورس الكاملة مع تأثير Shimmer أثناء التحميل
                if (course.image != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      course.image!,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: double.infinity,
                            height: 180,
                            color: Colors.white,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 180,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                // عنوان الكورس مع دعم التجاوز Overflow
                Text(
                  course.name ?? "بدون عنوان",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Almarai-Arabic",
                  ),
                ),
                const SizedBox(height: 8),
                // أسماء الشركاء / الجامعات المقدمة للكورس
                if (course.partners != null && course.partners!.isNotEmpty) ...[
                  Row(
                    children: [
                      const Icon(Icons.school, size: 18, color: Colors.blue),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          course.partners!.join(", "),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            fontFamily: "Almarai-Arabic",
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                // وصف مختصر للكورس مع دعم التجاوز Overflow
                if (course.tagline != null && course.tagline!.isNotEmpty) ...[
                  Text(
                    course.tagline!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontFamily: "Almarai-Arabic",
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                // الشارات والمعلومات التفصيلية (التقييم، المستوى، المدة، مجاني)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (course.rating != null)
                      _buildChip(
                        icon: Icons.star,
                        iconColor: Colors.amber,
                        label: "${course.rating}",
                      ),
                    if (course.difficulty != null)
                      _buildChip(
                        icon: Icons.bar_chart,
                        iconColor: Colors.purple,
                        label: course.difficulty!,
                      ),
                    if (course.duration != null)
                      _buildChip(
                        icon: Icons.access_time,
                        iconColor: Colors.orange,
                        label: course.duration!,
                      ),
                    if (course.isFree == true)
                      _buildChip(
                        icon: Icons.card_giftcard,
                        iconColor: Colors.green,
                        label: "مجاني",
                      ),
                  ],
                ),
                // المهارات المكتسبة من الكورس
                if (course.skills != null && course.skills!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    "المهارات المكتسبة:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Almarai-Arabic",
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: course.skills!
                        .map(
                          (skill) => Chip(
                            label: Text(
                              skill,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: "Almarai-Arabic",
                              ),
                            ),
                            backgroundColor: Colors.blue.shade50,
                            side: BorderSide.none,
                          ),
                        )
                        .toList(),
                  ),
                ],
                const SizedBox(height: 24),
                // زر إغلاق النافذة
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "إغلاق",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Almarai-Arabic",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ],
        );
      },
    );
  }

  /// عنصر شارة صغير يُستخدم لإظهار الأيقونة مع النص
  Widget _buildChip({
    required IconData icon,
    required Color iconColor,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontFamily: "Almarai-Arabic"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      // شريط العنوان الرئيسي
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          "LearnX - استكشف الكورسات",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: "Almarai-Arabic",
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // حاوية البحث وأزرار الفلترة
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              children: [
                // حقل البحث النصي
                TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) => getData(value),
                  style: const TextStyle(fontFamily: "Almarai-Arabic"),
                  decoration: InputDecoration(
                    hintText: "ابحث عن كورس (مثل: Python, Flutter)...",
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontFamily: "Almarai-Arabic",
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.blue),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // شريط أزرار الفلترة حسب التصنيف
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected =
                          _selectedCategory.toLowerCase() == cat.toLowerCase();
                      return ChoiceChip(
                        label: Text(
                          cat,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontFamily: "Almarai-Arabic",
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: Colors.blue.shade700,
                        backgroundColor: Colors.grey[100],
                        onSelected: (selected) {
                          if (selected) {
                            _onCategorySelected(cat);
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // منطقة عرض المحتوى (مؤشر تحميل Shimmer / خطأ / القائمة)
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  /// بناء واجهة المحتوى الرئيسي بناءً على حالة البيانات
  Widget _buildBody() {
    // 1. حالة التحميل
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              "جاري تحميل الدورات...",
              style: TextStyle(
                color: Colors.grey,
                fontFamily: "Almarai-Arabic",
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    // 2. حالة حدوث خطأ
    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 16),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontFamily: "Almarai-Arabic",
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => getData(),
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text(
                  "إعادة المحاولة",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Almarai-Arabic",
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 3. حالة عدم وجود نتائج
    if (courses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              "لم يتم العثور على دورات لهذا البحث",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: "Almarai-Arabic",
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => _onCategorySelected("Python"),
              child: const Text(
                "عرض دورات Python",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  fontFamily: "Almarai-Arabic",
                ),
              ),
            ),
          ],
        ),
      );
    }

    // 4. عرض قائمة الكورسات مع خاصية السحب للتحديث
    return RefreshIndicator(
      onRefresh: () => getData(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return _buildCourseCard(course);
        },
      ),
    );
  }

  /// بناء كرت الكورس المفرد في القائمة
  Widget _buildCourseCard(Results course) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showCourseDetails(course),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صورة الكورس المصغرة مع تأكير Shimmer أثناء التحميل
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: course.image != null && course.image!.isNotEmpty
                    ? Image.network(
                        course.image!,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 90,
                              height: 90,
                              color: Colors.white,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 90,
                          height: 90,
                          color: Colors.blue.shade50,
                          child: const Icon(
                            Icons.school,
                            size: 40,
                            color: Colors.blue,
                          ),
                        ),
                      )
                    : Container(
                        width: 90,
                        height: 90,
                        color: Colors.blue.shade50,
                        child: const Icon(
                          Icons.school,
                          size: 40,
                          color: Colors.blue,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              // معلومات الكورس (العنوان، الشريك، التقييم، الصعوبة)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.name ?? "بدون عنوان",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Almarai-Arabic",
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (course.partners != null && course.partners!.isNotEmpty)
                      Text(
                        course.partners!.join(", "),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontFamily: "Almarai-Arabic",
                        ),
                      ),
                    const SizedBox(height: 8),
                    // شارات التقييم والصعوبة والمجانية
                    Row(
                      children: [
                        if (course.rating != null) ...[
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 2),
                          Text(
                            "${course.rating}",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Almarai-Arabic",
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        if (course.difficulty != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              course.difficulty!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.blue.shade800,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Almarai-Arabic",
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                        if (course.isFree == true)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "مجاني",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.green.shade800,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Almarai-Arabic",
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
