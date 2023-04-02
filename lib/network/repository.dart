import 'dart:developer';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:dio/dio.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/helpers/storage.dart';
import 'package:just_do_it/models/chat.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/models/review.dart';
import 'package:just_do_it/models/user_reg.dart';

class Repository {
  var dio = Dio();

  // регистрация профиля
  // auth/ post
  Future<Map<String, dynamic>?> confirmRegister(
      UserRegModel userRegModel) async {
    Map<String, dynamic> map = userRegModel.toJson();
    FormData data = FormData.fromMap(map);

    final response = await dio.post(
      '$server/auth/',
      data: data,
      options: Options(
        validateStatus: ((status) => status! >= 200),
      ),
    );

    if (response.statusCode == 201) {
      return null;
    }
    return response.data;
  }

  // auth/ put
  Future<bool> updateUser(String? access, UserRegModel userRegModel) async {
    Map<String, dynamic> map = userRegModel.toJson();
    FormData data = FormData.fromMap(map);

    final response = await dio.patch(
      '$server/profile/',
      data: data,
      options: Options(
          validateStatus: ((status) => status! >= 200),
          headers: {'Authorization': 'Bearer $access'}),
    );

    print('updating user data ${response.data}');
    print('updating user data ${response.statusCode}');
    return response.statusCode == 200;
    // return response.data;
  }

  // подтвердить регистраци
  Future<String?> confirmCodeRegistration(String phone, String code) async {
    final response = await dio.put(
      '$server/auth/',
      data: {"phone_number": phone, "code": code},
      options: Options(
        validateStatus: ((status) => status! >= 200),
      ),
    );

    if (response.statusCode == 200) {
      String? accessToken = response.data['access'];
      await Storage().setAccessToken(accessToken);
      return response.data['access'];
    }
    return null;
  }

  // забыли пароль, сбросить код
  Future<bool> resetPassword(String login) async {
    final response = await dio.post(
      '$server/auth/reset_password',
      data: {"phone_number": login},
      options: Options(
        validateStatus: ((status) => status! >= 200),
      ),
    );

    print('object ${response.data}');

    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }

  // подтвердить код в забыли пароль
  Future<String?> confirmRestorePassword(
    String code,
    String phone,
    String updatePassword,
  ) async {
    final response = await dio.put(
      '$server/auth/',
      data: {
        "code": code,
        "phone_number": phone,
        "update_passwd": true,
        "password": updatePassword
      },
      options: Options(
        validateStatus: ((status) => status! >= 200),
      ),
    );

    print('object ${response.data}');

    if (response.statusCode == 200) {
      String? accessToken = response.data['access'];
      await Storage().setAccessToken(accessToken);
      return response.data['access'];
    }
    return null;
  }

  // подтвердить код в забыли пароль
  Future<List<Activities>?> getCategories() async {
    final response = await dio.get(
      '$server/auth/categories',
      options: Options(
        validateStatus: ((status) => status! >= 200),
      ),
    );

    if (response.statusCode == 200) {
      List<Activities> list = [];
      for (var element in response.data) {
        list.add(Activities.fromJson(element));
      }
      return list;
    }
    return null;
  }

  // get reviews
  Future<Reviews?> getReviews(String? access) async {
    final response = await dio.get(
      '$server/ranking/',
      options: Options(
          validateStatus: ((status) => status! >= 200),
          headers: {'Authorization': 'Bearer $access'}),
    );

    if (response.statusCode == 200) {
      Reviews reviews = Reviews.fromJson(response.data);
      return reviews;
    }
    return null;
  }

  // вход
  Future<String?> signIn(String phone, String password) async {
    final response = await dio.post(
      '$server/auth/api/token/',
      options: Options(
        validateStatus: ((status) => status! >= 200),
      ),
      data: {
        "phone_number": phone,
        "password": password,
      },
    );
    if (response.statusCode == 200) {
      String? accessToken = response.data['access'];
      await Storage().setAccessToken(accessToken);
      return response.data['access'];
    }
    return null;
  }

