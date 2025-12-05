import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DashboardScreen extends StatefulWidget {
  final String username;

  const DashboardScreen({super.key, required this.username});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar gradient sesuai materi Scaffold
            _DashboardAppBar(
              title: _currentIndex == 0
                  ? "Dashboard"
                  : _currentIndex == 1
                      ? "Attendance"
                      : _currentIndex == 2
                          ? "Progress"
                          : "Course",
              showBack: _currentIndex != 0,
              onBack: () => setState(() => _currentIndex = 0),
            ),

            // BODY dengan fade animation
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildTab(_currentIndex, isMobile),
              ),
            ),
          ],
        ),
      ),

      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF1A237E),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fact_check_outlined),
            label: "Attendance",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart_outlined),
            label: "Progress",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: "Course",
          ),
        ],
      ),
    );
  }

  Widget _buildTab(int index, bool isMobile) {
    switch (index) {
      case 0:
        return HomeTab(
          key: const ValueKey(0),
          username: widget.username,
          onOpenScan: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ScanAttendancePage(),
              ),
            );
          },
          onOpenAttendance: () => setState(() => _currentIndex = 1),
          onOpenProgress: () => setState(() => _currentIndex = 2),
          onOpenCourse: () => setState(() => _currentIndex = 3),
          onOpenNotification: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const NotificationPage(),
              ),
            );
          },
          onOpenProfile: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfilePage(username: widget.username),
              ),
            );
          },
        );
      case 1:
        return const AttendanceTab(key: ValueKey(1));
      case 2:
        return const ProgressTab(key: ValueKey(2));
      case 3:
      default:
        return const CourseTab(key: ValueKey(3));
    }
  }
}

/// ---------------------------------------------------------------------------
///  APPBAR DASHBOARD (GRADIENT)
/// ---------------------------------------------------------------------------

class _DashboardAppBar extends StatelessWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBack;

  const _DashboardAppBar({
    required this.title,
    this.showBack = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A237E), Color(0xFF3F51B5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          if (showBack)
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              // 🔥 FIX UTAMA DI SINI:
              onPressed: onBack ?? () => Navigator.pop(context),
            )
          else
            const SizedBox(width: 16),

          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
///  HOME TAB
/// ---------------------------------------------------------------------------

class HomeTab extends StatelessWidget {
  final String username;
  final VoidCallback onOpenScan;
  final VoidCallback onOpenAttendance;
  final VoidCallback onOpenProgress;
  final VoidCallback onOpenCourse;
  final VoidCallback onOpenNotification;
  final VoidCallback onOpenProfile;

  const HomeTab({
    super.key,
    required this.username,
    required this.onOpenScan,
    required this.onOpenAttendance,
    required this.onOpenProgress,
    required this.onOpenCourse,
    required this.onOpenNotification,
    required this.onOpenProfile,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // TOP GRADIENT CARD: PROFILE + ICONS
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A237E), Color(0xFF3F51B5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: isMobile ? 26 : 32,
                  backgroundImage:
                      const AssetImage('assets/images/circle2.png'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Good Morning, ${_capitalize(username)}!",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Undergraduate • Informatics Engineering",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_none,
                      color: Colors.white),
                  onPressed: onOpenNotification,
                ),
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: onOpenProfile,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // TODAY'S CLASSES CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Today's Classes",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: onOpenCourse,
                      child: const Text(
                        "See All..",
                        style: TextStyle(
                          color: Color(0xFF1A237E),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  "Mobile Platform (A)",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Text("14:00 - 16:30"),
                const Text("Offline - Building Lab"),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: onOpenAttendance,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    "View Details",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ATTENDANCE / EVENT CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF3F51B5),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Attendance / Event",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Midterm Exam Starts Next Week!\nCheck the schedule and prepare your materials!",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // SEARCH BAR
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.search),
                hintText: "Search course, lecturer, or material...",
              ),
            ),
          ),

          const SizedBox(height: 20),

          // QUICK MENU GRID
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              _QuickMenuCard(
                icon: Icons.qr_code_2,
                label: "Scan QR",
                onTap: onOpenScan,
              ),
              _QuickMenuCard(
                icon: Icons.fact_check_outlined,
                label: "Attendance",
                onTap: onOpenAttendance,
              ),
              _QuickMenuCard(
                icon: Icons.show_chart_outlined,
                label: "Progress",
                onTap: onOpenProgress,
              ),
              _QuickMenuCard(
                icon: Icons.menu_book_outlined,
                label: "Course",
                onTap: onOpenCourse,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }
}

