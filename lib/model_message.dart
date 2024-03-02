class Message {
  Message({
    required this.fromId,
    required this.msg,
    required this.read,
    required this.sent,
    required this.toId,
    required this.type,
  });
  late final String fromId;
  late final String msg;
  late final String read;
  late final String sent;
  late final String toId;
  late final Type type;

  Message.fromJson(Map<String, dynamic> json){
    fromId = json['fromId'].toString();
    msg = json['msg'].toString();
    read = json['read'].toString();
    sent = json['sent'].toString();
    toId = json['toId'].toString();
    type = json['type'].toString()==Type.image.name?Type.image:Type.text;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['fromId'] = fromId;
    _data['msg'] = msg;
    _data['read'] = read;
    _data['sent'] = sent;
    _data['toId'] = toId;
    _data['type'] = type.name;
    print("line34");
    print(type.name);
    return _data;
  }
}
enum Type{text,image}