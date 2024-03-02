import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wechat/api_firebase.dart';
import 'package:wechat/chat_screen.dart';
import 'package:wechat/login_page.dart';
import 'package:wechat/model_chatUser.dart';
import 'package:wechat/model_message.dart';

class ChatUserCard extends StatefulWidget {
  final chatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  Message? _message;
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: mq.width * 0.03, vertical: mq.height * .006),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => chatScreen(
                          user: widget.user,
                        )));
          },
          child: StreamBuilder(
              stream: Api.getLastMessages(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final list =
                    data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
                if (data != null && data.first.exists) {
                  _message = Message.fromJson(data.first.data());
                }
                return ListTile(
                    // leading:
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(mq.height * .03),
                      child: CachedNetworkImage(
                        width: mq.height * .065,
                        height: mq.height * .065,
                        imageUrl: widget.user.image,
                        // placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                      ),
                    ),
                    title: Text(widget.user.name),
                    subtitle: Text(
                      _message != null ? _message!.msg : widget.user.about,
                      maxLines: 1,
                    ),
                    trailing: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                          color: Colors.green.shade400,
                          borderRadius: BorderRadius.circular(10)),
                    )
                    // Text("12:00",style: TextStyle(color: Colors.black26),),
                    );
              })),
    );
  }
}
