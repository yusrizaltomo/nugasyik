import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nugasyik/db_provider.dart';
import 'package:nugasyik/detail_page.dart';
import 'package:nugasyik/homework.dart';
import 'package:provider/provider.dart';
import 'package:nugasyik/next_page.dart';

class AddUpdatePage extends StatefulWidget {
  final Homework? homework;
  final bool? fromDetail;

  const AddUpdatePage({Key? key, this.homework, this.fromDetail})
      : super(key: key);

  @override
  State<AddUpdatePage> createState() => _AddUpdatePageState();
}

class _AddUpdatePageState extends State<AddUpdatePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  bool _isUpdate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.homework != null) {
      _titleController.text = widget.homework!.title;
      _subjectController.text = widget.homework!.subject;
      _descriptionController.text = widget.homework!.description;
      _deadlineController.text = widget.homework!.deadline;
      _isUpdate = true;
    }

    if (_isUpdate == false) {
      _deadlineController.text =
          DateFormat('dd-MM-yyyy').format(DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 195, 187, 255),
      appBar: AppBar(
        centerTitle: true,
        // title: Text(
        //   "Form Tambah Tugas",
        //   style: TextStyle(color: Colors.black),
        // ),
        title: (_isUpdate == true)
            ? Text(
                "Form Edit Tugas",
                style: TextStyle(color: Colors.black),
              )
            : Text(
                "Form Tambah Tugas",
                style: TextStyle(color: Colors.black),
              ),
        backgroundColor: Color.fromARGB(255, 226, 226, 226),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              // Text(
              //   "Judul",
              //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              // ),
              // SizedBox(
              //   height: 5,
              // ),
              TextField(
                controller: _titleController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  filled: true,
                  border: OutlineInputBorder(),
                  fillColor: Color.fromARGB(255, 226, 226, 226),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _subjectController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Mata Kuliah',
                  filled: true,
                  border: OutlineInputBorder(),
                  fillColor: Color.fromARGB(255, 226, 226, 226),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // Text(
              //   "Deskripsi",
              //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              // ),
              // SizedBox(
              //   height: 5,
              // ),
              TextField(
                maxLines: 8,
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  alignLabelWithHint: true,
                  filled: true,
                  border: OutlineInputBorder(),
                  fillColor: Color.fromARGB(255, 226, 226, 226),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _deadlineController,
                decoration: const InputDecoration(
                  labelText: 'Deadline',
                  filled: true,
                  border: OutlineInputBorder(),
                  fillColor: Color.fromARGB(255, 226, 226, 226),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100));
                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('dd-MM-yyyy').format(pickedDate);
                    setState(() {
                      _deadlineController.text = formattedDate;
                    });
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  // child: const Text(
                  //   'Simpan',
                  //   style: TextStyle(fontSize: 20),
                  // ),
                  child: (_isUpdate == true)
                      ? Text('Update', style: TextStyle(fontSize: 20))
                      : Text('Simpan', style: TextStyle(fontSize: 20)),
                  onPressed: () async {
                    // final homework = Homework(
                    //   title: _titleController.text,
                    //   description: _descriptionController.text,
                    // );
                    if (_isUpdate == true) {
                      final homework = Homework(
                        id: widget.homework!.id,
                        title: _titleController.text,
                        subject: _subjectController.text,
                        description: _descriptionController.text,
                        deadline: _deadlineController.text,
                      );
                      Provider.of<DbProvider>(context, listen: false)
                          .editHomework(homework);
                      if (widget.fromDetail == true) {
                        Navigator.pop(context);
                      }
                    } else {
                      final homework = Homework(
                        title: _titleController.text,
                        subject: _subjectController.text,
                        description: _descriptionController.text,
                        deadline: _deadlineController.text,
                      );
                      Provider.of<DbProvider>(context, listen: false)
                          .addHomework(homework);
                    }
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 75, 57, 239)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
