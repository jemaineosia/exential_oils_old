import 'package:flutter/foundation.dart';

class Recipe {
  String documentId;
  final String name;
  final String recipe;
  final String userId;
  final String imageUrl;
  final int favoriteCount;
  final String displayName;
  final String imageFileName;
  final bool isApproved;
  final bool isPublic;

  Recipe({
    this.documentId,
    @required this.name,
    @required this.recipe,
    @required this.displayName,
    @required this.userId,
    this.imageUrl,
    this.imageFileName,
    this.favoriteCount = 0,
    this.isApproved = false,
    this.isPublic = true,
  });

  static Recipe fromData(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return Recipe(
      documentId: documentId,
      name: map['name'],
      recipe: map['recipe'],
      displayName: map['displayName'],
      userId: map['userId'],
      imageUrl: map['imageUrl'],
      imageFileName: map['imageFileName'],
      favoriteCount: map['favoriteCount'] ?? 0,
      isApproved: map['isApproved'],
      isPublic: map['isPublic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'recipe': recipe,
      'displayName': displayName,
      'userId': userId,
      'imageUrl': imageUrl,
      'imageFileName': imageFileName,
      'favoriteCount': favoriteCount,
      'isApproved': isApproved,
      'isPublic': isPublic,
    };
  }
}