class _QuickMenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickMenuCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: SizedBox(
          width: 140,
          height: 110,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: const Color(0xFF1A237E)),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A237E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
///  SCAN ATTENDANCE PAGE (UI STATIS + EASYLOADING POPUP)
/// ---------------------------------------------------------------------------

class ScanAttendancePage extends StatelessWidget {
  const ScanAttendancePage({super.key});

  void _showRecorded() {
    EasyLoading.showSuccess(
      "Attendance has been recorded!",
      duration: const Duration(seconds: 0),
      dismissOnTap: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const _DashboardAppBar(
              title: "Scan Attendance",
              showBack: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    // BUTTON SCAN
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _showRecorded,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3F51B5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          "Scan Here To Attendance!",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // QR BOX
                    Container(
                      width: isMobile ? 220 : 260,
                      height: isMobile ? 220 : 260,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.qr_code_2,
                          size: 160,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _RoundIconButton(
                          icon: Icons.flash_off,
                          onTap: () {},
                        ),
                        const SizedBox(width: 24),
                        _RoundIconButton(
                          icon: Icons.cameraswitch,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Icon(icon, color: const Color(0xFF1A237E)),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
///  ATTENDANCE TAB
/// ---------------------------------------------------------------------------

class AttendanceTab extends StatefulWidget {
  const AttendanceTab({super.key});

  @override
  State<AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends State<AttendanceTab> {
  int _filterIndex = 0; // 0 = this week, 1 = this month, 2 = date

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Attendance Summary.\nCheck your class attendance record below!",
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),

          // SUMMARY CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A237E), Color(0xFF3F51B5)],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Attendance Rate",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "92 %",
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Present: 23   Late: 1   Absent: 2",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),

          const SizedBox(height: 16),

          // FILTER BAR
          Row(
            children: [
              _FilterChip(
                label: "This Week",
                selected: _filterIndex == 0,
                onTap: () => setState(() => _filterIndex = 0),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: "This Month",
                selected: _filterIndex == 1,
                onTap: () => setState(() => _filterIndex = 1),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: "Date",
                selected: _filterIndex == 2,
                onTap: () => setState(() => _filterIndex = 2),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.filter_alt_outlined),
                onPressed: () {},
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ATTENDANCE LIST
          _AttendanceItem(
            course: "Mobile Platform (A)",
            time: "1 Nov 2025 | 14:00 - 16:30",
            status: "Present",
            statusColor: Colors.green,
          ),
          _AttendanceItem(
            course: "Web Programming (A)",
            time: "30 Oct 2025 | 08:00 - 10:30",
            status: "Present",
            statusColor: Colors.green,
          ),
          _AttendanceItem(
            course: "Software Modelling and Analyst (A)",
            time: "1 Nov 2025 | 08:00 - 10:30",
            status: "Absent",
            statusColor: Colors.red,
            showIcon: true,
          ),

          const SizedBox(height: 16),
          const Text(
            "If you couldn't scan QR, mark your attendance manually.",
          ),
          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A237E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                "Mark Presence",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF1A237E) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _AttendanceItem extends StatelessWidget {
  final String course;
  final String time;
  final String status;
  final Color statusColor;
  final bool showIcon;

  const _AttendanceItem({
    required this.course,
    required this.time,
    required this.status,
    required this.statusColor,
    this.showIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(time),
              ],
            ),
          ),
          if (showIcon)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.bar_chart, size: 18),
            ),
          Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
///  PROGRESS TAB
/// ---------------------------------------------------------------------------

class ProgressTab extends StatefulWidget {
  const ProgressTab({super.key});

  @override
  State<ProgressTab> createState() => _ProgressTabState();
}

class _ProgressTabState extends State<ProgressTab> {
  int _filterIndex = 0; // 0 = this semester, 1 = overall

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Track your academic and attendance performance.",
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),

          // GPA CIRCLE
          Center(
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF1A237E),
                  width: 8,
                ),
              ),
              child: const Center(
                child: Text(
                  "4.00\nGPA",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // FILTER
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FilterChip(
                label: "This Semester",
                selected: _filterIndex == 0,
                onTap: () => setState(() => _filterIndex = 0),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: "Overall",
                selected: _filterIndex == 1,
                onTap: () => setState(() => _filterIndex = 1),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const _GradeRow(course: "Mobile Platform", grade: "A"),
          const _GradeRow(course: "Web Programming", grade: "A"),
          const _GradeRow(
              course: "Software Modelling and Analyst", grade: "A"),
        ],
      ),
    );
  }
}

class _GradeRow extends StatelessWidget {
  final String course;
  final String grade;

  const _GradeRow({required this.course, required this.grade});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          course,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Grades"),
            Text(
              grade,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E)),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}

/// ---------------------------------------------------------------------------
///  COURSE TAB
/// ---------------------------------------------------------------------------

class CourseTab extends StatefulWidget {
  const CourseTab({super.key});

