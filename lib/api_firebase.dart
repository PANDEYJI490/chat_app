import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wechat/model_chatUser.dart';

import 'model_message.dart';

class Api {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static FirebaseStorage storage = FirebaseStorage.instance;

  static late chatUser me;

  static Future<bool> userExists() async {
    return (await firestore.collection('User').doc(auth.currentUser!.uid).get())
        .exists;
  }

  static Future<void> getSelfInfo() async {
    await firestore
        .collection('User')
        .doc(auth.currentUser!.uid)
        .get()
        .then((user) async => {
              if (user.exists)
                {me = chatUser.fromJson(user.data()!)}
              else
                {await createUser().then((value) => getSelfInfo())}
            });
  }

  static Future<void> createUser() async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();
    final ChatUser = chatUser(
        about: "Hey,I'm using We Chat!",
        createdAt: time,
        email: auth.currentUser!.email.toString(),
        id: auth.currentUser!.uid,
        image: auth.currentUser!.photoURL.toString(),
        isOnline: false,
        name: auth.currentUser!.displayName.toString(),
        lastActive: time,
        pushToken: '');
    return await firestore
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(ChatUser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
    return firestore
        .collection('User')
        .where('id', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  static Future<void> updateUserInfo() async {
    await firestore
        .collection('User')
        .doc(auth.currentUser!.uid)
        .update({'name': me.name, 'about': me.about});
  }

  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split('.').last;
    final ref =
        storage.ref().child("Profile_pictures/${auth.currentUser!.uid}.$ext");
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {});

    me.image = await ref.getDownloadURL();
    await firestore
        .collection('User')
        .doc(auth.currentUser!.uid)
        .update({'image': me.image});
  }

  //   Chat Screen related Code



  static String getConversationID(String id)=>auth.currentUser!.uid.hashCode<=id.hashCode
      ?'${auth.currentUser!.uid}_$id'
      : '${id}_${auth.currentUser!.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(chatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/').snapshots();
  }
  static Future<void> sendMessage(chatUser ChatUser, String msg) async {

    print(msg); // Print the message to ensure it's not empty or null.
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Message message = Message(
      fromId: auth.currentUser!.uid,
      msg: msg,
      read: '',
      sent: time,
      toId: ChatUser.id,
      type:Type.text,
    );

       final ref = firestore.collection('chats/${getConversationID(ChatUser.id)}/messages/');
       await ref.doc(time).set(message.toJson());
  }
  static Future<void> updateMessageReadStatus(Message message)async{
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/').doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});

  }
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(chatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .limit(1)
        .snapshots();
  }

}
