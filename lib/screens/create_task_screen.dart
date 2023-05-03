import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todolist/constants/constants.dart';
import 'package:todolist/repositories/task_repository.dart';
import '../models/task.dart';

class CreateTaskScreen extends StatefulWidget {
  final Task? task;

  const CreateTaskScreen({super.key, this.task});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool isCreate = true;
  @override
  void initState() {
    super.initState();
    _titleController.text = widget.task?.title ?? "";
    _contentController.text = widget.task?.content ?? "";
    if (widget.task != null) {
      isCreate = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: colorPrimary,
        title: Text(
          isCreate ? 'Create new task' : 'Edit task',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () {
                Task task = Task(
                    id: widget.task?.id,
                    title: _titleController.text,
                    content: _contentController.text,
                    timeModified: DateTime.now());
                if (_formkey.currentState!.validate()) {
                  if (widget.task != null) {
                    if (widget.task!.title != task.title ||
                        widget.task!.content != task.content) {
                      TaskRepository().editTask(task);
                    }
                  } else {
                    TaskRepository().createTask(task);
                  }
                  Navigator.pop(context);
                }

              },
              child: Icon(
                isCreate ? Icons.save : Icons.edit,
                size: 25,
              ),
            ),
          )
        ],
      ),
      body: Form(
        key: _formkey,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Title',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              TextFormField(
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  hintText: 'Enter title',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 15,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: colorPrimary,
                    ),
                  ),
                ),
                cursorColor: colorPrimary,
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a title";
                  }
                  return null;
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Content',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 400,
                child: TextFormField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1000),
                  ],
                  maxLength: 1000,
                  maxLines: 100,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: colorPrimary,
                      ),
                    ),
                    hintText: 'Enter content',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 15,
                    ),
                  ),
                  cursorColor: colorPrimary,
                  controller: _contentController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
