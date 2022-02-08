import 'package:flutter/material.dart';
import 'package:herewego/model/post_model.dart';
import 'package:herewego/pages/detail_page.dart';
import 'package:herewego/services/auth_service.dart';
import 'package:herewego/services/prefs_service.dart';
import 'package:herewego/services/rtdb_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  static final String id = "home_page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var isLoading = false;
  List<Post> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiGetPosts();
  }

  Future _openDetail() async{
    Map results = await Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext){
          return new DetailPage();
    }));
    if(results != null && results.containsKey("data")){
      print(results['data']);
      _apiGetPosts();
    }
  }

  _apiGetPosts() async{
    setState(() {
      isLoading = true;
    });
    var id = await Prefs.loadUserId();
    RTDBService.getPosts(id).then((posts) => {
      _respPosts(posts),
    });
  }

  _respPosts(List<Post> posts) {
    setState(() {
      isLoading = false;
      items = posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("All Posts"),
        actions: [
          IconButton(
            onPressed: (){
            AuthService.signOutUser(context);
          },
            icon: Icon(Icons.exit_to_app, color: Colors.white,),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: items.length,
              itemBuilder: (ctx, i){
                return itemOfList(items[i]);
              },
          ),
          isLoading?
              Center(
                child: CircularProgressIndicator(),
              ):SizedBox.shrink(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openDetail,
        child: Icon(Icons.add),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }

  Widget itemOfList(Post post){
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(post.lastname, style: TextStyle(fontSize: 20),),
              SizedBox(width: 5,),
              Text(post.fullname, style: TextStyle(fontSize: 20),),
            ],
          ),
          SizedBox(height: 10,),
          Text(post.content, style: TextStyle(fontSize: 15),),
          SizedBox(height: 10,),
          Text(post.date, style: TextStyle(fontSize: 15),),
        ],
      ),
    );
  }
}
