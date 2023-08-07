import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pfa_flutter/utils/logger.dart';

class AppFirestore {
  static final instance = AppFirestore._();
  AppFirestore._();

  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<bool> setData({
    required String path,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    try {
      final reference = db.doc(path);
      await reference.set(data, SetOptions(merge: merge));
      Logger.i('[FirestoreService] setData $path');
      return true;
    } catch (e) {
      Logger.e('[FirestoreService] Error in setData', e);
      return false;
    }
  }

  Future<bool> updateData({
    required String path,
    required String field,
    required dynamic value,
  }) async {
    try {
      final reference =
          db.doc(path);
      await reference.update({field: value});
      Logger.i('[FirestoreService] updateData $field: $value');
      return true;
    } catch (e) {
      Logger.e('[FirestoreService] Error in updateData', e);
      return false;
    }
  }

  Future<bool> incrementData({
    required String path,
    required String field,
    required int value,
  }) async {
    try {
      final reference = db.doc(path);
      await reference.update({field: FieldValue.increment(value)});
      Logger.i('[FirestoreService] incrementData $field: $value');
      return true;
    } catch (e) {
      Logger.e('[FirestoreService] Error in incrementData', e);
      return false;
    }
  }

  Future<bool> addData({
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async {
    try {
      final reference = db.collection(collectionPath);
      final doc = await reference.add(data);
      Logger.i("[FirestoreService] addData ${doc.id}");
      return true;
    } catch (e) {
      Logger.e("[FirestoreService] Error in addData", e);
      return false;
    }
  }

  Future<bool> arrayUnion({
    required String path,
    required String arrayPath,
    required dynamic data,
  }) async {
    try {
      final reference = db.doc(path);
      Logger.i('[FirestoreService] arrayUnion $path, $arrayPath: $data');
      await reference.update({arrayPath: FieldValue.arrayUnion(data)});
      return true;
    } catch (e) {
      Logger.e("[FirestoreService] Error in arrayUnion", e);
      return false;
    }
  }

  Future<bool> arrayRemove({
    required String path,
    required dynamic data,
    required String arrayPath,
  }) async {
    try {
      final reference = db.doc(path);
      await reference.update({
        arrayPath: FieldValue.arrayRemove(data),
      });
      Logger.i('[FirestoreService] arrayRemove $arrayPath: $data');
      return true;
    } catch (e) {
      Logger.e("[FirestoreService] Error in arrayRemove", e);
      return false;
    }
  }

  Future<DocumentSnapshot?> getDoc({
    required String path,
  }) async {
    try {
      Logger.i("[FirestoreService] getDoc path: $path");
      final reference = db.doc(path);
      final doc = await reference.get();
      if (doc.exists) {
        Logger.i("[FirestoreService] getDoc - id: ${doc.id}");
        return doc;
      }
    } catch (e) {
      Logger.e("Error in getDoc", e);
      return null;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getData({
    required String path,
  }) async {
    try {
      final doc = await getDoc(path: path);
      final data = doc!.data() as Map<String, dynamic>;
      Logger.i("[FirestoreService] getDoc - data: $data");
      return data;
    } catch (e) {
      Logger.e("Error in getData", e);
      return null;
    }
  }

  Future<List<QueryDocumentSnapshot>?> queryData({
    required String collectionPath,
    required String field,
    required String value,
  }) async {
    try {
      final reference = db.collection(collectionPath);
      QuerySnapshot querySnapshot =
          await reference.where(field, isEqualTo: value).get();
      Logger.i(
          '[FirestoreService] queryData path: $collectionPath, docs: ${querySnapshot.docs.length}');
      return querySnapshot.docs;
    } catch (e) {
      Logger.e("Error in queryData", e);
      return null;
    }
  }

  Future<bool> deleteData({
    required String path,
  }) async {
    try {
      final reference = db.doc(path);
      Logger.i('[FirestoreService] delete: $path');
      await reference.delete();
      return true;
    } catch (e) {
      Logger.e("Error in deleteData", e);
      return false;
    }
  }
}
