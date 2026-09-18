import 'package:flutter/material.dart';
import 'package:learnx_flutter/models/coures_model.dart';
import 'package:learnx_flutter/service/course_service.dart';

class LessonViewPage extends StatefulWidget {
  final Results course;

  const LessonViewPage({super.key, required this.course});

  @override
  State<LessonViewPage> createState() => _LessonViewPageState();
}

class _LessonViewPageState extends State<LessonViewPage>
    with SingleTickerProviderStateMixin {
  final CourseService _courseService = CourseService();
  late TabController _tabController;

  int activeLessonIndex = 0;

  final List<Map<String, String>> lessons = [
    {
      "title": "1. المقدمة والتعريف بالمساق والأهداف التعليمية",
      "duration": "10:30 دقيقة",
      "summary": "تتناول هذه الجلسة فكرة المساق وأهم المهارات التي سنتعلمها وكيفية تحقيق الاستفادة القصوى.",
    },
    {
      "title": "2. تهيئة بيئة التطوير والأدوات الأساسية",
      "duration": "18:45 دقيقة",
      "summary": "شرح خطوة بخطوة لتثبيت الحزم البرمجية، إعداد محرر الأكواد، وإنشاء أول برنامج تجريبي.",
    },
    {
      "title": "3. البنية الرئيسية والمفاهيم الجوهرية للمادة",
      "duration": "25:12 دقيقة",
      "summary": "التعمق في البنى التحليلية والوظائف الرئيسية مع أمثلة وتطبيقات تفاعلية.",
    },
    {
      "title": "4. التطبيق العملي وحل التمارين التقنية",
      "duration": "30:00 دقيقة",
      "summary": "تمرين تطبيقي مكثف يجمع المهارات السابقة في مشروع متكامل قابل للتنفيذ.",
    },
    {
      "title": "5. الاختبار النهائي وملخص الانتهاء من الكورس",
      "duration": "15:20 دقيقة",
      "summary": "مراجعة شاملة، نصائح للمقابلات والوظائف، وكيفية إدراج الدورة في سيرتك الذاتية.",
    },
  ];

  final TextEditingController _noteController = TextEditingController();
  final List<String> userNotes = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courseId = widget.course.id ?? "default_course";
    final double progressPercent = _courseService.getProgress(courseId);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.course.name ?? "غرفة التعلم والدروس",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Simulated Video Player Container
          Container(
            width: double.infinity,
            height: 210,
            color: Colors.black,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (widget.course.image != null)
                  Opacity(
                    opacity: 0.4,
                    child: Image.network(
                      widget.course.image!,
                      width: double.infinity,
                      height: 210,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox(),
                    ),
                  ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue.shade600.withOpacity(0.9),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        size: 42,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        lessons[activeLessonIndex]["title"]!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                                      ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 8,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lessons[activeLessonIndex]["duration"]!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                                      ),
                      ),
                      const Icon(
                        Icons.fullscreen_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Course Overall Progress Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "نسبة إنجازالدورة:",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                                  ),
                    ),
                    Text(
                      "${(progressPercent * 100).toInt()}%",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                                  ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progressPercent,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progressPercent == 1.0 ? Colors.green : Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tab Bar (Lessons Playlist vs Student Notes)
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.blue.shade700,
              unselectedLabelColor: Colors.grey.shade600,
              indicatorColor: Colors.blue.shade700,
              labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              tabs: const [
                Tab(text: "قائمة الدروس"),
                Tab(text: "ملاحظاتي والشرح"),
              ],
            ),
          ),

          // Tab View Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Lessons Playlist Tab
                ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: lessons.length,
                  itemBuilder: (context, index) {
                    final isSelected = activeLessonIndex == index;
                    final isCompleted =
                        _courseService.isLessonCompleted(courseId, index);

                    return Card(
                      elevation: isSelected ? 2 : 0.5,
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected
                              ? Colors.blue.shade400
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 16,
                          backgroundColor: isCompleted
                              ? Colors.green.shade100
                              : (isSelected ? Colors.blue.shade100 : Colors.grey.shade200),
                          child: Icon(
                            isCompleted ? Icons.check : (isSelected ? Icons.play_arrow : Icons.lock_outline),
                            size: 18,
                            color: isCompleted
                                ? Colors.green
                                : (isSelected ? Colors.blue : Colors.grey),
                          ),
                        ),
                        title: Text(
                          lessons[index]["title"]!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? Colors.blue.shade900 : Colors.black87,
                                          ),
                        ),
                        subtitle: Text(
                          lessons[index]["duration"]!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                                          ),
                        ),
                        trailing: Checkbox(
                          value: isCompleted,
                          activeColor: Colors.green,
                          onChanged: (val) {
                            setState(() {
                              _courseService.toggleLessonCompleted(
                                  courseId, index, lessons.length);
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            activeLessonIndex = index;
                          });
                        },
                      ),
                    );
                  },
                ),

                // Student Notes Tab
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _noteController,
                              decoration: InputDecoration(
                                hintText: "اكتب ملاحظة أو استفسار على هذا الدرس...",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.send, color: Colors.white),
                            onPressed: () {
                              if (_noteController.text.trim().isNotEmpty) {
                                setState(() {
                                  userNotes.add(_noteController.text.trim());
                                  _noteController.clear();
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: userNotes.isEmpty
                            ? Center(
                                child: Text(
                                  "لا توجد ملاحظات مكتوبة بعد.\nأضف ملاحظاتك أثناء مشاهدة الدرس!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                                          ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: userNotes.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListTile(
                                      leading: const Icon(Icons.note_alt,
                                          color: Colors.blue),
                                      title: Text(
                                        userNotes[index],
                                        style: const TextStyle(
                                                                        fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
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
