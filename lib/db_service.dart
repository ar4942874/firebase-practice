import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_practice_f15/to_do_.dart';

class DbService {
  static const _toDoCollectionName = 'ToDo';
  static DbService? _instance;
  DbService._internal();
  factory DbService() => _instance ?? DbService._internal();
  final toDoCollection =
      FirebaseFirestore.instance.collection(_toDoCollectionName);
  Future<bool> addToDo(ToDo todo) async {
    try {
      await toDoCollection.doc(todo.title.toString()).set(todo.toMap());
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> updateToDo(ToDo todo) async {
    try {
      await toDoCollection.doc(todo.title.toString()).update(todo.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<ToDo>> getData() async {
    var querySnapShot = await toDoCollection.get();
    var docs = querySnapShot.docs;
    return docs.map((e) => ToDo.fromMap(e.data())).toList();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> stream() {
    return toDoCollection.snapshots();
  }
}
