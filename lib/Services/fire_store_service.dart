// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codepandas/Classes/app_user.dart';
import 'package:codepandas/Classes/items.dart';
// ignore_for_file: import_of_legacy_library_into_null_safe

class DatabaseService {
  //Collection reference
  final CollectionReference itemCollection =
      FirebaseFirestore.instance.collection('items');

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  // FILES

  Future setFileReference(String? downloadURL, String? fileName,
      String? displayName, String? authorId, bool visible) async {
    return await itemCollection.doc().set({
      'URL': downloadURL,
      'FileName': fileName,
      'DisplayName': displayName,
      'author': authorId,
      'visible': visible
    });
  }

  Future<List<Item>> getItems(String? userId) async {
    List<Item> items = [];

    await itemCollection
        .where("visible", isEqualTo: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc["author"] == userId) {
          items.add(Item(
              docId: doc.id,
              downloadURL: doc["URL"],
              fileName: doc["FileName"],
              displayName: doc["DisplayName"],
              authId: doc["author"],
              visible: doc["visible"]));
        }
      }
    });

    return items;
  }

  Future deleteItem(String docId) async {
    return itemCollection
        .doc(docId)
        .delete()
        .then((value) => print('Item Deleted!'))
        .catchError((error) => print('Error: $error'));
  }

  //  USERS

  Future setUserData(
      String? uid, String? name, String? email, String? image) async {
    if (uid != null) {
      var alreadyKnown =
          await userCollection.where("uid", isEqualTo: uid).get();

      if (alreadyKnown.docs.isEmpty) {
        return await userCollection.doc().set(
            {'uid': uid, 'name': name, 'email': email, 'profilePhoto': image});
      } else {
        print("Already Known User");
      }
    } else {
      print("Empty user?");
    }
  }

  Future<List<AppUser>> getUsers() async {
    List<AppUser> users = [];

    await userCollection.get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        users.add(AppUser(
            uid: doc["uid"],
            name: doc["name"],
            email: doc["email"],
            profilePhoto: doc["profilePhoto"]));
      }
    });

    return users;
  }
}
