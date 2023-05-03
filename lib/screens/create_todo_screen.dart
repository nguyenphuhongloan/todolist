import 'package:flutter/material.dart';

import 'package:todolist/repositories/todo_repository.dart';

import '../constants/constants.dart';
import '../models/todo.dart';

class CreateTodoScreen extends StatefulWidget {
  static late List<TodoItemWidget> listTodoWidget;
  static List<TextEditingController> _controllers = <TextEditingController>[];
  static List<bool> checkBoxStateList = [];
  final Todo? todo;
  const CreateTodoScreen({super.key, this.todo});
  @override
  State<CreateTodoScreen> createState() => _CreateTodoScreenState();
}

class _CreateTodoScreenState extends State<CreateTodoScreen> {
  final TextEditingController _titleController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  int tmpId = 0;
  bool isCreate = true;
  @override
  void initState() {
    super.initState();
    _titleController.text = widget.todo?.title ?? "";
    buildItems();
    if (widget.todo != null) {
      isCreate = false;
    }
  }

  void buildItems() {
    CreateTodoScreen.listTodoWidget = [];
    if (widget.todo != null) {
      CreateTodoScreen._controllers =
          widget.todo!.items!.map((e) => TextEditingController()).toList();
      CreateTodoScreen.checkBoxStateList =
          widget.todo!.items!.map((e) => e.check).toList();
      for (var i = 0; i < widget.todo!.items!.length; i++) {
        TodoItem e = widget.todo!.items![i];
        CreateTodoScreen.listTodoWidget.add(TodoItemWidget(
          tmpId: tmpId++,
          delete: update,
          item: e,
          controller: CreateTodoScreen._controllers[i],
          checkState: e.check,
        ));
      }
    } else {
      TextEditingController controller = TextEditingController();
      bool check = false;
      CreateTodoScreen._controllers.add(controller);
      CreateTodoScreen.checkBoxStateList.add(check);
      CreateTodoScreen.listTodoWidget.add(TodoItemWidget(
        tmpId: tmpId++,
        delete: update,
        item: TodoItem(subtitle: "", check: false),
        controller: controller,
        checkState: check,
      ));
    }
  }

  update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: colorPrimary,
        title: Text(
          isCreate ? 'Create new todolist' : 'Edit todolist',
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
                Todo todo = Todo(
                    id: widget.todo?.id,
                    title: _titleController.text,
                    items: CreateTodoScreen.listTodoWidget
                        .map((e) => TodoItem(
                            subtitle: e.controller.text, check: e.checkState))
                        .toList(),
                    timeModified: DateTime.now());
                if (_formkey.currentState!.validate()) {
                  if (widget.todo != null) {
                    TodoRepository().editTodo(todo);
                  } else {
                    TodoRepository().createTodo(todo);
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(18),
        child: SizedBox(
          width: 65,
          height: 65,
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                TextEditingController controller = TextEditingController();
                bool check = false;
                CreateTodoScreen._controllers.add(controller);
                CreateTodoScreen.checkBoxStateList.add(check);
                CreateTodoScreen.listTodoWidget.add(TodoItemWidget(
                  tmpId: tmpId++,
                  delete: update,
                  item: TodoItem(subtitle: "", check: false),
                  controller: controller,
                  checkState: check,
                ));
              });
            },
            elevation: 3,
            backgroundColor: colorPrimary,
            child: const Icon(Icons.add, size: 30),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formkey,
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
                  validator: (value)  {
                    if (value == null || value.isEmpty){
                      return "Please enter a title";
                    }
                    return null;
                  }
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
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
                Column(
                  children: CreateTodoScreen.listTodoWidget,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TodoItemWidget extends StatefulWidget {
  final int tmpId;
  final TodoItem item;
  final Function delete;
  final TextEditingController controller;
  bool checkState;
  TodoItemWidget({
    Key? key,
    required this.tmpId,
    required this.item,
    required this.delete,
    required this.controller,
    required this.checkState,
  }) : super(key: key);

  @override
  State<TodoItemWidget> createState() => _TodoItemWidgetState();
}

class _TodoItemWidgetState extends State<TodoItemWidget> {
  late bool check;

  @override
  void initState() {
    super.initState();
    widget.controller.text = widget.item.subtitle;
    check = widget.item.check;
  }

  @override
  void didUpdateWidget(covariant TodoItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    check = widget.checkState;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, right: 5),
          child: SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              activeColor: colorPrimary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: widget.checkState,
              onChanged: (bool? value) {
                setState(
                  () {
                    check = value!;
                    widget.checkState = value;
                  },
                );
              },
            ),
          ),
        ),
        Expanded(
          child: TextFormField(
            cursorColor: colorPrimary,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(top: 20),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colorPrimary),
              ),
            ),
            controller: widget.controller,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 5),
          child: GestureDetector(
            onTap: () {
              widget.item.subtitle = widget.controller.text;
              int index = CreateTodoScreen.listTodoWidget
                  .indexWhere((element) => element.tmpId == widget.tmpId);
              CreateTodoScreen._controllers.removeAt(index);
              CreateTodoScreen.checkBoxStateList.removeAt(index);
              CreateTodoScreen.listTodoWidget
                  .removeWhere((element) => element.tmpId == widget.tmpId);
              widget.delete();
            },
            child: const SizedBox(
                child: Icon(
              Icons.cancel_outlined,
              color: colorPrimary,
            )),
          ),
        )
      ],
    );
  }
}
