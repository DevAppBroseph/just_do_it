import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:developer';
import 'dart:io';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/core/utils/toasts.dart';
import 'package:just_do_it/feature/auth/bloc/auth_bloc.dart';
import 'package:just_do_it/feature/auth/data/register_confirmation_method.dart';
import 'package:just_do_it/helpers/storage.dart';
import 'package:just_do_it/models/answer.dart';
import 'package:just_do_it/models/chat.dart';
import 'package:just_do_it/models/countries.dart';
import 'package:just_do_it/models/favourites_info.dart';
import 'package:just_do_it/models/levels.dart';
import 'package:just_do_it/models/like_user.dart';
import 'package:just_do_it/models/notofications.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/models/question.dart';
import 'package:just_do_it/models/review.dart';
import 'package:just_do_it/models/task/task.dart';
import 'package:just_do_it/models/task/task_category.dart';
import 'package:just_do_it/models/task/task_status.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/services/dio/dio_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Repository {
  final Dio _dio = Dio();

  Future<List<OrderTask>> getListTasks(String access, {int page = 1}) async {
    final response = await _dio.get(
      '$server/orders/?page=$page',
      options: Options(
        headers: {'Authorization': 'Bearer $access'},
      ),
    );

    if (response.statusCode == 200) {
      List<OrderTask> orderTask = [];
      for (var element in response.data['results']) {
        orderTask.add(OrderTask.fromJson(element));
      }
      return orderTask;
    }
    return [];
  }

  Future<bool> sendConfirmationCode(String method, String value) async {
    try {
      final response = await _dio.post(
        '$server/send_code_for_confirmation/',
        data: method == 'phone'
            ? {"confirmation_method": "phone", "phone": value}
            : {"confirmation_method": "email", "email": value},
      );
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioError {
      return false;
    }
  }

  Future<Map<String, dynamic>?> appleSignIn(
    String email,
    String firstname,
    String lastname,
  ) async {
    try {
      final response = await _dio.post(
        'http://app.jobyfine.me/social-auth/apple-signin/',
        data: {
          'email': email,
          'firstname': firstname,
          'lastname': lastname,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      log('Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> googleSignIn(String idToken) async {
    try {
      final response = await _dio.post(
        'http://95.142.45.4/social-auth/google-signin/',
        data: {'id_token': idToken},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      log('Error: $e');
      return null;
    }
  }

  // регистрация профиля
  // auth/ post
  Future<Map<String, dynamic>?> confirmRegister(
    UserRegModel userRegModel,
    String token,
    RegisterConfirmationMethod registerConfirmationMethod,
  ) async {
    Map<String, dynamic> map = userRegModel.toJson();
    FormData data = FormData.fromMap(
      map
        ..addAll({
          "fcm_token": token,
          'confirmation_method': registerConfirmationMethod.name
        }),
    );
    // print(map);
    // print(token);
    // print(registerConfirmationMethod);

    // return {'error': 'error'};

    final response = await dio.post(
      '$server/auth/',
      data: data,
    );
    if (response.statusCode == 201) {
      return null;
    }
    return response.data;
  }

  Future<String?> sendCodeForConfirmation({
    required String confirmMethod,
    required String value,
    required String valueKey,
  }) async {
    try {
      final response = await dio.post(
        '$server/auth/send_code_for_confirmation/',
        data: {
          'confirmation_method': confirmMethod,
          valueKey: value,
        },
      );
      if (response.statusCode == 200 &&
          response.data?['sent_code_server'] != null) {
        return response.data['sent_code_server'].toString();
      }
      return null;
    } on DioError catch (e) {
      log(e.toString());
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<String?> register(
      ConfirmCodeEvent confirmCodeEvent, int? refCode) async {
    Map<String, dynamic> map = confirmCodeEvent.userRegModel.toJson();

    FormData data = FormData.fromMap(
      map
        ..addAll({
          'sent_code_server': confirmCodeEvent.sendCodeServer,
          'confirmation_code_user': confirmCodeEvent.confirmationCodeUser,
          "fcm_token": confirmCodeEvent.fcmToken,
          "ref_code": refCode,
          // 'confirmation_method': registerConfirmationMethod.name
        }),
    );

    final response = await dio.post(
      '$server/auth/',
      data: data,
    );
    if (response.statusCode == 201) {
      // String? accessToken = response.data['access_token'];
      // final refreshToken = response.data['refresh_token'];
      String? accessToken = response.data['token']?['access'];
      final refreshToken = response.data['token']?['refresh'];
      await Storage().setAccessToken(accessToken);
      await Storage().setRefreshToken(refreshToken);
      return accessToken;
    }
    return null;
  }

  // подтвердить регистраци
  Future<String?> confirmCodeRegistration(
      String phone, String code, int? refCode) async {
    final response = await dio.put('$server/auth/', data: {
      "phone_number": phone,
      "code": code,
      "ref_code": refCode,
    });
    if (response.statusCode == 200) {
      String? accessToken = response.data['access'];
      final refreshToken = response.data['refresh'];
      await Storage().setAccessToken(accessToken);
      await Storage().setRefreshToken(refreshToken);
      return response.data['access'];
    }
    return null;
  }

  // забыли пароль, сбросить код
  Future<bool> resetPassword({
    required String codeType,
    required String value,
  }) async {
    final response = await dio.post(
      '$server/auth/reset_password',
      data: {
        "phone_number": value,
        "code_type": codeType,
      },
      options: Options(),
    );

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
    );

    if (response.statusCode == 200) {
      String? accessToken = response.data['access'];
      final refreshToken = response.data['refresh'];
      await Storage().setAccessToken(accessToken);
      await Storage().setRefreshToken(refreshToken);
      return response.data['access'];
    }
    return null;
  }

  // подтвердить код в забыли пароль
  Future<List<TaskCategory>> getCategories() async {
    final response = await dio.get(
      '$server/auth/categories',
      options: Options(),
    );

    if (response.statusCode == 200) {
      List<TaskCategory> list = [];
      for (var element in response.data) {
        list.add(TaskCategory.fromJson(element));
      }
      return list;
    }
    return [];
  }

  Future<Owner?> getRanking(int? id, String? access) async {
    final response = await dio.get(
      '$server/ranking/$id',
      options: Options(
        headers: {'Authorization': 'Bearer $access'},
      ),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Owner.fromJson(response.data);
    }
    return null;
  }

  Future<Reviews?> getRankingReview(int? id, String? access) async {
    final response = await dio.get(
      '$server/ranking/$id',
      options: Options(
        headers: {'Authorization': 'Bearer $access'},
      ),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Reviews.fromJson(response.data);
    }

    return null;
  }

  Future<bool> deleteTask(Task task, String access) async {
    final res = await dio.delete(
      '$server/orders/${task.id}',
      options: Options(
        headers: {'Authorization': 'Bearer $access'},
      ),
    );

    if (res.statusCode == 200 ||
        res.statusCode == 201 ||
        res.statusCode == 204) {
      return true;
    }
    if (res.statusCode == 403) {}
    return false;
  }

  Future<void> deleteProfile(String access) async {
    await dio.delete(
      '$server/profile/',
      options: Options(
        headers: {'Authorization': 'Bearer $access'},
      ),
    );
  }

  Future<List<Task>> getMyTaskList(String access, bool asCustomer) async {
    final response = await dio.get(
      '$server/orders/my_orders/',
      queryParameters: {'as_customer': asCustomer},
      options: Options(
        headers: {'Authorization': 'Bearer $access'},
      ),
    );
    List<Task> tasks = [];

    if (response.statusCode == 201 || response.statusCode == 200) {
      for (var element in response.data) {
        tasks.add(Task.fromJson(element));
      }

      return tasks;
    }
    return tasks;
  }

  Future<bool> deleteNotifications(String? access) async {
    final res = await dio.delete(
      '$server/chat/notifications',
      options: Options(
        headers: {'Authorization': 'Bearer $access'},
      ),
    );

    if (res.statusCode == 200 ||
        res.statusCode == 201 ||
        res.statusCode == 204) {
      return true;
    }
    return false;
  }

  Future<List<NotificationsOnDevice>> getMyNotifications(String? access) async {
    final response = await dio.get(
      '$server/chat/notifications',
      options: Options(
        headers: {'Authorization': 'Bearer $access'},
      ),
    );

    List<NotificationsOnDevice> notifications = [];

    if (response.statusCode == 201 || response.statusCode == 200) {
      for (var element in response.data) {
        notifications.add(NotificationsOnDevice.fromJson(element));
      }
      return notifications;
    }
    return notifications;
  }

  Future<Task?> getTaskById(
    int id,
    String? access,
  ) async {
    final response = await dio.get(
      '$server/orders/$id',
      options: Options(
        headers: {'Authorization': 'Bearer $access'},
      ),
    );
    Task? task;
    log("GetTaskById ${response.statusCode} and ${response.data}");
    if (response.statusCode == 201 || response.statusCode == 200) {
      task = Task.fromJson(response.data);
      return task;
    }

    return null;
  }

  Future<bool> createTask(String access, Task task) async {
    Map<String, dynamic> map = task.toJson();
    FormData data = FormData.fromMap(map);
    final response = await dio.post(
      '$server/orders/',
      data: data,
      options: Options(
        headers: {'Authorization': 'Bearer $access'},
      ),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> addReviewsDetail(String? access, int? receiver, String? message,
      double? mark, int? taskId) async {
    final response = await dio.post(
      '$server/ranking/',
      data: {
        "task_id": taskId,
        "receiver": receiver,
        "message": message,
        "mark": mark,
      },
      options: Options(
        headers: {'Authorization': 'Bearer $access'},
      ),
    );
    log("addReviewsDetail ${response.statusCode} and ${response.data}");
    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400 &&
        response.data["non_field_errors"] != null) {
      CustomAlert().showMessage('you_have_already_left_a_review'.tr());
    } else {
      CustomAlert().showMessage('error'.tr());
    }
    return false;
  }

  Future<bool> sendMessageToSupport(
      String? access, String? email, String? text, String? title) async {
    final response = await dio.post(
      '$server/support/',
      data: {
        "email": email,
        "text": text,
        "title": title,
      },
      options: Options(
        headers: {'Authorization': 'Bearer $access'},
      ),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> createAnswer(int id, String? access, int price,
      String description, String status, bool isGraded) async {
    final response = await dio.post(
      '$server/answers/',
      options: Options(headers: {'Authorization': 'Bearer $access'}),
      data: {
        "order": id,
        "price": price,
        "description": description,
        "status": status,
        "is_graded": isGraded,
      },
    );
    log(jsonEncode({
      "order": id,
      "price": price,
      "description": description,
      "status": status,
      "is_graded": isGraded,
    }));
    log("createAnswer ${response.statusCode} and ${response.data}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }
    return false;
  }

  Future<bool> editTask(String? access, Task task) async {
    Map<String, dynamic> map = task.toJson();
    FormData data = FormData.fromMap(map);
    final response = await dio.put(
      '$server/orders/${task.id}',
      data: data,
      options: Options(
        headers: {'Authorization': 'Bearer $access'},
      ),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> editTaskPatch(
    String? access,
    Task task,
  ) async {
    final response = await dio.patch(
      '$server/orders/${task.id}',
      data: {
        'status': task.status.getStatusDescription,
      },
      options: Options(
        headers: {'Authorization': 'Bearer $access'},
      ),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<UserRegModel?> editRusProfile(String? access, bool rus) async {
    final response = await dio.patch(
      '$server/profile/',
      data: {
        'rus': rus,
      },
      options: Options(
        headers: {'Authorization': 'Bearer $access'},
      ),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return UserRegModel.fromJson(response.data);
    } else {
      return null;
    }
  }

  Future<Uint8List?> downloadFile(String url) async {
    try {
      final response = await dio.get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );
      return response.data;
    } catch (e, stacktrace) {
      developer.log('Error downloading file: $e', stackTrace: stacktrace);
    }
    return null;
  }

  // auth/ put
  Future<UserRegModel?> updateUserPhoto(String? access, XFile? photo) async {
    FormData data = FormData.fromMap({
      'photo': photo != null
          ? MultipartFile.fromFileSync(
              photo.path,
              filename: photo.path.split('/').last,
            )
          : 0,
    });

    final map = {
      'photo': null,
    };
    final response = await dio.patch(
      '$server/profile/',
      data: photo != null ? data : map,
      options: Options(headers: {'Authorization': 'Bearer $access'}),
    );
    if (response.statusCode == 200) {
      return UserRegModel.fromJson(response.data);
    } else {
      return null;
    }
  }

  Future<UserRegModel?> updateUserCv(
      String? access, File? file, List<String>? images) async {
    FormData data = FormData.fromMap({
      'CV': file != null
          ? MultipartFile.fromFileSync(
              file.path,
              filename: file.path.split('/').last,
            )
          : 0,
    });

    final map = {'CV': null, "images": images};
    final response = await dio.patch(
      '$server/profile/',
      data: file != null ? data : map,
      options: Options(headers: {'Authorization': 'Bearer $access'}),
    );

    log("UpdateProfileCvEvent ${response.statusCode} and ${response.data}");
    if (response.statusCode == 200) {
      return UserRegModel.fromJson(response.data);
    } else {
      return null;
    }
  }

  Future<bool> sendForVerification(String? access, int userId) async {
    final response = await dio.get(
      '$server/auth/send_to_verification/$userId/',
      options: Options(headers: {'Authorization': 'Bearer $access'}),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      CustomAlert().showMessage("error".tr());
      return false;
    }
  }

  Future<UserRegModel?> updateUser(
      String? access, UserRegModel userRegModel) async {
    Map<String, dynamic> map = userRegModel.toJson();
    FormData data = FormData.fromMap(map);
    final response = await dio.patch(
      '$server/profile/',
      data: data,
      options: Options(headers: {'Authorization': 'Bearer $access'}),
    );
    if (response.statusCode == 200) {
      return UserRegModel.fromJson(response.data);
    } else if (response.statusCode == 400 &&
        response.data["phone_number"] != null) {
      CustomAlert()
          .showMessage('a_user_with_such_a_phone_is_already_registered'.tr());
      return null;
    } else {
      return null;
    }
  }

  Future<Answer?> updateStatusResponse(
      String? access, int id, String status) async {
    final response = await dio.patch(
      '$server/answers/$id',
      data: {
        "status": status,
      },
      options: Options(headers: {'Authorization': 'Bearer $access'}),
    );
    if (response.statusCode == 200) {
      return Answer.fromJson(response.data);
    } else {
      return null;
    }
  }

  // get reviews
  Future<Reviews?> getReviews(String? access) async {
    final response = await dio.get(
      '$server/ranking/',
      options: Options(headers: {'Authorization': 'Bearer $access'}),
    );

    if (response.statusCode == 200) {
      Reviews reviews = Reviews.fromJson(response.data);
      return reviews;
    }
    return null;
  }

  // вход
  Future<String?> signIn(String phone, String password, String token) async {
    try {
      final response = await dio.post(
        '$server/auth/api/token/',
        options: Options(),
        data: {
          "phone_number": phone,
          "password": password,
          "fcm_token": token,
        },
      );
      if (response.statusCode == 200) {
        String? accessToken = response.data['access'];
        final refreshToken = response.data['refresh'];
        await Storage().setAccessToken(accessToken);
        await Storage().setRefreshToken(refreshToken);
        return response.data['access'];
      }
    } catch (e, stacktrace) {
      developer.log('Error downloading file: $e', stackTrace: stacktrace);
    }
    return null;
  }

  // profile/ get
  Future<UserRegModel?> getProfile(String access) async {
    final response = await dio.get(
      '$server/profile/',
      options: Options(headers: {'Authorization': 'Bearer $access'}),
    );
    log("GET PROFILE error is ${response.statusCode} and ${response.data}");
    if (response.statusCode == 200) {
      final user = UserRegModel.fromJson(response.data);
      log("User InProgress count: ${user.countOrdersInProgressAsCustomer}");
      // final testUser=user..myAnswersAsExecutor=user.myAnswersAsExecutor!.map((e) => e..isBanned=true..banReason="Inappropriate behaviour.").toList()..ordersCreateAsCustomer=user.ordersCreateAsCustomer!.map((e) => e..isBanned=true..banReason="Inappropriate behaviour.").toList();
      return user;
    }
    return null;
  }

  // проверка на зарегистрированного пользователя
  Future<String?> checkUserExist(String phone, String email) async {
    log("checkUserExist");
    final response = await dio.post(
      '$server/auth/check',
      options: Options(),
      data: {
        "phone_number": phone,
        "email": email,
      },
    );
    log("checkUserExist ${response.data}");

    if (response.statusCode == 200) {
      return null;
    }
    return '';
  }

  // подтвердить код изменения пароля
  Future<String?> confirmCodeReset(
    String phone,
    String code,
  ) async {
    final response = await dio.put(
      '$server/auth/',
      options: Options(),
      data: {
        "phone_number": phone,
        "code": code,
        "update_passwd": true,
      },
    );

    if (response.statusCode == 200) {
      String? accessToken = response.data['access'];
      final refreshToken = response.data['refresh'];
      await Storage().setAccessToken(accessToken);
      await Storage().setRefreshToken(refreshToken);
      return response.data['access'];
    }
    return null;
  }

  // новый пароль
  Future<bool> editPassword(
      String password, String access, String token) async {
    final response = await dio.post(
      '$server/auth/reset_password_confirm',
      options: Options(headers: {'Authorization': 'Bearer $access'}),
      data: {
        "password": password,
        "fcm_token": token,
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
        headers: {'Authorization': 'Bearer $access'},
      ),
    );
    log("getListMessage ${response.data}");
    if (response.statusCode == 200) {
      List<ChatList> chatList = [];
      for (var element in response.data) {
        try {
          chatList.add(ChatList.fromJson(element));
        } catch (_) {}
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
        headers: {'Authorization': 'Bearer $access'},
      ),
    );
    // print("getListMessageItem ${response.statusCode}, chat id is $id");
    if (response.statusCode == 200) {
      log("getListMessageItem $id status is ${response.statusCode} and data is ${response.data}");
      List<ChatMessage> chatList = [];
      for (var element in response.data['messages_list']) {
        chatList.add(
          ChatMessage(
            user: element['sender'] == null
                ? ChatUser(id: '-1')
                : ChatUser(
                    id: Sender.fromJson(element['sender']).id.toString()),
            createdAt: DateTime.parse(element['time']),
            text: element['text'],
          ),
        );
      }

      return chatList;
    }
    return [];
  }

  Future<About?> aboutList() async {
    final response = await dio.get(
      '$server/questions/',
      options: Options(),
    );

    if (response.statusCode == 200) {
      return About.fromJson(response.data);
    }
    return null;
  }

  Future<List<Levels>> levels(String? access) async {
    final response = await dio.get(
      '$server/levels/',
      options: Options(headers: {'Authorization': 'Bearer $access'}),
    );
    if (response.statusCode == 200) {
      return response.data
          .map<Levels>((article) => Levels.fromJson(article))
          .toList();
    }
    return [];
  }

  Future<bool> addLikeOrder(int id, String? access) async {
    final response = await dio.post(
      '$server/orders/like_order',
      options: Options(headers: {'Authorization': 'Bearer $access'}),
      data: {
        "order": id,
      },
    );
    log("Payload: ${jsonEncode({
          "order": id,
        })}");
    log("ORDER like ${response.statusCode} and ${response.data}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }
    return false;
  }

  Future<FavouritesUser?> addLikeUser(int id, String? access) async {
    final response = await dio.post(
      '$server/orders/like_user',
      options: Options(headers: {'Authorization': 'Bearer $access'}),
      data: {
        "user": id,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return FavouritesUser.fromJson(response.data);
    }
    return null;
  }

  Future<bool> deleteResponse(String? access, int id) async {
    final response = await dio.delete(
      '$server/answers/$id',
      options: Options(headers: {'Authorization': 'Bearer $access'}),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> resendTaskForModeration(String? access, int id) async {
    final response = await dio.post(
      '$server/orders/$id/resend_for_verification',
      options: Options(headers: {'Authorization': 'Bearer $access'}),
    );
    log("resendTaskForModeration ${response.statusCode} and ${response.data}");
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool?> isEnoughUserOnTop(String? access) async {
    final response = await dio.get(
      '$server/answers/is_enough',
      options: Options(headers: {'Authorization': 'Bearer $access'}),
    );

    if (response.statusCode == 200) {
      return response.data;
    }
    return null;
  }

  Future<bool?> isEnoughOrdersOnTop(String? access) async {
    final response = await dio.get(
      '$server/answers/is_enough',
      options: Options(headers: {'Authorization': 'Bearer $access'}),
    );
    if (response.statusCode == 200) {
      return response.data;
    }
    return null;
  }

  Future<bool> deleteLikeUser(int id, String access) async {
    final res = await dio.delete(
      '$server/orders/like_user/$id',
      options: Options(
        headers: {'Authorization': 'Bearer $access'},
      ),
    );

    if (res.statusCode == 200 ||
        res.statusCode == 201 ||
        res.statusCode == 204) {
      return true;
    }
    return false;
  }

  Future<bool> deleteLikeOrder(int id, String access) async {
    final res = await dio.delete(
      '$server/orders/like_order/$id',
      options: Options(
        headers: {'Authorization': 'Bearer $access'},
      ),
    );
    log("ORDER delete ${res.statusCode} and ${res.data}");
    if (res.statusCode == 200 ||
        res.statusCode == 201 ||
        res.statusCode == 204) {
      return true;
    }
    return false;
  }

  Future<Favourites?> getLikeInfo(String? access) async {
    final response = await dio.get(
      '$server/orders/favorites',
      options: Options(headers: {'Authorization': 'Bearer $access'}),
    );
    log("GetLikeInfo  ${response.statusCode} and ${response.data}");
    if (response.statusCode == 200) {
      // log(response.data.toString());
      return Favourites.fromJson(response.data);
    }
    return null;
  }

  Future<List<Currency>> currency() async {
    final response =
        await dio.get('$server/orders/currencies', options: Options());
    if (response.statusCode == 200) {
      return response.data
          .map<Currency>((article) => Currency.fromJson(article))
          .toList();
    }
    return [];
  }

  Future<List<Countries>> countries() async {
    final response = await dio.get(
      '$server/countries/tree',
      options: Options(),
    );
    if (response.statusCode == 200) {
      return response.data
          .map<Countries>((article) => Countries.fromJson(article))
          .toList();
    }
    return [];
  }

  Future<List<Regions>> regions(Countries countries) async {
    final response = await dio.get(
      '$server/countries/${countries.id}',
      options: Options(),
    );
    if (response.statusCode == 200) {
      return response.data['regions']
          .map<Regions>((article) => Regions.fromJson(article))
          .toList();
    }
    return [];
  }

  Future<List<Town>> towns(Regions regions) async {
    final response = await dio.get(
      '$server/countries/region/${regions.id}',
      options: Options(),
    );

    if (response.statusCode == 200) {
      return response.data['towns']
          .map<Town>((article) => Town.fromJson(article))
          .toList();
    }
    return [];
  }

  Future<String?> getFile(String file) async {
    try {
      String savePath = await getFilePath('${DateTime.now()}.docx');
      final response = await dio.get(
        '$server$file',
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );
      // log(response.data.toString());
      if (response.statusCode == 200) {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.storage,
        ].request();

        if (statuses[Permission.storage]!.isGranted) {
          File file = File(savePath);
          var raf = file.openSync(mode: FileMode.write);
          raf.writeFromSync(response.data);
          await raf.close();
        }
        return savePath;
      }
    } catch (e, stacktrace) {
      developer.log('Error downloading file: $e', stackTrace: stacktrace);
    }

    return null;
  }

  Future<String> getFilePath(uniqueFileName) async {
    String path = '';

    Directory? dir;
    if (Platform.isAndroid) {
      dir = (await getExternalStorageDirectories(
              type: StorageDirectory.downloads))
          ?.first;
    } else {
      dir = await getApplicationDocumentsDirectory();
    }

    path = '${dir!.path}/$uniqueFileName';

    return path;
  }
}
