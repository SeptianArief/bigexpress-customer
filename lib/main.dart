import 'dart:io';
import 'package:bigexpress_customer/cubits/cubits.dart';
import 'package:bigexpress_customer/pages/pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sizer/sizer.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> _messageHandler(RemoteMessage message) async {
  final player = AudioPlayer();

  player.setAsset('assets/sound/pristine-609.mp3');
  player.play();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  runApp(MultiBlocProvider(providers: [
    BlocProvider<UserCubit>(
      create: (context) => UserCubit(),
    ),
    BlocProvider<UtilCubit>(
      create: (context) => UtilCubit(),
    ),
    BlocProvider<TopupCubit>(
      create: (context) => TopupCubit(),
    ),
    BlocProvider<OrderFormCubit>(
      create: (context) => OrderFormCubit(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Colors.blue
    ..indicatorColor = Colors.blue
    ..textColor = Colors.white
    ..maskType = EasyLoadingMaskType.black
    ..userInteractions = true
    ..dismissOnTap = false;
}

class _MyAppState extends State<MyApp> {
  late FirebaseMessaging messaging;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  configFCM() {
    Future onDidRecieveLocalNotification(
        int? id, String? title, String? body, String? payload) async {
      // display a dialog with the notification details, tap ok to go to another page

      showDialog(
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
          title: new Text(title!),
          content: new Text(body!),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: new Text('Ok'),
              onPressed: () async {},
            ),
          ],
        ),
      );
    }

    Future onSelectNotification(String? payload) async {
      if (payload != null) {
        print('Payload Notification: $payload');
      }
    }

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidRecieveLocalNotification);

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      print(value);
    });

    Future displayNotification(Map<String, dynamic> message) async {
      var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
          'your channel id', 'your channel name',
          playSound: true,
          groupKey: 'type_a',
          color: Theme.of(context).primaryColor,
          enableVibration: true,
          importance: Importance.max,
          priority: Priority.high);
      var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
      var platformChannelSpecifics = new NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);
      if (Platform.isAndroid) {
        await flutterLocalNotificationsPlugin.show(
          0,
          message['title'],
          message['body'],
          platformChannelSpecifics,
        );
      } else if (Platform.isIOS) {
        await flutterLocalNotificationsPlugin.show(
          0,
          message['aps']['alert']['title'],
          message['aps']['alert']['body'],
          platformChannelSpecifics,
        );
      }
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      displayNotification({
        'title': event.notification!.title,
        'body': event.notification!.body
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {});
  }

  @override
  void initState() {
    configLoading();
    configFCM();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return WithForegroundTask(
          child: MaterialApp(
              title: 'Big Express',
              theme: ThemeData(
                primaryColor: Color(0xFF164690),
                primarySwatch: Colors.blue,
              ),
              builder: EasyLoading.init(),
              home: SplashScreenPage()));
    });
  }
}
