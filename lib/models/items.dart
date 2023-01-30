import 'package:cloud_firestore/cloud_firestore.dart';

class Items {
  String? menuId;
  String? sellerUID;
  String? itemID;
  String? title;
  String? shortInfo;
  Timestamp? publishedDate;
  String? thumbnailUrl;
  String? longDescription;
  String? status;
  double? price;

  Items({
    this.menuId,
    this.sellerUID,
    this.itemID,
    this.title,
    this.shortInfo,
    this.publishedDate,
    this.thumbnailUrl,
    this.longDescription,
    this.status,
    this.price,
  });

  Items.fromJson(Map<String, dynamic> json) {
    menuId = json['menuId'];
    itemID = json['itemId'];
    sellerUID = json['sellerUID'];
    title = json['title'];
    shortInfo = json['shortInfo'];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    longDescription = json['description'];
    status = json['status'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['menuId'] = menuId;
    data['sellerUID'] = sellerUID;
    data['itemId'] = itemID;
    data['title'] = title;
    data['shortInfo'] = shortInfo;
    data['price'] = price;
    data['publishedData'] = publishedDate;
    data['thumbnailUrl'] = thumbnailUrl;
    data['description'] = longDescription;
    data['status'] = status;

    return data;
  }
}