  @override
  State<CourseTab> createState() => _CourseTabState();
}

class _CourseTabState extends State<CourseTab> {
  int _tabIndex = 0; // 0 today, 1 tomorrow, 2 all

  final List<CourseData> courses = [
    CourseData(
      name: "Mobile Platform (A)",
      lecturer: "Binanda Wicaksana",
      time: "Friday 09:00 - 11:30",
      progress: 0.5,
      statusText: "50 %",
      isAbsent: false,
    ),
    CourseData(
      name: "Web Programming (A)",
      lecturer: "Anggra Triawan",
      time: "Friday 13:00 - 16:00",
      progress: 0.5,
      statusText: "50 %",
      isAbsent: false,
    ),
    CourseData(
      name: "English (A)",
      lecturer: "Nurlhayati",
      time: "Monday 09:00 - 11:30",
      progress: 0.5,
      statusText: "50 %",
      isAbsent: false,
    ),
    CourseData(
      name: "Calculus (A)",
      lecturer: "Mientarsih",
      time: "Tuesday 13:00 - 15:00",
      progress: 0.0,
      statusText: "Absent",
      isAbsent: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TAB HEADER
          Row(
            children: [
              _FilterChip(
                label: "Today's Classes",
                selected: _tabIndex == 0,
                onTap: () => setState(() => _tabIndex = 0),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: "Tomorrow's Classes",
                selected: _tabIndex == 1,
                onTap: () => setState(() => _tabIndex = 1),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: "All",
                selected: _tabIndex == 2,
                onTap: () => setState(() => _tabIndex = 2),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // COURSE LIST
          for (final c in courses) _CourseCard(data: c),
        ],
      ),
    );
  }
}

class CourseData {
  final String name;
  final String lecturer;
  final String time;
  final double progress;
  final String statusText;
  final bool isAbsent;

  CourseData({
    required this.name,
    required this.lecturer,
    required this.time,
    required this.progress,
    required this.statusText,
    required this.isAbsent,
  });
}

class _CourseCard extends StatelessWidget {
  final CourseData data;

