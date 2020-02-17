import 'package:flutter/foundation.dart';

class Tag {
  String id;
  final String recipeId;
  final String tagName;

  Tag({this.id, @required this.recipeId, @required this.tagName});

  Tag.fromData(Map<String, dynamic> data)
      : id = data['id'],
        recipeId = data['recipeId'],
        tagName = data['tagName'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipeId': recipeId,
      'tagName': tagName,
    };
  }
}
