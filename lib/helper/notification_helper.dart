
import 'package:chatapp/models/userModel.dart';
import 'package:chatapp/provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';

class NotificationsHelper {
  // creat instance of fbm
  final _firebaseMessaging = FirebaseMessaging.instance;

  // initialize notifications for this app or device
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    // get device token
    String? deviceToken = await _firebaseMessaging.getToken();
    print(
        "===================Device FirebaseMessaging Token====================");
    print(deviceToken);
    print(
        "===================Device FirebaseMessaging Token====================");
  }

  // handle notifications when received
  // void handleMessages(RemoteMessage? message) {
  //   if (message != null) {
  //     // navigatorKey.currentState?.pushNamed(NotificationsScreen.routeName, arguments: message);
  //     showToast(
  //         text: 'on Background Message notification',
  //         state: ToastStates.SUCCESS);
  //   }
  // }

  // handel notifications in case app is terminated
  // void handleBackgroundNotifications() async {
  //   FirebaseMessaging.instance.getInitialMessage().then((handleMessages));
  //   FirebaseMessaging.onMessageOpenedApp.listen(handleMessages);
  // }

  Future<String?> getAccessToken() async {

    final serviceAccountJson = {
      "type": dotenv.env["TYPE"],
      "project_id": dotenv.env["PROJECT_ID"],
      "private_key_id": dotenv.env["PRIVATE_KEY_ID"],
      "private_key":dotenv.env["PRIVATE_KEY"],
      "client_email": dotenv.env["CLIENT_EMAIL"],
      "client_id": dotenv.env["CLIENT_ID"],
      "auth_uri": dotenv.env["AUTH_URI"],
      "token_uri": dotenv.env["TOKEN_URI"],
      "auth_provider_x509_cert_url":dotenv.env["AUTH_PROVIDER"],
      "client_x509_cert_url":dotenv.env["CLIENT_URL"],
      "universe_domain":dotenv.env["UNIVERSE_DOMAIN"]
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    try {
      http.Client client = await auth.clientViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson
            (serviceAccountJson), scopes);

      auth.AccessCredentials credentials =
      await auth.obtainAccessCredentialsViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
          scopes,
          client);

      client.close();
      print(
          "Access Token: ${credentials.accessToken.data}"); // Print Access Token
      return credentials.accessToken.data;
    } catch (e) {
      print("Error getting access token: $e");
      return null;
    }
  }

  Map<String, dynamic> getBody({
    required String fcmToken,
    required String title,
    required String body,
    required String userId,
    String? type,
  }) {
    return {
      "message": {
        "token": fcmToken,
        "notification": {"title": title, "body": body},
        "android": {
          "notification": {
            "notification_priority": "PRIORITY_MAX",
            "sound": "default"
          }
        },
        "apns": {
          "payload": {
            "aps": {"content_available": true}
          }
        },
        "data": {
          "type": type,
          "id": userId,
          "click_action": "FLUTTER_NOTIFICATION_CLICK"
        }
      }
    };
  }

  Future<void> sendNotifications({
    // required String fcmToken,
    required ChatUser chatUser,
    required BuildContext context,
    required String msg,
    required String userId,
    String? groupName,
    String? type,
  }) async {
    try {
      var serverKeyAuthorization = await getAccessToken();
// change your project id
    const String urlEndPoint =
    "https://fcm.googleapis.com/v1/projects/chatapp-339d8/messages:send";

    Dio dio = Dio();
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $serverKeyAuthorization';

    var response = await dio.post(
    urlEndPoint,
    data: getBody(
    userId: userId,
    fcmToken: chatUser.puchToken!,
    title:groupName == null?
    Provider.of<ProviderApp>(context , listen: false).me!.name!
        : groupName+" : "+"${ Provider.of<ProviderApp>(context , listen: false).me!.name!}",
    body: msg,
    type: type ?? "message",
    ),
    );

    // Print response status code and body for debugging
    print('Response Status Code: ${response.statusCode}');
    print('Response Data: ${response.data}');
    } catch (e) {
    print("Error sending notification: $e");
    }
  }
}
//yaraaaaab