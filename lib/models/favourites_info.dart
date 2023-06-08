import 'package:just_do_it/models/countries.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/models/user_reg.dart';

class Favourites {
  List<FavoriteCustomers>? favoriteUsers;

  List<FavouriteOffers>? favouriteOffers;
  List<FavouriteOffers>? favouriteOrder;

  Favourites({
    this.favoriteUsers = const [],
    this.favouriteOffers = const [],
    this.favouriteOrder = const [],
  
  });

  factory Favourites.fromJson(Map<String, dynamic> json) {
    List<FavoriteCustomers> favoriteUsers = [];
    if (json['favorite_users'] != null) {
      for (var element in json['favorite_users']) {
        favoriteUsers.add(FavoriteCustomers.fromJson(element));
      }
    }
    List<FavouriteOffers> favouriteOffers = [];
    if (json['favorite_offers'] != null) {
      for (var element in json['favorite_offers']) {
        favouriteOffers.add(FavouriteOffers.fromJson(element));
      }
    }
    List<FavouriteOffers> favouriteOrders = [];
    if (json['favorite_orders'] != null) {
      for (var element in json['favorite_orders']) {
        favouriteOrders.add(FavouriteOffers.fromJson(element));
      }
    }
  
    return Favourites(
      favoriteUsers: favoriteUsers,
      favouriteOffers: favouriteOffers,
      favouriteOrder: favouriteOrders,
     
    );
  }
}

class FavouriteOffers {
  int? id;
  Order? order;

  FavouriteOffers({
    required this.id,
    required this.order,
  });

  factory FavouriteOffers.fromJson(Map<String, dynamic> json) {
    return FavouriteOffers(
      id: json['id'],
      order: Order.fromJson(json['order']),
    );
  }
}

class FavoriteCustomers {
  int? id;
  User? user;

  FavoriteCustomers({
    required this.id,
    required this.user,
  });

  factory FavoriteCustomers.fromJson(Map<String, dynamic> json) {
    return FavoriteCustomers(
      id: json['id'],
      user: User.fromJson(json['user']),
    );
  }
}

class Order {
  int? isLiked;
  int? id;
  OwnerOrder? owner;
  String? name;
  int? chatId;
  String? description;
  String? dateStart;
  String? dateEnd;
  Category? category;
  Currency? currency;
  int? priceFrom;
  int? priceTo;
  List<Countries>? countries;
  List<Regions>? regions;
  List<Town>? towns;
  bool? asCustomer;
  List<ArrayImages>? files;
  SubCategory? subcategory;

  Order({
    this.id,
    this.chatId,
    this.name,
    this.description,
    this.owner,
    this.category,
    required this.priceFrom,
    required this.priceTo,
    this.asCustomer,
    required this.dateStart,
    required this.dateEnd,
    this.regions = const [],
    this.towns = const [],
    this.countries = const [],
    this.files,
    this.isLiked,
    this.subcategory,
    this.currency,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    List<Regions> regions = [];
    if (json['regions'] != null) {
      for (var element in json['regions']) {
        regions.add(Regions.fromJson(element));
      }
    }
    List<Countries> countries = [];
    if (json['countries'] != null) {
      for (var element in json['countries']) {
        countries.add(Countries.fromJson(element));
      }
    }

    List<Town> towns = [];
    if (json['towns'] != null) {
      for (var element in json['towns']) {
        towns.add(Town.fromJson(element));
      }
    }

    List<ArrayImages> files = [];
    if (json['files'] != null) {
      for (var element in json['files']) {
        files.add(ArrayImages(element['file'], null, id: element['id']));
      }
    }
    return Order(
      id: json['id'],
      name: json['name'],
      chatId: json['chat_id'],
      description: json['description'],
      owner: OwnerOrder.fromJson(json['owner']),
      category: Category.fromJson(json['category']),
      asCustomer: json['as_customer'],
      dateEnd: json['date_end'],
      dateStart: json['date_start'],
      priceFrom: json['price_from'],
      priceTo: json['price_to'],
      isLiked: json['is_liked'],
      countries: countries,
      regions: regions,
      files: files,
      towns: towns,
      subcategory: SubCategory.fromJson(json["subcategory"]),
      currency: Currency.fromJson(json['currency']),
    );
  }
}

class SubCategory {
  int? id;
  String? description;

  SubCategory({
    required this.id,
    required this.description,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'],
      description: json['description'],
    );
  }
}

class Category {
  int? id;
  String? description;
  String? photo;
  Category({
    required this.id,
    required this.description,
    required this.photo,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      description: json['description'],
      photo: json['photo'],
    );
  }
}

class OwnerOrder {
  int? id;
  String? firstname;
  String? lastname;
  String? photo;

  OwnerOrder({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.photo,
  });

  factory OwnerOrder.fromJson(Map<String, dynamic> json) {
    return OwnerOrder(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      photo: json['photo'],
    );
  }
}

class User {
  int? id;
  String? firstname;
  String? lastname;
  String? photo;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.photo,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      photo: json['photo'],
    );
  }
}
