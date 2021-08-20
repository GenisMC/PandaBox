import 'package:codepandas/components/Drawer/drawer.dart';
import 'package:codepandas/Services/provider.dart';
import 'package:codepandas/Extensions/device_check.dart';
import 'package:codepandas/widgets/appbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
// ignore_for_file: import_of_legacy_library_into_null_safe

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String fileName = "";
  FilePickerResult? result;
  TextEditingController itemNameController = TextEditingController();
  bool visible = true;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderService>(context);

    double size = 200;
    bool hideText = false;

    if (context.isPhone) {
      hideText = true;
    } else if (context.isTablet) {
      hideText = true;
    } else if (context.isDesktop) {
      hideText = false;
    } else if (context.isHiRes) {
      hideText = false;
    }

    @override
    // ignore: unused_element
    void dispose() {
      itemNameController.dispose();
      super.dispose();
    }

    Future pickFile() async {
      result = await provider.storage.pickFile();

      setState(() {
        showFileName(result!.files.first.name);
      });
    }

    Future uploadItem() async {
      if (result != null) {
        showLoadingIndicator();

        String displayName =
            itemNameController.text == "" ? fileName : itemNameController.text;

        //Upload file returns url
        String url =
            await provider.storage.uploadFile(result!.files.first, displayName);

        //Save reference to file in FireDatabase
        await provider.db.setFileReference(url, result!.files.first.name,
            displayName, provider.authService.auth.currentUser!.uid, visible);
        eraseEnteredValues();
        hideOpenDialog();
        Fluttertoast.showToast(
          msg: "Upload successful!",
        );
      } else {
        Fluttertoast.showToast(
            msg: "Pick a File!", backgroundColor: Colors.redAccent);
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xff3b3b3b),
      appBar: const CustomAppBar(),
      drawer: const DrawerMain(),
      body: Center(
        child: Card(
          color: const Color(0xff171717),
          child: SizedBox(
            width: size * 3,
            height: size * 3.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: size,
                  height: 55,
                  child: TextField(
                      controller: itemNameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: "Leave empty for default",
                        hintStyle: TextStyle(fontSize: 14),
                        fillColor: Color(0xff383838),
                        focusColor: Color(0xff525252),
                        hoverColor: Color(0xff525252),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xff383838), width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xff383838), width: 0.0),
                        ),
                        labelStyle: TextStyle(color: Color(0xffffffff)),
                        labelText: 'File Name',
                      )),
                ),
                SizedBox(
                  height: 200,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    direction: Axis.vertical,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await pickFile();
                        },
                        child: const Text("Pick File"),
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all(Size(size, 55)),
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xff383838)),
                        ),
                      ),
                      SizedBox(
                        width: size,
                        child: Text(
                          fileName,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            await uploadItem();
                          },
                          child: const Text("Upload"),
                          style: ButtonStyle(
                            fixedSize:
                                MaterialStateProperty.all(Size(size * 1.2, 60)),
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xffDA0037)),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CheckboxListTile(
                            dense: true,
                            tileColor: const Color(0xff383838),
                            title: hideText
                                ? const Icon(
                                    Icons.visibility,
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Public?",
                                    style: TextStyle(color: Colors.white),
                                  ),
                            value: visible,
                            onChanged: (bool? newValue) {
                              setState(() {
                                visible = newValue!;
                              });
                            }),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          elevation: 2,
        ),
      ),
    );
  }

  void showLoadingIndicator([String? text]) {
    showDialog(
      useSafeArea: true,
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              backgroundColor: Colors.black87,
              contentPadding: const EdgeInsets.all(200),
              content: LoadingIndicator(
                indicatorType: Indicator.ballTrianglePath,
              ),
            ));
      },
    );
  }

  void hideOpenDialog() {
    Navigator.of(context).pop();
  }

  void showFileName(String name) {
    fileName = name;
  }

  void eraseEnteredValues() {
    fileName = "";
    itemNameController.clear();
    result = null;
  }
}
