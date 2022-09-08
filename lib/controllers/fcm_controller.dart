import 'dart:convert';

import 'package:http/http.dart' as http;

sendNotificationCall(String token, String? title, String body) async {
  http.Response response = await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAA70iwLjk:APA91bFbvOV00scK_AVzSuMVVttTgrtbrCCAome0-ZqU-YVPqv0Hh5PEKH_E0qX6M8DDtcZdI-AdNPMTd_18ewHDEnyDiR-r5hfcncLAZvv7wH_De4zFdaR_rCG0LTcJb2FX8k5VzMb_',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{'body': body, 'title': title},
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done',
        },
        'to': token
      },
    ),
  );
  if (response.statusCode == 200) {
    print('status code 200');
    print(response.body);
  } else {
    print(response.toString());
  }
}