  const _CourseCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final bool isAbsent = data.isAbsent;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: isAbsent
            ? null
            : const LinearGradient(
                colors: [Color(0xFF1A237E), Color(0xFF3F51B5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        color: isAbsent ? Colors.white : null,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: isAbsent ? Colors.black87 : Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    data.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isAbsent ? Colors.black87 : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              data.lecturer,
              style: TextStyle(
                color: isAbsent ? Colors.black87 : Colors.white70,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data.time,
              style: TextStyle(
                color: isAbsent ? Colors.black87 : Colors.white70,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                if (!isAbsent)
                  Expanded(
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: data.progress,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (!isAbsent) const SizedBox(width: 8),
                Text(
                  data.statusText,
                  style: TextStyle(
                    color:
                        isAbsent ? Colors.red : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
///  PROFILE PAGE
/// ---------------------------------------------------------------------------

class ProfilePage extends StatelessWidget {
  final String username;

  const ProfilePage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const _DashboardAppBar(
              title: "Profile",
              showBack: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    CircleAvatar(
                      radius: 48,
                      backgroundImage:
                          const AssetImage('assets/images/circle2.png'),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Aliyatu Shabrina Zein",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Text(
                      "Informatics Engineering - Undergraduate",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Account Settings",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const EditProfilePage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A237E),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: const Text(
                              "Edit Profile",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // EMAIL ROW
                    _ProfileRow(
                      icon: Icons.email_outlined,
                      title: "Email Address",
                      value: "aliyatushbrn@gmail.com",
                    ),
                    _ProfileRow(
                      icon: Icons.color_lens_outlined,
                      title: "App Theme",
                      value: "Light",
                      showToggle: true,
                    ),

                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Notification Preferences",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _PreferenceSwitch(
                      title: "Allow Push Notifications",
                      initialValue: true,
                    ),
                    const _PreferenceSwitch(
                      title: "Class Reminders",
                      initialValue: true,
                    ),
                    const _PreferenceSwitch(
                      title: "New Course Update",
                      initialValue: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool showToggle;

  const _ProfileRow({
    required this.icon,
    required this.title,
    required this.value,
    this.showToggle = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: const Color(0xFF1A237E)),
      title: Text(title),
      subtitle: showToggle ? null : Text(value),
      trailing: showToggle
          ? Switch(
              value: false,
              onChanged: (_) {},
            )
          : const Icon(Icons.chevron_right),
    );
  }
}

class _PreferenceSwitch extends StatefulWidget {
  final String title;
  final bool initialValue;

  const _PreferenceSwitch({
    required this.title,
    required this.initialValue,
  });

  @override
  State<_PreferenceSwitch> createState() => _PreferenceSwitchState();
}

class _PreferenceSwitchState extends State<_PreferenceSwitch> {
  late bool value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(widget.title),
      value: value,
      activeColor: const Color(0xFF1A237E),
      onChanged: (v) => setState(() => value = v),
    );
  }
}

/// ---------------------------------------------------------------------------
///  EDIT PROFILE PAGE (DUMMY, SAVE → KEMBALI KE PROFILE)
/// ---------------------------------------------------------------------------

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController =
        TextEditingController(text: "Aliyatu Shabrina Zein");
    final idController = TextEditingController(text: "12524025");
    final majorController =
        TextEditingController(text: "Software Engineering");
    final emailController =
        TextEditingController(text: "aliyatushbrn@gmail.com");

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const _DashboardAppBar(
              title: "Edit Profile",
              showBack: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundImage:
                              const AssetImage('assets/images/circle2.png'),
                        ),
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: Material(
                            color: Colors.white,
                            shape: const CircleBorder(),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                size: 18,
                                color: const Color(0xFF1A237E),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Text("Change Photo"),
                    ),
                    const SizedBox(height: 20),
                    _EditField(label: "Name", controller: nameController),
                    _EditField(label: "Student ID", controller: idController),
                    _EditField(label: "Major", controller: majorController),
                    _EditField(label: "Email", controller: emailController),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A237E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          "Save Change",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _EditField({
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
///  NOTIFICATION PAGE
/// ---------------------------------------------------------------------------

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A237E), Color(0xFF3F51B5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const _DashboardAppBar(
                title: "Notification",
                showBack: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: const [
                      _NotificationCard(
                        title: "You have class in 10 minutes",
                        subtitle: "Mobile Platform (A)\n1 Nov 2025, 09:00",
                        icon: Icons.calendar_today_outlined,
                      ),
                      _NotificationCard(
                        title:
                            "Your attendance for Web Programming updated: present",
                        subtitle: "31 Oct 2025, 13:00",
                        icon: Icons.show_chart_outlined,
                      ),
                      _NotificationCard(
                        title: "New announcement from: AI Fundamentals",
                        subtitle: "30 Oct 2025, 09:00",
                        icon: Icons.chat_bubble_outline,
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1A237E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding:
                          const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      "View All",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _NotificationCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF1A237E)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(subtitle),
              ],
            ),
          )
        ],
      ),
    );
  }
}
