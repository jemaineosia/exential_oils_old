import 'package:flutter/foundation.dart';

class Favorite {
  final String recipeId;
  final String userId;

  Favorite({@required this.recipeId, @required this.userId});

  Favorite.fromData(Map<String, dynamic> data)
      : recipeId = data['recipeId'],
        userId = data['userId'];

  Map<String, dynamic> toJson() {
    return {
      'recipeId': recipeId,
      'userId': userId,
    };
  }
}
