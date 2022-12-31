import 'package:flutter/material.dart';
import 'package:nugasyik/add_update_form.dart';
import 'package:nugasyik/homework.dart';
import 'package:nugasyik/db_provider.dart';
import 'package:provider/provider.dart';
import 'package:nugasyik/next_page.dart';

class DetailPage extends StatelessWidget {
  final Homework homework;
  final int deadlineRemaining;

  const DetailPage(
      {super.key, required this.homework, required this.deadlineRemaining});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 195, 187, 255),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 226, 226, 226),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        title: Text(
          homework.title,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.all(15),
              color: Color.fromARGB(255, 105, 92, 247),
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Detail Tugas",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    // color: Colors.white,
                    color: Color.fromARGB(255, 226, 226, 226),
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Judul: ${homework.title}",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Mata Kuliah: ${homework.subject}",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Deadline: ${homework.deadline}",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Sisa deadline: ${deadlineRemaining} hari",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              color: Color.fromARGB(255, 105, 92, 247),
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Deskripsi Tugas",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    // color: Colors.white,
                    color: Color.fromARGB(255, 226, 226, 226),
                    // width: double.infinity,
                    constraints: BoxConstraints(
                        minWidth: double.infinity, minHeight: 150),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          homework.description,
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
              width: double.infinity,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 255, 174, 0)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddUpdatePage(
                                homework: homework,
                                fromDetail: true,
                              ),
                            ));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit),
                          Text(
                            "Edit",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      )),
                  ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
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
                                  // Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NextPage(),
                                      ));
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
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete),
                          Text(
                            "Hapus",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
