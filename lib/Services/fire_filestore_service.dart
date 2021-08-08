import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
// ignore_for_file: import_of_legacy_library_into_null_safe

class FileStorageService {
  //Firebase storage reference
  final Reference storage = FirebaseStorage.instance.ref('items');

  Future listItems() async {
    ListResult result = await FirebaseStorage.instance.ref().listAll();

    for (var ref in result.items) {
      // ignore: avoid_print
      print('Found file: $ref');
    }

    for (var ref in result.prefixes) {
      // ignore: avoid_print
      print('Found directory: $ref');
    }
  }

  Future<FilePickerResult?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    return result;
  }

  Future uploadFile(PlatformFile file, String name) async {
    Reference reference = FirebaseStorage.instance.ref(file.name);
    UploadTask putData = reference.putData(file.bytes!);

    String downloadURL = "";

    await putData.whenComplete(() async {
      try {
        downloadURL = await reference.getDownloadURL();
      } catch (onError) {
        // ignore: avoid_print
        print("Error2");
      }
    });

    return downloadURL;
  }

  Future deleteFile(String? name) async {
    Reference reference = FirebaseStorage.instance.ref(name);

    await reference.delete();
  }

  void downloadItem(String url, String fileName) async {
    html.AnchorElement anchorElement = html.AnchorElement(href: url);
    anchorElement.download = url;
    anchorElement.click();
  }
}
