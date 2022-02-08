import 'package:flutter/material.dart';
import 'package:herewego/model/post_model.dart';
import 'package:herewego/services/prefs_service.dart';
import 'package:herewego/services/rtdb_service.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key key}) : super(key: key);

  static const String id = "detail_page";

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  var isLoading = false;
  //File _image;

  var fncontroller = TextEditingController();
  var lncontroller = TextEditingController();
  var ctcontroller = TextEditingController();
  var decontroller = TextEditingController();

  _addPost() async {
    String fullname = fncontroller.text.toString();
    String lastname = lncontroller.text.toString();
    String content = ctcontroller.text.toString();
    String date = decontroller.text.toString();

    var id = await Prefs.loadUserId();
      RTDBService.addPost(Post(id, fullname, lastname, content, date)).then((response) => {
        _respAddPost(),
      });

    if (fullname.isEmpty || lastname.isEmpty || content.isEmpty || date.isEmpty) return;
  }

  // _apiAddPost(String fullname, String lastname, String content, String date) async {
  //   var id = await Prefs.loadUserId();
  //   RTDBService.addPost(Post(id, fullname, lastname, content, date)).then((response) => {
  //     _respAddPost(),
  //   });
  // }
  
  _respAddPost() {
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop({'data': 'done'});
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
