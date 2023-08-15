import 'dart:developer';
import 'dart:io';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/helpers/storage.dart';
import 'package:just_do_it/models/answers.dart';
import 'package:just_do_it/models/chat.dart';
import 'package:just_do_it/models/countries.dart';
import 'package:just_do_it/models/favourites_info.dart';
import 'package:just_do_it/models/levels.dart';
import 'package:just_do_it/models/like_order.dart';
import 'package:just_do_it/models/like_user.dart';
import 'package:just_do_it/models/notofications.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/models/question.dart';
import 'package:just_do_it/models/review.dart';
import 'package:just_do_it/models/task.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Repository {
  var dio = Dio();

  Future<Owner?> getRanking(int? id, String? access) async {
    final response = await dio.get(
      '$server/ranking/$id',
      options: Options(
        validateStatus: ((status) => status! >= 200),
        headers: {'Authorization': 'Bearer $access'},
      ),
    );
    log(response.data.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Owner.fromJson(response.data);
    }

    return null;
  }

  Future<Reviews?> getRankingReview(int? id, String? access) async {
    final response = await dio.get(
      '$server/ranking/$id',
      options: Options(
        validateStatus: ((status) => status! >= 200),
        headers: {'Authorization': 'Bearer $access'},
      ),
    );
    log(response.data.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Reviews.fromJson(response.data);
    }

    return null;
  }

  Future<bool> deleteTask(Task task, String access) async {
    final res = await dio.delete(
      '$server/orders/${task.id}',
      options: Options(
        validateStatus: ((status) => status! >= 200),
        headers: {'Authorization': 'Bearer $access'},
      ),
    );

    if (res.statusCode == 200 || res.statusCode == 201 || res.statusCode == 204) {
      return true;
    }
    if (res.statusCode == 403) {}
    return false;
  }

  Future<void> deleteProfile(String access) async {
    await dio.delete(
      '$server/profile/',
      options: Options(
        validateStatus: ((status) => status! >= 200),
        headers: {'Authorization': 'Bearer $access'},
      ),
    );
  }

  Future<List<Task>> getMyTaskList(String access, bool asCustomer) async {
    final response = await dio.get(
      '$server/orders/my_orders',
      queryParameters: {'as_customer': asCustomer},
      options: Options(
        validateStatus: ((status) => status! >= 200),
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
        validateStatus: ((status) => status! >= 200),
        headers: {'Authorization': 'Bearer $access'},
      ),
    );

    if (res.statusCode == 200 || res.statusCode == 201 || res.statusCode == 204) {
      return true;
    }
    return false;
  }

  Future<List<NotificationsOnDevice>> getMyNotifications(String? access) async {
    final response = await dio.get(
      '$server/chat/notifications',
      options: Options(
        validateStatus: ((status) => status! >= 200),
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

  Future<List<Task>> getTaskList(
    String? query,
    int? priceFrom,
    int? priceTo,
    String? dateStart,
    String? dateEnd,
    String? access,
    List<int> subcategory,
    List<int> regions,
    List<int> towns,
    List<int> countries,
    bool? customer,
    int? currency,
    bool? passport,
    bool? cv,
  ) async {
    Map<String, dynamic>? queryParameters = {
      if (query != null && query.isNotEmpty) "search": query,
      if (priceTo != null) "price_to": priceTo,
      if (priceFrom != null) "price_from": priceFrom,
      if (dateEnd != null) "date_end": dateEnd,
      if (dateStart != null) "date_start": dateStart,
      if (currency != null) "currency": currency,
      if (passport != null && passport) "doc_info_not_empty": passport,
      if (countries.isNotEmpty) "countries": countries,
      if (towns.isNotEmpty) "towns": towns,
      if (regions.isNotEmpty) "regions": regions,
      if (subcategory.isNotEmpty) "subcategory": subcategory,
      if (cv != null && cv) "has_cv": cv,
      "as_customer": customer,
    };

    final response = await dio.get(
      '$server/orders/',
      queryParameters: queryParameters,
      options: Options(
        validateStatus: ((status) => status! >= 200),
        headers: access != null ? {'Authorization': 'Bearer $access'} : null,
      ),
    );

    List<Task> tasks = [];

    // log(response.data.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      for (var element in response.data) {
        final task = Task.fromJson(element);
        tasks.add(task);
      }
      return tasks;
    }
    return tasks;
  }

  Future<Task?> getTaskById(
    int id,
    String? access,
  ) async {
    final response = await dio.get(
      '$server/orders/$id',
      options: Options(
        validateStatus: ((status) => status! >= 200),
        headers: {'Authorization': 'Bearer $access'},
      ),
    );

    Task? task;

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
        validateStatus: ((status) => status! >= 200),
        headers: {'Authorization': 'Bearer $access'},
      ),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> addReviewsDetail(String? access, int? receiver, String? message, double? mark) async {
    final response = await dio.post(
      '$server/ranking/',
      data: {
        "receiver": receiver,
        "message": message,
        "mark": mark,
      },
      options: Options(
        validateStatus: ((status) => status! >= 200),
        headers: {'Authorization': 'Bearer $access'},
      ),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> sendMessageToSupport(String? access, String? email, String? text, String? title) async {
    final response = await dio.post(
      '$server/support/',
      data: {
        "email": email,
        "text": text,
        "title": title,
      },
      options: Options(
        validateStatus: ((status) => status! >= 200),
        headers: {'Authorization': 'Bearer $access'},
      ),
    );
    log(response.statusMessage.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<Answers?> createAnswer(int id, String? access, int price, String description, String status, bool isGraded) async {
    final response = await dio.post(
      '$server/answers/',
      options: Options(validateStatus: ((status) => status! >= 200), headers: {'Authorization': 'Bearer $access'}),
      data: {
        "order": id,
        "price": price,
        "description": description,
        "status": status,
        "is_graded": isGraded,
      },
    );
    log(id.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Answers.fromJson(response.data);
    }
    return null;
  }

  Future<bool> editTask(String? access, Task task) async {
    Map<String, dynamic> map = task.toJson();
    FormData data = FormData.fromMap(map);

    final response = await dio.put(
      '$server/orders/${task.id}',
      data: data,
      options: Options(
        validateStatus: ((status) => status! >= 200),
        headers: {'Authorization': 'Bearer $access'},
      ),
    );
    log(response.statusCode.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> editTaskPatch(String? access, Task task) async {
    final response = await dio.patch(
      '$server/orders/${task.id}',
      data: {
        'status': task.status,
      },
      options: Options(
        validateStatus: ((status) => status! >= 200),
        headers: {'Authorization': 'Bearer $access'},
      ),
    );
    log(response.statusCode.toString());
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
        validateStatus: ((status) => status! >= 200),
        headers: {'Authorization': 'Bearer $access'},
      ),
    );
    log(rus.toString());
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
    } catch (e) {}
    return null;
  }

  // регистрация профиля
  // auth/ post
  Future<Map<String, dynamic>?> confirmRegister(UserRegModel userRegModel, String token) async {
    Map<String, dynamic> map = userRegModel.toJson();
    FormData data = FormData.fromMap(map);

    final response = await dio.post(
      '$server/auth/',
      data: data,
      options: Options(validateStatus: ((status) => status! >= 200), headers: {
        "fcm_token": token,
      }),
    );

    if (response.statusCode == 201) {
      return null;
    }
    return response.data;
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
      options: Options(validateStatus: ((status) => status! >= 200), headers: {'Authorization': 'Bearer $access'}),
    );
    log('message ${response.statusCode}');
    if (response.statusCode == 200) {
      return UserRegModel.fromJson(response.data);
    } else {
      return null;
    }
  }

  Future<UserRegModel?> updateUserCv(String? access, File? file) async {
    FormData data = FormData.fromMap({
      'CV': file != null
          ? MultipartFile.fromFileSync(
              file.path,
              filename: file.path.split('/').last,
            )
          : 0,
    });

    final map = {'CV': null};

    final response = await dio.patch(
      '$server/profile/',
      data: file != null ? data : map,
      options: Options(validateStatus: ((status) => status! >= 200), headers: {'Authorization': 'Bearer $access'}),
    );
    // log('message ${response.statusCode}');
    if (response.statusCode == 200) {
      return UserRegModel.fromJson(response.data);
    } else {
      return null;
    }
  }

  Future<UserRegModel?> updateUser(String? access, UserRegModel userRegModel) async {
    Map<String, dynamic> map = userRegModel.toJson();
    FormData data = FormData.fromMap(map);

    final response = await dio.patch(
      '$server/profile/',
      data: data,
      options: Options(validateStatus: ((status) => status! >= 200), headers: {'Authorization': 'Bearer $access'}),
    );
    log('updateUser ${response.statusMessage}');
    if (response.statusCode == 200) {
      return UserRegModel.fromJson(response.data);
    } else {
      return null;
    }
  }

  Future<Answers?> updateStatusResponse(String? access, int id, String status) async {
    final response = await dio.patch(
      '$server/answers/$id',
      data: {
        "status": status,
      },
      options: Options(validateStatus: ((status) => status! >= 200), headers: {'Authorization': 'Bearer $access'}),
    );
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      return Answers.fromJson(response.data);
    } else {
      return null;
    }
  }

  // подтвердить регистраци
  Future<String?> confirmCodeRegistration(String phone, String code, int? refCode) async {
    final response = await dio.put(
      '$server/auth/',
      data: {
        "phone_number": phone,
        "code": code,
        "ref_code": refCode,
      },
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
      data: {"code": code, "phone_number": phone, "update_passwd": true, "password": updatePassword},
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

  // подтвердить код в забыли пароль
  Future<List<Activities>> getCategories() async {
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
    return [];
  }

  // get reviews
  Future<Reviews?> getReviews(String? access) async {
    final response = await dio.get(
      '$server/ranking/',
      options: Options(validateStatus: ((status) => status! >= 200), headers: {'Authorization': 'Bearer $access'}),
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
        options: Options(
          validateStatus: ((status) => status! >= 200),
        ),
        data: {
          "phone_number": phone,
          "password": password,
          "fcm_token": token,
        },
      );
      log(response.statusMessage.toString());
      if (response.statusCode == 200) {
        String? accessToken = response.data['access'];
        await Storage().setAccessToken(accessToken);
        return response.data['access'];
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  // profile/ get
  Future<UserRegModel?> getProfile(String access) async {
    final response = await dio.get(
      '$server/profile/',
      options: Options(validateStatus: ((status) => status! >= 200), headers: {'Authorization': 'Bearer $access'}),
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
  Future<String?> confirmCodeReset(
    String phone,
    String code,
  ) async {
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
  Future<bool> editPassword(String password, String access, String token) async {
    final response = await dio.post(
      '$server/auth/reset_password_confirm',
      options: Options(validateStatus: ((status) => status! >= 200), headers: {'Authorization': 'Bearer $access'}),
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
        validateStatus: ((status) => status! >= 200),
        headers: {'Authorization': 'Bearer $access'},
      ),
    );
    log('message');
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
        chatList.add(
          ChatMessage(
            user: element['sender'] == null
                ? ChatUser(id: '-1')
                : ChatUser(id: Sender.fromJson(element['sender']).id.toString()),
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

    if (response.statusCode == 200) {
      List<OrderTask> orderTask = [];
      for (var element in response.data) {
        orderTask.add(OrderTask.fromJson(element));
      }

      return orderTask;
    }
    return [];
  }

  Future<About?> aboutList() async {
    final response = await dio.get(
      '$server/questions/',
      options: Options(
        validateStatus: ((status) => status! >= 200),
      ),
    );

    if (response.statusCode == 200) {
      log(response.data.toString());
      return About.fromJson(response.data);
    }
    return null;
  }

  Future<List<Levels>> levels(String? access) async {
    final response = await dio.get(
      '$server/levels/',
      options: Options(validateStatus: ((status) => status! >= 200), headers: {'Authorization': 'Bearer $access'}),
    );
    if (response.statusCode == 200) {
      return response.data.map<Levels>((article) => Levels.fromJson(article)).toList();
    }
    return [];
  }

  Future<FavouritesOrder?> addLikeOrder(int id, String? access) async {
    final response = await dio.post(
      '$server/orders/like_order',
      options: Options(validateStatus: ((status) => status! >= 200), headers: {'Authorization': 'Bearer $access'}),
      data: {
        "order": id,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return FavouritesOrder.fromJson(response.data);
    }
    return null;
  }

  Future<FavouritesUser?> addLikeUser(int id, String? access) async {
    final response = await dio.post(
      '$server/orders/like_user',
      options: Options(validateStatus: ((status) => status! >= 200), headers: {'Authorization': 'Bearer $access'}),
      data: {
        "user": id,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return FavouritesUser.fromJson(response.data);
    }
    return null;
  }

  Future<String> userOnTop(int id, String? access) async {
    final response = await dio.post(
      '$server/answers/upgrade/$id',
      options: Options(validateStatus: ((status) => status! >= 200), headers: {'Authorization': 'Bearer $access'}),
    );

    if (response.statusCode == 204) {
      return 'Поднятие было сделано';
    }
     if (response.statusCode == 400) {
      return 'Недостаточно баллов';
    }
    return 'Ошибка сервера';
  }

  Future<String> taskOnTop(int id, String? access) async {
    final response = await dio.post(
      '$server/orders/upgrade/$id',
      options: Options(validateStatus: ((status) => status! >= 200), headers: {'Authorization': 'Bearer $access'}),
    );

   if (response.statusCode == 204) {
      return 'Поднятие было сделано';
    }
     if (response.statusCode == 400) {
      return 'Недостаточно баллов';
    }
    return 'Ошибка сервера';
  }

  Future<bool> deleteLikeUser(int id, String access) async {
    final res = await dio.delete(
      '$server/orders/like_user/$id',
      options: Options(
        validateStatus: ((status) => status! >= 200),
        headers: {'Authorization': 'Bearer $access'},
      ),
    );

    if (res.statusCode == 200 || res.statusCode == 201 || res.statusCode == 204) {
      return true;
    }
    return false;
  }

  Future<bool> deleteLikeOrder(int id, String access) async {
    final res = await dio.delete(
      '$server/orders/like_order/$id',
      options: Options(
        validateStatus: ((status) => status! >= 200),
        headers: {'Authorization': 'Bearer $access'},
      ),
    );
    // log(res.toString());
    if (res.statusCode == 200 || res.statusCode == 201 || res.statusCode == 204) {
      return true;
    }
    return false;
  }

  Future<Favourites?> getLikeInfo(String? access) async {
    final response = await dio.get(
      '$server/orders/favorites',
      options: Options(validateStatus: ((status) => status! >= 200), headers: {'Authorization': 'Bearer $access'}),
    );

    if (response.statusCode == 200) {
      // log(response.data.toString());
      return Favourites.fromJson(response.data);
    }
    return null;
  }

  Future<List<Currency>> currency() async {
    final response = await dio.get('$server/orders/currencies',
        options: Options(
          validateStatus: ((status) => status! >= 200),
        ));
    if (response.statusCode == 200) {
      return response.data.map<Currency>((article) => Currency.fromJson(article)).toList();
    }
    return [];
  }

  Future<List<Countries>> countries() async {
    final response = await dio.get(
      '$server/countries/tree',
      options: Options(validateStatus: ((status) => status! >= 200)),
    );
    if (response.statusCode == 200) {
      return response.data.map<Countries>((article) => Countries.fromJson(article)).toList();
    }
    return [];
  }

  Future<List<Regions>> regions(Countries countries) async {
    final response = await dio.get(
      '$server/countries/${countries.id}',
      options: Options(validateStatus: ((status) => status! >= 200)),
    );
    if (response.statusCode == 200) {
      return response.data['regions'].map<Regions>((article) => Regions.fromJson(article)).toList();
    }
    return [];
  }

  Future<List<Town>> towns(Regions regions) async {
    final response = await dio.get(
      '$server/countries/region/${regions.id}',
      options: Options(
        validateStatus: ((status) => status! >= 200),
      ),
    );

    if (response.statusCode == 200) {
      return response.data['towns'].map<Town>((article) => Town.fromJson(article)).toList();
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
    } catch (e) {}

    return null;
  }

  Future<String> getFilePath(uniqueFileName) async {
    String path = '';

    Directory? dir;
    if (Platform.isAndroid) {
      dir = (await getExternalStorageDirectories(type: StorageDirectory.downloads))?.first;
    } else {
      dir = await getApplicationDocumentsDirectory();
    }

    path = '${dir!.path}/$uniqueFileName';

    return path;
  }
}
