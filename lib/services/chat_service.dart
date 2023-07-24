part of 'services.dart';

class ChatService {
  static void endChat(
    DocumentReference<Object?> data,
  ) {
    data.delete();
  }

  static void sendActionText(
    DocumentReference<Object?> data,
    String chatMessage,
    Function() onSuccess,
  ) {
    data.update({
      'messages': FieldValue.arrayUnion([
        {
          'sender': 'client',
          'created_at': DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
          'text': chatMessage
        }
      ])
    }).then((value) {
      onSuccess();
    });

    //send notification

    // GoogleService.sendNotification(
    //     title: user.name + ' Send Message',
    //     notif: chatMessage,
    //     token: receipantToken,
    //     data: {
    //       'id_room': roomId,
    //       'notification_type': 'chat',
    //       'click_action': 'FLUTTER_NOTIFICATION_CLICK'
    //     });
  }

  static Future<void> openChat({
    required User user,
  }) async {
    String? token = await FirebaseMessaging.instance.getToken();

    DocumentReference<Map<String, dynamic>> data =
        FirebaseFirestore.instance.collection('chat').doc(user.id.toString());

    DocumentSnapshot<Map<String, dynamic>> dataRaw = await data.get();
    dynamic dataChat = dataRaw.data();
    if (dataChat == null) {
      DocumentReference ref =
          FirebaseFirestore.instance.collection('chat').doc(user.id.toString());
      ref.set({
        'messages': [
          {
            'sender': 'admin',
            'created_at': DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
            'text': 'Halo ${user.name}, Ada yang bisa kami bantu?'
          }
        ],
        'client_name': user.name,
        'client_token': token
      });
    }
  }
}
