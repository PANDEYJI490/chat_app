import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wechat/api_firebase.dart';
import 'package:wechat/chat_ui_widgets.dart';
import 'package:wechat/login_page.dart';
import 'package:wechat/model_chatUser.dart';
import 'package:wechat/profile_Screen.dart';

import 'helper.dart';

class ProfileScreen extends StatefulWidget {
  final chatUser user;
  const ProfileScreen({super.key, required this.user});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: Text("Profile Page"),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 30, right: 10),
            child: FloatingActionButton.extended(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              backgroundColor: Colors.redAccent,
              onPressed: () async {
                Dialogs.showProgressbar(context);
                await FirebaseAuth.instance.signOut().then((value) async {
                  await GoogleSignIn().signOut().then((value) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => LoginPage()));
                  });
                });
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              label: Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: mq.width,
                      height: mq.height * .03,
                    ),
                    Stack(
                      children: [
                        _image !=null ? ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .1),
                child:Image.file(
                  File(_image!),
                  width: mq.height * .2,
                  height: mq.height * .2,
                  fit: BoxFit.cover,
                ),
              ):
                        ClipRRect(
                          borderRadius: BorderRadius.circular(mq.height * .1),
                          child: CachedNetworkImage(
                            width: mq.height * .2,
                            height: mq.height * .2,
                            fit: BoxFit.cover,
                            imageUrl: widget.user.image,
                            // placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) => CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: mq.height * 0,
                          right: mq.width * 0,
                          child: MaterialButton(
                            elevation: 1,
                            shape: CircleBorder(),
                            color: Colors.white,
                            onPressed: () {
                              _showBottomSheet();
                            },
                            child: Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: mq.width,
                      height: mq.height * .03,
                    ),
                    Text(
                      widget.user.email,
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                    SizedBox(
                      width: mq.width,
                      height: mq.height * .03,
                    ),
                    TextFormField(
                      onSaved: (val) => Api.me.name = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required field',
                      initialValue: widget.user.name,
                      decoration: InputDecoration(
                          hintText: "Enter Your Nick Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          prefixIcon: Icon(Icons.person)),
                    ),
                    SizedBox(
                      width: mq.width,
                      height: mq.height * .03,
                    ),
                    TextFormField(
                      onSaved: (val) => Api.me.about = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required field',
                      initialValue: widget.user.about,
                      decoration: InputDecoration(
                          hintText: "Write something about yourself",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          prefixIcon: Icon(Icons.info_outline)),
                    ),
                    SizedBox(
                      width: mq.width,
                      height: mq.height * .03,
                    ),
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: Size(mq.width * .5, mq.height * .06)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            Api.updateUserInfo().then((value) {
                              return Dialogs.showSnackbar(
                                  context, 'Profile Updated Successfully');
                            });
                          }
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 25,
                        ),
                        label: Text(
                          "Update",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ))
                  ],
                ),
              ),
            ),
          )),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(41), topRight: Radius.circular(41)),
        ),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.04,
              bottom:MediaQuery.of(context).size.height*0.09    ),
            children: [
              Center(
                  child: Text(
                "Pick Profile Picture",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
              )),
              Padding(
                padding: const EdgeInsets.only(top: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(source: ImageSource.camera,imageQuality: 80);
                        if(image != null){
                          setState(() {
                            _image= image.path;
                          });
                          Api.updateProfilePicture(File(_image!));
                          Navigator.pop(context);
                        }
                      }, child: Image.asset("assets/images/camera.png",width: 60,height: 60,),),
                    ElevatedButton(onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(source: ImageSource.gallery,imageQuality: 80);
                      if(image != null){
                        setState(() {
                          _image= image.path;
                        });
                        Api.updateProfilePicture(File(_image!));
                        Navigator.pop(context);
                      }

                    }, child: Image.asset("assets/images/picture.png",width: 50,height: 50,)),
                  ],
                ),
              )
            ],
          );
        });
  }
}
