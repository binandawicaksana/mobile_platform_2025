import 'package:flutter/material.dart';

class UtsPage extends StatefulWidget {
  const UtsPage({super.key});

  @override
  State<UtsPage> createState() => _UtsPageState();
}

class _UtsPageState extends State<UtsPage> {
  static const Color primaryColor = Color(0xFF0057FF);

  final TextEditingController _taskController = TextEditingController();

  // Model tugas
  final List<_TodoTask> _tasks = [
    _TodoTask(title: "Lari Pagi", isDone: false),
  ];

  // 0 = semua, 1 = aktif, 2 = selesai
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
      // aktif
      return _tasks.where((t) => !t.isDone).toList();
    } else if (_filterIndex == 2) {
      // selesai
      return _tasks.where((t) => t.isDone).toList();
    }
    return _tasks;
  }

  int get _activeCount => _tasks.where((t) => !t.isDone).length;
  int get _doneCount => _tasks.where((t) => t.isDone).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F2FF),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tombol menu di kiri atas (dummy)
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () {
                    Navigator.pop(context);  // kembali ke dashboard
                  },
                ),
              ),
            ),


              const SizedBox(height: 32),

              // TextField tambah tugas
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
                  ),
                  onSubmitted: (_) => _addTask(),
                ),
              ),

              const SizedBox(height: 16),

              // Tombol Tambahkan Tugas
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 3,
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

              const SizedBox(height: 20),

              // Kartu filter: Semua / Aktif / Selesai
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Bar biru "Semua" (aktif)
                    GestureDetector(
                      onTap: () {
                        setState(() => _filterIndex = 0);
                      },
                      child: Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: _filterIndex == 0
                              ? primaryColor
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Semua",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        setState(() => _filterIndex = 1);
                      },
                      child: Text(
                        "Aktif (${_activeCount})",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: _filterIndex == 1
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() => _filterIndex = 2);
                      },
                      child: Text(
                        "Selesai (${_doneCount})",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: _filterIndex == 2
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Daftar tugas
              Expanded(
                child: _filteredTasks.isEmpty
                    ? const Center(
                        child: Text(
                          "Belum ada tugas",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.separated(
                        itemCount: _filteredTasks.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final task = _filteredTasks[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: task.isDone,
                                  onChanged: (val) => _toggleTask(task, val),
                                  shape: const CircleBorder(),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    task.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      decoration: task.isDone
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 10),

              // Kartu jumlah tugas tersisa
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
    );
  }
}

class _TodoTask {
  _TodoTask({required this.title, this.isDone = false});

  String title;
  bool isDone;
}
