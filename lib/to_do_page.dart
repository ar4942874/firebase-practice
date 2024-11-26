import 'dart:developer';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_practice_f15/db_service.dart';
import 'package:flutter_firebase_practice_f15/to_do_.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  late TextEditingController titleController, descriptionController;
  final _toDb = DbService();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                _toDb
                    .addToDo(ToDo(
                        title: titleController.text,
                        description: descriptionController.text))
                    .then(
                      (value) => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('data inserted'),
                        ),
                      ),
                    );
              },
              icon: const Icon(Icons.add)),
          IconButton(
              onPressed: () {
                _toDb
                    .updateToDo(ToDo(
                        title: titleController.text,
                        description: descriptionController.text))
                    .then(
                      (value) => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('data inserted'),
                        ),
                      ),
                    );
              },
              icon: const Icon(Icons.update))
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 200,
              child: TextFormField(
                controller: titleController,
                decoration:
                    const InputDecoration(border: UnderlineInputBorder()),
              ),
            ),
            SizedBox(
              width: 400,
              child: TextFormField(
                controller: descriptionController,
                decoration:
                    const InputDecoration(border: UnderlineInputBorder()),
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.45,
              width: MediaQuery.sizeOf(context).width * 1,
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _toDb.stream(),
                builder: (context, snapshot) {
                  log('[${snapshot.connectionState}]');
                  if (snapshot.connectionState == ConnectionState.none) {
                    return const Text('No Data');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    List<ToDo> todo = snapshot.data!.docs
                        .map((e) => ToDo.fromMap(e.data()))
                        .toList();
                    return ListView.builder(
                      itemCount: todo.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Text(todo[index].title),
                          subtitle: Text(todo[index].description),
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _toDb.getData();
        },
        child: const Icon(Icons.list),
      ),
    );
  }
}
