import 'package:flutter/material.dart';
import 'package:wechat/my_date_util.dart';

import 'api_firebase.dart';
import 'model_message.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});
final Message message;
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return Api.auth.currentUser!.uid==widget.message.fromId?_greenMessage():_blueMessage();
  }
  Widget _blueMessage(){
    if(widget.message.read.isEmpty){
      Api.updateMessageReadStatus(widget.message);
    }
    var mq=MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width*.04),
            margin: EdgeInsets.symmetric(horizontal: mq.width*.05,vertical: mq.height*.03),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)
              ),
              color: Color(0xFFADC7E0FF),
              border: Border.all(color: Colors.lightBlue)
            ),
          
            child: Text(widget.message.msg,style: TextStyle(fontSize:20,color: Colors.black87),),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right:20),
          child: Text(MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),
            style: TextStyle(color: Colors.black54),),
        )
      ],
    );
  }
  Widget _greenMessage(){
    var mq=MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: mq.width*.03,
            ),
            if(widget.message.read.isNotEmpty)
            Icon(Icons.done_all_outlined,
              color:Colors.blue ,size: 21,),
            SizedBox(
              width: mq.width*.02,
            ),
            Text(MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),
              style: TextStyle(color: Colors.black54),),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width*.04),
            margin: EdgeInsets.symmetric(horizontal: mq.width*.05,vertical: mq.height*.03),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30)
                ),
                color: Colors.lightGreen.shade200,
                border: Border.all(color: Colors.lightGreen)
            ),

            child: Text(widget.message.msg,style: TextStyle(fontSize:20,color: Colors.black87),),
          ),
        ),
      ],
    );
  }
}
