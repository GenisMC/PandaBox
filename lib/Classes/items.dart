class Item {
  String docId;
  String fileName;
  String downloadURL;
  String displayName;
  String authId;
  bool visible;
  Item(
      {required this.docId,
      required this.fileName,
      required this.downloadURL,
      required this.displayName,
      required this.authId,
      required this.visible});
}
