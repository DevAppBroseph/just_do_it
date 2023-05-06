import 'dart:developer';
import 'dart:io';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/helpers/storage.dart';
import 'package:just_do_it/models/chat.dart';
import 'package:just_do_it/models/countries.dart';
import 'package:just_do_it/models/levels.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/models/question.dart';
import 'package:just_do_it/models/review.dart';
import 'package:just_do_it/models/task.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Repository {
  var dio = Dio();

  Future<Owner?> getRanking(String access, Owner owner) async {
    final response = await dio.get(
      '$server/ranking/${owner.id}',
      options: Options(
        validateStatus: ((status) => status! >= 200),
        headers: {'Authorization': 'Bearer $access'},
      ),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      log('message ${response.data}');
      return Owner.fromJson(response.data);
    }
    return null;
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

  Future<List<Task>> getTaskList(
    String? access,
    String? query,
    int? priceFrom,
    int? priceTo,
    String? dateStart,
    String? dateEnd,
    List<int> subcategory,
    List<int> regions,
    List<int> towns,
    List<int> countries,
    bool? customer,
    int? currency,
  ) async {
    Map<String, dynamic>? queryParameters = {
      if (query != null && query.isNotEmpty) "search": query,
      if (priceTo != null) "price_to": priceTo,
      if (priceFrom != null) "price_from": priceFrom,
      if (dateEnd != null) "date_end": dateEnd,
      if (dateStart != null) "date_start": dateStart,
      if (currency != null) "currency": currency,
      if (countries.isNotEmpty) "countries": countries,
      if (towns.isNotEmpty) "towns": towns,
      if (regions.isNotEmpty) "regions": regions,
      if (subcategory.isNotEmpty) "subcategory": subcategory,
      "as_customer": customer,
    };

    log('message params\n$queryParameters');
    final response = await dio.get(
      '$server/orders/',
      queryParameters: queryParameters,
      options: Options(
        validateStatus: ((status) => status! >= 200),
        // headers: {'Authorization': 'Bearer $access'},
      ),
    );

    List<Task> tasks = [];

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
  ) async {
    final response = await dio.get(
      '$server/orders/$id',
      options: Options(
        validateStatus: ((status) => status! >= 200),
        // headers: {'Authorization': 'Bearer $access'},
      ),
    );

    Task? task;
    log(response.data.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      task = Task.fromJson(response.data);
      return task;
    }
    return null;
  }

  Future<bool> createTask(String access, Task task) async {
    log(task.toString());
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
    log(response.data.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> editTask(String access, Task task) async {
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

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    }
    return false;
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
  Future<Map<String, dynamic>?> confirmRegister(UserRegModel userRegModel) async {
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

    if (response.statusCode == 200) {
      return UserRegModel.fromJson(response.data);
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
  Future<String?> signIn(String phone, String password) async {
    try {
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
    } catch (e) {
      log('message $e');
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
    log('message ${response.data}');

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
  Future<bool> editPassword(String password, String access) async {
    final response = await dio.post(
      '$server/auth/reset_password_confirm',
      options: Options(validateStatus: ((status) => status! >= 200), headers: {'Authorization': 'Bearer $access'}),
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
      '$server/countries/',
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

  Future<List<Regions>> allRegions(String? access, List<Countries> countries) async {
    List<Regions> regions = [];
    for (var element in countries) {
      final response = await dio.get(
        '$server/countries/${element.id}',
        options: Options(validateStatus: ((status) => status! >= 200), headers: {'Authorization': 'Bearer $access'}),
      );
      if (response.statusCode == 200) {
        regions += response.data['regions'].map<Regions>((article) => Regions.fromJson(article)).toList();
      }
    }
    return regions;
  }

  Future<List<Town>> allTowns(String? access, List<Regions> regions) async {
    List<Town> towns = [];
    for (var element in regions) {
      final response = await dio.get(
        '$server/countries/region/${element.id}',
        options: Options(validateStatus: ((status) => status! >= 200), headers: {'Authorization': 'Bearer $access'}),
      );
      if (response.statusCode == 200) {
        towns += response.data['towns'].map<Town>((article) => Town.fromJson(article)).toList();
      }
    }
    return towns;
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
      String savePath = await getFilePath('${DateTime.now()}.doc');
      final response = await dio.get(
        '$server$file',
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );

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
