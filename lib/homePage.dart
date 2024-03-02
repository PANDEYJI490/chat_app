
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wechat/api_firebase.dart';
import 'package:wechat/chat_ui_widgets.dart';
import 'package:wechat/model_chatUser.dart';
import 'package:wechat/profile_Screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
   @override
  State<HomePage> createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {
  List<chatUser> _list=[];
  final List<chatUser>_searchList=[];
  bool _isSearching =false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Api.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:()=> FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if(_isSearching){
            setState(() {
              _isSearching=!_isSearching;
            });
            return Future.value(false);
          }else{
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightBlue.shade50,
            leading: Icon(CupertinoIcons.home),
            actions: [
              IconButton(onPressed: (){
                setState(() {
                  _isSearching=!_isSearching;
                });
              }, icon: Icon(_isSearching?CupertinoIcons.clear_circled_solid:Icons.search)),
              IconButton(onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (_)=>ProfileScreen(user: Api.me,)));
              }, icon: Icon(Icons.more_vert))
            ],
            title:_isSearching?TextField(decoration: InputDecoration(
              border: InputBorder.none,hintText: "Search Name...."),
              onChanged: (val){
              _searchList.clear();
            for(var i in _list){
              if(i.name.toLowerCase().contains(val.toLowerCase())){
                _searchList.add(i);
              }
              setState(() {
                _searchList;
              });
            }
        
              },
              autofocus: true,):
            Text("We Chat"),
        
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 30,right: 10),
            child: FloatingActionButton(
              onPressed: ()async{
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();
              },child: Icon(Icons.add_comment_rounded),
            ),
          ),
          backgroundColor: Colors.lightBlue.shade50,
          body: StreamBuilder(
          stream: Api.getAllUser(),
            builder: (context ,snapshot){
              switch(snapshot.connectionState){
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Center(child: CircularProgressIndicator(),);
                case ConnectionState.active:
                case ConnectionState.done:
                  final data= snapshot.data?.docs ;
                  _list=data?.map((e) =>chatUser.fromJson(e.data())).toList()??[];
                if( _list.isNotEmpty){
        
                  return ListView.builder(itemCount:_isSearching? _searchList.length:_list.length,itemBuilder: (context,index){
                    return ChatUserCard(user:_isSearching? _searchList[index]:_list[index]);
                  });
                }else{
                  return Center(child: Text("No connections found!",style: TextStyle(color: Colors.red,fontSize: 30),));
                }
              }
        
            },
          ),
        ),
      ),
    );
  }
}
