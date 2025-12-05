import 'package:flutter/material.dart';
import 'package:uas/dashboard/columnpage.dart';
import 'package:uas/dashboard/dashboardpage.dart';
import 'package:uas/dashboard/gridviewpage.dart';
import 'package:uas/dashboard/listpage.dart';
import 'package:uas/dashboard/rowpage.dart';
import 'package:uas/login.dart';
import 'package:toastification/toastification.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String JUDUL = 'Ini Dashboard';
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Dashboardpage();
  int currentTab = 0;
  // final List<Widget> screens = [
  //   Dashboardpage(),
  //   Rowpage(),
  //   Columnpage(),
  // ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Padding(
        //   padding: const EdgeInsets.only(left: 16.0),
        //   child: Icon(Icons.dashboard, color: Colors.yellow),
        // ),
        title: Text(
          JUDUL,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.yellow,
          ),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.settings, color: Colors.yellow),
            onSelected: (String value) {
              if (value == 'profile') {
                toastification.show(
                  context: context, // optional if you use ToastificationWrapper
                  title: Text('Ini Profile'),
                  autoCloseDuration: const Duration(seconds: 5),
                );
              } else if (value == 'logout') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              } else if (value == 'exit') {
              } else if (value == 'password') {}
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'profile',
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profil'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'password',
                child: ListTile(
                  leading: Icon(Icons.key),
                  title: Text('Ganti Password'),
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'exit',
                child: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Keluar Aplikasi'),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
        ],
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero, // Penting untuk tampilan penuh
          children: const <Widget>[
            // 1. Header Drawer
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Nama Pengguna'),
            ),
            // 2. Item Navigasi
            ListTile(leading: Icon(Icons.home), title: Text('Beranda')),
            ListTile(leading: Icon(Icons.settings), title: Text('Pengaturan')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logic yang dijalankan saat tombol ditekan
          print('FAB ditekan: Buat Item Baru!');
        },
        tooltip: 'Tambah Item Baru', // Teks yang muncul saat ditekan lama
        child: const Icon(
          Icons.add,
        ), // Biasanya ikon '+' atau ikon terkait tindakan
      ),

      // Properti untuk mengatur posisi (contoh: di tengah bawah)
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
      body: SafeArea(
        child: PageStorage(bucket: bucket, child: currentScreen),
      ),

      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Container(
          height: 80,
          color: Colors.blue,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //menu1
              MaterialButton(
                minWidth: 30,
                onPressed: () {
                  setState(() {
                    currentScreen = Dashboardpage();
                    currentTab = 0;
                    JUDUL = "Dashboard";
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home,
                      size: 35,
                      color: currentTab == 0
                          ? Colors.black
                          : Colors.yellowAccent,
                    ),
                    Text(
                      "Dashboard",
                      style: TextStyle(
                        color: currentTab == 0
                            ? Colors.black
                            : Colors.yellowAccent,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              //menu2
              MaterialButton(
                minWidth: 30,
                onPressed: () {
                  setState(() {
                    currentScreen = Rowpage();
                    currentTab = 1;
                    JUDUL = "Contoh Row";
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bar_chart,
                      size: 35,
                      color: currentTab == 1
                          ? Colors.black
                          : Colors.yellowAccent,
                    ),
                    Text(
                      "ROW",
                      style: TextStyle(
                        color: currentTab == 1
                            ? Colors.black
                            : Colors.yellowAccent,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // menu3
              MaterialButton(
                minWidth: 30,
                onPressed: () {
                  setState(() {
                    currentScreen = Columnpage();
                    currentTab = 2;
                    JUDUL = "Contoh Column";
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.view_column,
                      size: 35,
                      color: currentTab == 2
                          ? Colors.black
                          : Colors.yellowAccent,
                    ),
                    Text(
                      "Column",
                      style: TextStyle(
                        color: currentTab == 2
                            ? Colors.black
                            : Colors.yellowAccent,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // menu4
              MaterialButton(
                minWidth: 30,
                onPressed: () {
                  setState(() {
                    currentScreen = Listpage();
                    currentTab = 3;
                    JUDUL = "Contoh List View";
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.list,
                      size: 35,
                      color: currentTab == 3
                          ? Colors.black
                          : Colors.yellowAccent,
                    ),
                    Text(
                      "List",
                      style: TextStyle(
                        color: currentTab == 3
                            ? Colors.black
                            : Colors.yellowAccent,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // menu5
              MaterialButton(
                minWidth: 30,
                onPressed: () {
                  setState(() {
                    currentScreen = Gridviewpage();
                    currentTab = 4;
                    JUDUL = "Contoh Grid View";
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.grid_3x3,
                      size: 35,
                      color: currentTab == 4
                          ? Colors.black
                          : Colors.yellowAccent,
                    ),
                    Text(
                      "Grid",
                      style: TextStyle(
                        color: currentTab == 4
                            ? Colors.black
                            : Colors.yellowAccent,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          //  ],
          // ),
        ),
      ),
    );
  }
}
