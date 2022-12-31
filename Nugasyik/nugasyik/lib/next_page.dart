import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:nugasyik/add_update_form.dart';
import 'package:nugasyik/db_provider.dart';
import 'package:provider/provider.dart';
import 'package:nugasyik/detail_page.dart';

class NextPage extends StatelessWidget {
  // const NextPage({super.key});
  NextPage({Key? key}) : super(key: key);

  final Future<SharedPreferences> _preference = SharedPreferences.getInstance();

  void logout() async {
    final SharedPreferences prefs = await _preference;
    prefs.remove('is_login');
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  Color deadlineColor(int deadlineRemaining) {
    if (deadlineRemaining <= 2) {
      return Colors.red;
    } else if (deadlineRemaining <= 7) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 195, 187, 255),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 226, 226, 226),
        // leading: IconButton(
        //   onPressed: () {
        //     logout();
        //     Navigator.pop(context);
        //   },
        //   icon: Icon(Icons.logout),
        //   color: Colors.black,
        // ),
        leading: TextButton(
          onPressed: () {
            logout();
            Navigator.pop(context);
          },
          child: Text(
            "Logout",
            style:
                TextStyle(fontSize: 15, color: Color.fromARGB(255, 56, 42, 61)),
          ),
        ),
        leadingWidth: 75,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Halo, User!",
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(
              width: 10.0,
            ),
            CircleAvatar(
              backgroundImage: AssetImage("assets/pots.jpg"),
              radius: 25,
            ),
          ],
        ),
        bottom: PreferredSize(
            child: Container(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "Tanggal: ${DateFormat('dd-MM-yyyy').format(DateTime.now())}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  // SizedBox(
                  //   width: 20,
                  // ),
                  Expanded(
                    child: Image.asset(
                      "assets/nugasyik.png",
                      width: 100,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
            preferredSize: Size.fromHeight(70.0)),
      ),
      body: Consumer<DbProvider>(
        builder: (context, provider, child) {
          final homeworks = provider.homeworks;

          return ListView.builder(
            padding: EdgeInsets.all(5),
            itemCount: homeworks.length,
            itemBuilder: (context, index) {
              final homework = homeworks[index];
              DateTime deadlineDate =
                  DateFormat('dd-MM-yyyy').parse(homework.deadline);
              int deadlineRemaining = daysBetween(DateTime.now(), deadlineDate);
              return Card(
                child: ListTile(
                  contentPadding: EdgeInsets.all(10),
                  tileColor: Color.fromARGB(255, 226, 226, 226),
                  title: Text(
                    homework.title,
                    style: TextStyle(fontSize: 18),
                  ),
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.priority_high,
                        size: 35,
                        color: deadlineColor(deadlineRemaining),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Mata Kuliah: ${homework.subject}",
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      // Text(
                      //   "Deskripsi:",
                      //   style: TextStyle(fontSize: 15),
                      // ),
                      // Text(
                      //   homework.description,
                      //   style: TextStyle(fontSize: 15),
                      // ),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      Text(
                        "Deadline: ${homework.deadline}",
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Sisa deadline: ${deadlineRemaining} hari",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  // onTap: () async {},
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(
                          homework: homework,
                          deadlineRemaining: deadlineRemaining,
                        ),
                      )),
                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      switch (value) {
                        case 'Edit':
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddUpdatePage(
                                  homework: homework,
                                ),
                              ));
                          break;
                        case 'Delete':
                          AlertDialog hapus = AlertDialog(
                            title: Text("Hapus Data"),
                            content: Container(
                              height: 50,
                              child: Column(
                                children: [
                                  Text("Yakin ingin menghapus data ini?")
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Provider.of<DbProvider>(context,
                                            listen: false)
                                        .removeHomework(homework.id);
                                    Navigator.pop(context);
                                  },
                                  child: Text("Ya")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Tidak"))
                            ],
                          );
                          showDialog(
                              context: context, builder: (context) => hapus);
                          break;
                      }
                    },
                    itemBuilder: (context) {
                      return {'Edit', 'Delete'}.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 75, 57, 239),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddUpdatePage(),
              ));
        },
        tooltip: "Tambah Tugas",
        child: Icon(Icons.add),
      ),
    );
  }
}
