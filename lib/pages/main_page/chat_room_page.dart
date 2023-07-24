part of '../pages.dart';

class ChatRoomPage extends StatefulWidget {
  final DocumentSnapshot<Object?>? dataChat;
  const ChatRoomPage({Key? key, required this.dataChat}) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = widget.dataChat!.data() as Map<String, dynamic>;
    List<dynamic> dataChat = data['messages'];
    List<dynamic> dataFinal = dataChat.reversed.toList();
    return SafeArea(child: _buildContent(dataFinal));
  }

  Widget _buildContent(List<dynamic> dataChat) {
    return Column(children: [
      Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 5.0.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                ColorPallette.baseBlue,
                Color(0xFFBAC8DE),
              ],
            ),
          ),
          child: Center(
              child: Text(
            'Pusat Bantuan',
            style: FontTheme.boldBaseFont.copyWith(
                fontSize: 13.0.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ))),
      Container(
        padding: EdgeInsets.symmetric(vertical: 3.0.w, horizontal: 5.0.w),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black12))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Masalah sudah selesai?',
                style: FontTheme.regularBaseFont
                    .copyWith(fontSize: 10.0.sp, color: Colors.black54)),
            GestureDetector(
              onTap: () {
                yesOrNoDialog(context,
                        title: 'Akhiri Bantuan?',
                        desc: 'Apakah Anda Yakin untuk mengakhiri bantuan?')
                    .then((value) {
                  if (value) {
                    UserState userState =
                        BlocProvider.of<UserCubit>(context).state;
                    if (userState is UserLogged) {
                      DocumentReference<Object?> ref = FirebaseFirestore
                          .instance
                          .collection("chat")
                          .doc(userState.user.id.toString());

                      ChatService.endChat(ref);
                    }
                  }
                });
              },
              child: Text('Akhiri Bantuan',
                  style: FontTheme.boldBaseFont
                      .copyWith(fontSize: 11.0.sp, color: Colors.red)),
            )
          ],
        ),
      ),
      Expanded(
          child: ListView(
        reverse: true,
        children: List.generate(dataChat.length, (index) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 2.0.w),
            margin: EdgeInsets.only(bottom: 2.0.w),
            alignment: dataChat[index]['sender'] == 'admin'
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              constraints: BoxConstraints(maxWidth: 60.0.w, minWidth: 0),
              padding: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 3.0.w),
              decoration: BoxDecoration(
                  color: dataChat[index]['sender'] == 'admin'
                      ? ColorPallette.baseBlue
                      : Colors.green,
                  borderRadius: dataChat[index]['sender'] == 'admin'
                      ? BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))
                      : BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
              child: Column(
                crossAxisAlignment: dataChat[index]['sender'] == 'admin'
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  Text(dataChat[index]['text'],
                      style: FontTheme.regularBaseFont
                          .copyWith(fontSize: 10.0.sp, color: Colors.white)),
                  SizedBox(height: 1.0.w),
                  Text(
                      dateToReadable(
                              dataChat[index]['created_at'].substring(0, 10)) +
                          ' ' +
                          dataChat[index]['created_at'].substring(11, 16),
                      style: FontTheme.regularBaseFont
                          .copyWith(fontSize: 7.0.sp, color: Colors.white)),
                ],
              ),
            ),
          );
        }),
      )),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 2.0.w),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.black26))),
        child: Row(
          children: [
            Expanded(
                child: InputField(
              borderType: 'border',
              hintText: 'Tulis Pesan..',
              controller: controller,
              onChanged: (vlaue) {},
            )),
            SizedBox(width: 3.0.w),
            GestureDetector(
              onTap: () {
                UserState userState = BlocProvider.of<UserCubit>(context).state;
                if (userState is UserLogged) {
                  if (controller.text.isEmpty) {
                    showSnackbar(context,
                        title: 'Mohon Isi Pesan Anda',
                        customColor: Colors.orange);
                  } else {
                    DocumentReference<Object?> ref = FirebaseFirestore.instance
                        .collection("chat")
                        .doc(userState.user.id.toString());

                    ChatService.sendActionText(
                      ref,
                      controller.text,
                      () {
                        controller.clear();
                        showSnackbar(context,
                            title: 'Berhasil Mengirim Pesan',
                            customColor: Colors.green);
                      },
                    );
                  }
                }
              },
              child: Icon(
                Icons.send,
              ),
            )
          ],
        ),
      )
    ]);
  }
}
