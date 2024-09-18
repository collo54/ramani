import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/user_map_data_model.dart';
import 'document_path.dart';

//String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreService {
  FirestoreService({required this.uid});
  final String uid;

  // generic funtion creates a dcomcument and sets data in the document
  Future<void> _set({required String path, Map<String, dynamic>? data}) async {
    final DocumentReference<Map<String, dynamic>?> reference =
        FirebaseFirestore.instance.doc(path);
    if (kDebugMode) {
      print('$path: $data');
    }
    await reference.set(data);
  }

  //creates or writes a UserMapdatamodel for users collection per user id
  Future<void> setUserMapDataModel(UserMapDataModel dataModel) async {
    await _set(
      path: DocumentPath.newUserMarkerData(uid, dataModel.id),
      data: dataModel.toJson(),
    );
  }

  //reads a UserMapdatamodel for users collection per user id
  Stream<List<UserMapDataModel>> userMapDataModelStream() {
    final path = DocumentPath.streamUserMarkerData(uid);
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map((
          snapshot,
        ) =>
            UserMapDataModel.fromJson(snapshot.data(), snapshot.id))
        .toList());
  }

  //deletes a doc from usersMarkers collection
  Future<void> deleteUserMapDataModel(UserMapDataModel dataModel) async {
    final path = DocumentPath.newUserMarkerData(uid, dataModel.id);
    final reference = FirebaseFirestore.instance.doc(path);
    if (kDebugMode) {
      print('delete: $path');
    }
    await reference.delete();
  }

  //creates or writes a location marker
  Future<void> setLocation(UserMapDataModel dataModel) async {
    await _set(
      path: DocumentPath.newLocation(dataModel.id),
      data: dataModel.toJson(),
    );
  }

  //reads a latlang from Locations collection
  Stream<List<UserMapDataModel>> locationsStream() {
    final path = DocumentPath.streamLocation();
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map((
          snapshot,
        ) =>
            UserMapDataModel.fromJson(snapshot.data(), snapshot.id))
        .toList());
  }

  //deletes a doc from locations collection
  Future<void> deleteLocation(UserMapDataModel dataModel) async {
    final path = DocumentPath.newLocation(dataModel.id);
    final reference = FirebaseFirestore.instance.doc(path);
    if (kDebugMode) {
      print('delete: $path');
    }
    await reference.delete();
  }
     
     //TODO change parameter to UserFirebaseModel
    //creates or writes a User for users collection per user id
  Future<void> setUserModel(UserMapDataModel dataModel) async {
    await _set(
      path: DocumentPath.newUser(uid, dataModel.id),
      data: dataModel.toJson(),
    );
  }

  //reads a UserMapdatamodel for users collection per user id
  Stream<List<UserMapDataModel>> userModelStream() {
    final path = DocumentPath.streamUser(uid);
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map((
          snapshot,
        ) =>
            UserMapDataModel.fromJson(snapshot.data(), snapshot.id))
        .toList());
  }

  //deletes a doc from usersMarkers collection
  Future<void> deleteUserModel(UserMapDataModel dataModel) async {
    final path = DocumentPath.newUser(uid, dataModel.id);
    final reference = FirebaseFirestore.instance.doc(path);
    if (kDebugMode) {
      print('delete: $path');
    }
    await reference.delete();
  }
}
