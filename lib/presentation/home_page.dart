import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shimmer/shimmer.dart';
import 'package:learnx_flutter/models/coures_model.dart';
import 'package:learnx_flutter/presentation/course_details_page.dart';
import 'package:learnx_flutter/service/auth.dart';

/// الصفحة الرئيسية لاستكشاف الكورسات والإعلانات والبحث
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthServices _authServices = AuthServices();

  // حالة التحميل الحالية للبيانات
  bool isLoading = true;

  // رسالة الخطأ في حال تعثر جلب البيانات من الـ API
  String? errorMessage;

  // قائمة الكورسات المسترجعة من الـ API
  List<Results> courses = [];

  // متحكم نص البحث
  final TextEditingController _searchController = TextEditingController();

  // التصنيف المحدد حالياً (يكون null عند فتح التطبيق لأول مرة)
  String? _selectedCategory;

  // قائمة التصنيفات المقترحة للفلترة السريعة
  final List<String> _categories = [
    "Python",
    "Flutter",
    "Web",
    "AI",
    "Data Science",
    "Design",
  ];

  // متحكم ومؤشر صور الإعلانات (Banner Carousel)
  final PageController _bannerPageController = PageController();
  int _currentBannerIndex = 0;
  Timer? _bannerTimer;

  // قائمة الإعلانات العروض الترويجية
  final List<Map<String, dynamic>> _banners = [
    {
      "title": "خصم 50% على مسارات البرمجة 🔥",
      "subtitle": "تعلم Python و Flutter وانضم لسوق العمل اليوم",
      "badge": "عرض محدود",
      "gradient": [const Color(0xFF1E3C72), const Color(0xFF2A5298)],
      "icon": Icons.code_rounded,
    },
    {
      "title": "احترف الذكاء الاصطناعي 🤖",
      "subtitle": "مسارات متكاملة في تعلم الآلة وتحليل البيانات",
      "badge": "جديد ومميز",
      "gradient": [const Color(0xFF0D9488), const Color(0xFF134E4A)],
      "icon": Icons.psychology_rounded,
    },
    {
      "title": " تصميم واجهات المستخدم 🎨",
      "subtitle": "تعلم UI/UX من البداية حتى الاحتراف",
      "badge": "الأكثر طلباً",
      "gradient": [const Color(0xFF6366F1), const Color(0xFF4338CA)],
      "icon": Icons.palette_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    // جلب البيانات الأولية بدون تحديد تصنيف افتراضي
    getData("programming");

    // تشغيل التبديل التلقائي لصور الإعلانات كل 4 ثوانٍ
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_bannerPageController.hasClients && !isSearching) {
        int nextPage = (_currentBannerIndex + 1) % _banners.length;
        _bannerPageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerPageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  /// تحقق مما إذا كان المستخدم يجري عملية بحث
  bool get isSearching => _searchController.text.trim().isNotEmpty;

  /// دالة جلب بيانات الكورسات من RapidAPI باستخدام Dio
  Future<void> getData([String? query]) async {
    final searchQuery = query ?? _searchController.text.trim();
    final term = searchQuery.isEmpty ? "programming" : searchQuery;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final dio = Dio();

    try {
      final response = await dio.post(
        "https://coursera-course-data-api.p.rapidapi.com/coursera/v1/search",
        queryParameters: {"query": term},
        options: Options(
          headers: {
            "X-RapidAPI-Key": dotenv.env['RAPIDAPI_KEY'] ?? "",
            "X-RapidAPI-Host":
                dotenv.env['RAPIDAPI_HOST'] ?? "coursera-course-data-api.p.rapidapi.com",
            "Content-Type": "application/json",
          },
        ),
      );

      if (!mounted) return;

      if (response.statusCode == 200 && response.data != null) {
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
      if (_selectedCategory == category) {
        // إلغاء تحديد التصنيف إذا تم الضغط عليه مجدداً
        _selectedCategory = null;
        _searchController.clear();
        getData("programming");
      } else {
        _selectedCategory = category;
        _searchController.text = category;
        getData(category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String userName = _authServices.userFullName;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => getData(_selectedCategory),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -------------------------------------------------------------
                // 1. ترويسة الصفحة مع الترحب وحقل البحث
                // -------------------------------------------------------------
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Greeting Row
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.blue.shade100,
                            child: Text(
                              userName.isNotEmpty
                                  ? userName[0].toUpperCase()
                                  : "U",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "مرحباً، $userName",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "ماذا تحب أن تتعلم اليوم؟",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Search Text Field
                      TextField(
                        controller: _searchController,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) => getData(value),
                        onChanged: (val) {
                          setState(() {});
                        },
                        style: const TextStyle(),
                        decoration: InputDecoration(
                          hintText: "ابحث عن دورة (مثل: Python, Flutter)...",
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                          ),
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.blue),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: Colors.grey),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _selectedCategory = null;
                                    });
                                    getData("programming");
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

                      // Category Chips (تظهر دائماً للتصفح)
                      SizedBox(
                        height: 38,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _categories.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final cat = _categories[index];
                            final isSelected = _selectedCategory != null &&
                                _selectedCategory!.toLowerCase() ==
                                    cat.toLowerCase();
                            return ChoiceChip(
                              label: Text(
                                cat,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  ),
                              ),
                              selected: isSelected,
                              selectedColor: Colors.blue.shade700,
                              backgroundColor: Colors.grey[100],
                              onSelected: (_) => _onCategorySelected(cat),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // -------------------------------------------------------------
                // 2. صور الإعلانات (Banners Slider) - تظهر فقط عندما لا يبحث المستخدم
                // -------------------------------------------------------------
                if (!isSearching) ...[
                  const SizedBox(height: 16),
                  _buildBannersSlider(),
                  const SizedBox(height: 20),
                ],

                // -------------------------------------------------------------
                // 3. القائمة الرئيسية للكورسات / نتائج البحث
                // -------------------------------------------------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isSearching
                            ? "نتائج البحث 🔍"
                            : (_selectedCategory != null
                                ? "قسم $_selectedCategory 📚"
                                : "جميع الدورات المتاحة "),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                                ),
                      ),
                      if (courses.isNotEmpty)
                        Text(
                          "${courses.length} دورة",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Courses Body Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildBody(),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// بناء قسم صور الإعلانات الترويجية (Banners Slider)
  Widget _buildBannersSlider() {
    return Column(
      children: [
        SizedBox(
          height: 145,
          child: PageView.builder(
            controller: _bannerPageController,
            itemCount: _banners.length,
            onPageChanged: (index) {
              setState(() {
                _currentBannerIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: banner["gradient"] as List<Color>,
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (banner["gradient"] as List<Color>)[0]
                          .withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              banner["badge"]!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            banner["title"]!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            banner["subtitle"]!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      banner["icon"] as IconData,
                      size: 60,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        // Indicators Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentBannerIndex == index ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _currentBannerIndex == index
                    ? Colors.blue.shade700
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// بناء واجهة المحتوى القائمة الرئيسية الكورسات
  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                "جاري تحميل الدورات ...",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 54,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 12),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => getData(_selectedCategory),
                icon: const Icon(Icons.refresh, color: Colors.white, size: 18),
                label: const Text(
                  "إعادة المحاولة",
                  style: TextStyle(
                    color: Colors.white,
                      fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (courses.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off, size: 54, color: Colors.grey),
              const SizedBox(height: 12),
              const Text(
                "لم يتم العثور على دورات لهذا البحث",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  _searchController.clear();
                  _onCategorySelected("Python");
                },
                child: const Text(
                  "عرض دورات Python",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue,
                    ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return _buildCourseCard(course);
      },
    );
  }

  /// بناء كرت الكورس المفرد
  Widget _buildCourseCard(Results course) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailsPage(course: course),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.name ?? "بدون عنوان",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
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
                          fontSize: 12,
                          color: Colors.grey[600],
                                ),
                      ),
                    const SizedBox(height: 8),
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
                              ),
                          ),
                          const SizedBox(width: 10),
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