  // profile/ get
  Future<UserRegModel?> getProfile(String access) async {
    print('object token= $access');
    final response = await dio.get(
      '$server/profile/',
      options: Options(
          validateStatus: ((status) => status! >= 200),
          headers: {'Authorization': 'Bearer $access'}),
    );

    if (response.statusCode == 200) {
      final user = UserRegModel.fromJson(response.data);
      return user;
    }
    return null;
  }

  // проверка на зарегистрированного пользователя
  Future<String?> checkUserExist(String phone, String email) async {
    final response = await dio.post(
      '$server/auth/check',
      options: Options(
        validateStatus: ((status) => status! >= 200),
      ),
      data: {
        "phone_number": phone,
        "email": email,
      },
    );

    if (response.statusCode == 200) {
      return null;
    }
    return '';
  }

  // подтвердить код изменения пароля
  Future<String?> confirmCodeReset(String phone, String code) async {
    final response = await dio.put(
      '$server/auth/',
      options: Options(
        validateStatus: ((status) => status! >= 200),
      ),
      data: {
        "phone_number": phone,
        "code": code,
        "update_passwd": true,
      },
    );

    if (response.statusCode == 200) {
      String? accessToken = response.data['access'];
      await Storage().setAccessToken(accessToken);
      return response.data['access'];
    }
    return null;
  }

  // новый пароль
  Future<bool> editPassword(String password, String access) async {
    final response = await dio.post(
      '$server/auth/reset_password_confirm',
      options: Options(
          validateStatus: ((status) => status! >= 200),
          headers: {'Authorization': 'Bearer $access'}),
      data: {
        "password": password,
      },
    );

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  // сообщения пользователей
  Future<List<ChatList>> getListMessage(String access) async {
    final response = await dio.get(
      '$server/chat/',
      options: Options(
        validateStatus: ((status) => status! >= 200),
        headers: {'Authorization': 'Bearer $access'},
      ),
    );

    if (response.statusCode == 200) {
      List<ChatList> chatList = [];
      for (var element in response.data) {
        chatList.add(ChatList.fromJson(element));
      }
      return chatList;
    }
    return [];
  }

  // личные сообщения
  Future<List<ChatMessage>> getListMessageItem(String access, String id) async {
    final response = await dio.get(
      '$server/chat/$id',
      options: Options(
        validateStatus: ((status) => status! >= 200),
        headers: {'Authorization': 'Bearer $access'},
      ),
    );

    if (response.statusCode == 200) {
      List<ChatMessage> chatList = [];
      for (var element in response.data['messages_list']) {
        log('message list ${element}');
        chatList.add(
          ChatMessage(
            user:
                ChatUser(id: Sender.fromJson(element['sender']).id.toString()),
            createdAt: DateTime.parse(element['time']),
            text: element['text'],
          ),
        );
      }

      return chatList;
    }
    return [];
  }

  Future<List<OrderTask>> getListTasks(String access) async {
    final response = await dio.get(
      '$server/orders/',
      options: Options(
        validateStatus: ((status) => status! >= 200),
        headers: {'Authorization': 'Bearer $access'},
      ),
    );

    log('message ${response.data}');

    if (response.statusCode == 200) {
      List<OrderTask> orderTask = [];
      for (var element in response.data) {
        orderTask.add(OrderTask.fromJson(element));
      }

      return orderTask;
    }
    return [];
  }

  Future<bool> createTask(
      String access, String name, String description) async {
    Map<String, String> data = {
      "name": name,
      "description": description,
    };
    final response = await dio.post(
      '$server/orders/',
      options: Options(
        validateStatus: ((status) => status! >= 200),
        headers: {'Authorization': 'Bearer $access'},
      ),
      data: data,
    );

    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }
}
