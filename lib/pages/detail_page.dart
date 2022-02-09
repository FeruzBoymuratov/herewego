import 'dart:io';

import 'package:flutter/material.dart';
import 'package:herewego/model/post_model.dart';
import 'package:herewego/services/prefs_service.dart';
import 'package:herewego/services/rtdb_service.dart';
import 'package:herewego/services/store_service.dart';
import 'package:image_picker/image_picker.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key key}) : super(key: key);

  static const String id = "detail_page";

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  var isLoading = false;
  File _image;
  final picker = ImagePicker();

  var fncontroller = TextEditingController();
  var lncontroller = TextEditingController();
  var ctcontroller = TextEditingController();
  var decontroller = TextEditingController();

  _addPost() async {
    String fullname = fncontroller.text.toString();
    String lastname = lncontroller.text.toString();
    String content = ctcontroller.text.toString();
    String date = decontroller.text.toString();

    if (fullname.isEmpty || lastname.isEmpty || content.isEmpty || date.isEmpty) return;
    if(_image == null) return;

    _apiUploadImage(fullname, lastname, content, date);
  }

  void _apiUploadImage(String fullname, String lastname, String content, String date) {
    setState(() {
      isLoading = true;
    });
    StoreService.uploadImage(_image).then((img_url) => {
      _apiAddPost(fullname, lastname, content, date, img_url),
    });
  }
  _apiAddPost(String fullname, String lastname, String content, String date, img_url) async {
    var id = await Prefs.loadUserId();
    RTDBService.addPost(Post(id, fullname, lastname, content, date, img_url)).then((response) => {
      _respAddPost(),
    });
  }
  
  _respAddPost() {
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop({'data': 'done'});
  }

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }else{
        print("Rasm tanlanmagan!");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Add Post"),
      ),
      body: Stack(
          children: [
            SingleChildScrollView(
            child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _getImage,
                  child: Container(
                    width: 100,
                    height: 100,
                    child: _image != null ?
                    Image.file(_image, fit: BoxFit.cover,) :
                    Image.asset("assets/images/ic_camera.png"),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: fncontroller,
                  decoration: const InputDecoration(
                    hintText: "Firstname",
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: lncontroller,
                  decoration: const InputDecoration(
                    hintText: "Lastname",
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: ctcontroller,
                  decoration: const InputDecoration(
                    hintText: "Content",
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: decontroller,
                  decoration: const InputDecoration(
                    hintText: "Date",
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: FlatButton(
                    onPressed: _addPost,
                    color: Colors.deepOrange,
                    child: const Text(
                      "Add",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
        ),
          ),
            isLoading? const Center(
              child: CircularProgressIndicator(),
            ): const SizedBox.shrink(),
        ],
      ),
    );
  }
}
