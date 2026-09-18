import 'package:flutter/material.dart';
import 'package:learnx_flutter/service/auth.dart';
import 'package:learnx_flutter/service/course_service.dart';
import 'package:learnx_flutter/presentation/edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthServices _authServices = AuthServices();
  final CourseService _courseService = CourseService();

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    await _courseService.loadUserDataFromSupabase();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final String name = _authServices.userFullName;
    final String email = _authServices.userEmail;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        title: const Text(
          "الملف الشخصي ",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Profile Card Header
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : "U",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Statistics Grid (Auto-Updates reactively across all tabs)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    _courseService.enrolledCoursesNotifier,
                    _courseService.courseProgressNotifier,
                  ]),
                  builder: (context, _) {
                    final int enrolledCount = _courseService.enrolledCourses.length;
                    final int completedCourses = _courseService.completedCoursesCount;
                    final int earnedCertificates = _courseService.earnedCertificatesCount;

                    return Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.menu_book_rounded,
                            iconColor: Colors.blue,
                            value: "$enrolledCount",
                            label: "الدورات المشترك فيها",
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.check_circle_outline,
                            iconColor: Colors.green,
                            value: "$completedCourses",
                            label: "الدورات المكتملة",
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.workspace_premium,
                            iconColor: Colors.orange,
                            value: "$earnedCertificates",
                            label: "الشهادات المستحقة",
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

            // Settings & Actions Menu
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildMenuTile(
                    icon: Icons.person_outline,
                    title: "تعديل الملف الشخصي",
                    subtitle: "تحديث الاسم والبريد الإلكتروني",
                    onTap: _navigateToEditProfile,
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildMenuTile(
                    icon: Icons.settings_outlined,
                    title: "الإعدادات",
                    subtitle: "إعدادات الحساب",
                    onTap: () {},
                  ),
                  // const Divider(height: 1, indent: 56),
                  // _buildMenuTile(
                  //   icon: Icons.security_rounded,
                  //   title: "الأمان والخصوصية",
                  //   subtitle: "تغيير كلمة المرور والبيانات",
                  //   onTap: _navigateToEditProfile,
                  // ),
                  // const Divider(height: 1, indent: 56),
                  // _buildMenuTile(
                  //   icon: Icons.help_outline_rounded,
                  //   title: "المساعدة والدعم الفني",
                  //   subtitle: "الأسئلة الشائعة وتواصل معنا",
                  //   onTap: () {},
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Sign Out Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _confirmSignOut(context),
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text(
                    "تسجيل الخروج من الحساب",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                              ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              ),
          ),
        ],
      ),
    );
  }

  void _navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditProfilePage(),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade700),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: onTap,
    );
  }

  void _confirmSignOut(BuildContext context) {
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                "تسجيل الخروج",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: isLoading
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: Colors.red),
                          SizedBox(height: 16),
                          Text(
                            "جاري تسجيل الخروج...",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    )
                  : const Text(
                      "هل أنت تأكد من رغبتك في تسجيل الخروج من التطبيق؟",
                    ),
              actions: isLoading
                  ? []
                  : [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text("إلغاء"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () async {
                          setDialogState(() {
                            isLoading = true;
                          });
                          await _authServices.signOut();
                          if (mounted) {
                            Navigator.pop(dialogContext);
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              "SignIn",
                              (route) => false,
                            );
                          }
                        },
                        child: const Text(
                          "تأكيد الخروج",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
            );
          },
        );
      },
    );
  }
}
