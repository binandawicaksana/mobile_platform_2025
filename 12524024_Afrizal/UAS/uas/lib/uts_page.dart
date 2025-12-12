import 'package:flutter/material.dart';

import 'main.dart';
import 'widgets/app_drawer.dart';

class UtsPage extends StatefulWidget {
  const UtsPage({super.key});

  @override
  State<UtsPage> createState() => _UtsPageState();
}

class _UtsPageState extends State<UtsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static const Color primaryColor = Color(0xFF0057FF);

  final TextEditingController _taskController = TextEditingController();

  final List<_TodoTask> _tasks = [
    _TodoTask(title: "Lari Pagi", isDone: false),
  ];

  int _filterIndex = 0;

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _addTask() {
    final text = _taskController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _tasks.add(_TodoTask(title: text));
      _taskController.clear();
    });
  }

  void _toggleTask(_TodoTask task, bool? value) {
    setState(() {
      task.isDone = value ?? false;
    });
  }

  List<_TodoTask> get _filteredTasks {
    if (_filterIndex == 1) {
      return _tasks.where((t) => !t.isDone).toList();
    } else if (_filterIndex == 2) {
      return _tasks.where((t) => t.isDone).toList();
    }
    return _tasks;
  }

  int get _activeCount => _tasks.where((t) => !t.isDone).length;
  int get _doneCount => _tasks.where((t) => t.isDone).length;

  @override
  Widget build(BuildContext context) {
    final accentColor =
        AppStateScope.of(context)?.pageSeedColor ?? primaryColor;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFE9F2FF),
      drawer: AppDrawer(
        activeDestination: DrawerDestination.aplikasi,
        onGoToDashboard: () => Navigator.of(context).maybePop(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.menu_rounded),
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    ),
                  ),
                ),
                const SizedBox(height: 125),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Tambahkan tugas baru...",
                      hintStyle: TextStyle(color: Colors.black38),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 4,
                    ),
                    onPressed: _addTask,
                    child: const Text(
                      "Tambahkan Tugas +",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildFilterButton(
                        label: "Semua",
                        index: 0,
                        accentColor: accentColor,
                        height: 42,
                        radius: 18,
                      ),
                      const SizedBox(height: 14),
                      _buildFilterButton(
                        label: "Aktif (${_activeCount})",
                        index: 1,
                        accentColor: accentColor,
                      ),
                      const SizedBox(height: 12),
                      _buildFilterButton(
                        label: "Selesai (${_doneCount})",
                        index: 2,
                        accentColor: accentColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ..._buildTaskList(),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    "${_activeCount} Tugas Tersisa",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton({
    required String label,
    required int index,
    required Color accentColor,
    double height = 36,
    double radius = 18,
  }) {
    final bool isActive = _filterIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _filterIndex = index),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: isActive ? accentColor : Colors.white,
          borderRadius: BorderRadius.circular(radius),
          border: isActive
              ? null
              : Border.all(color: Colors.transparent),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : accentColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTaskList() {
    if (_filteredTasks.isEmpty) {
      return const [
        SizedBox(
          height: 120,
          child: Center(
            child: Text(
              "Belum ada tugas",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ];
    }

    return _filteredTasks
        .map(
          (task) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black.withOpacity(0.4),
                        width: 2,
                      ),
                    ),
                    child: Checkbox(
                      value: task.isDone,
                      onChanged: (val) => _toggleTask(task, val),
                      shape: const CircleBorder(),
                      side: BorderSide.none,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: task.isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }
}

class _TodoTask {
  _TodoTask({required this.title, this.isDone = false});

  String title;
  bool isDone;
}
