import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codepandas/Classes/items.dart';
// ignore_for_file: import_of_legacy_library_into_null_safe

class DatabaseService {
  //Collection reference
  final CollectionReference itemCollection =
      FirebaseFirestore.instance.collection('items');

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

  Future<List<Item>> getItems() async {
    List<Item> items = [];

    await itemCollection
        .where("visible", isEqualTo: false)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        items.add(Item(
            docId: doc.id,
            downloadURL: doc["URL"],
            fileName: doc["FileName"],
            displayName: doc["DisplayName"],
            authId: doc["author"],
            visible: doc["visible"]));
      });
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
}
