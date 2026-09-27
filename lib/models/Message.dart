class Message {
  Message(this.message, this.id, this.userName);

  String message, id, userName;

  factory Message.fromJson(jsonData) {
    return Message(jsonData['message'], jsonData['id'], jsonData['userName']);
  }
}
