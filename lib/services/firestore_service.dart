import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:exentialoils/models/tag.dart';
import 'package:exentialoils/models/favorite.dart';
import 'package:exentialoils/models/report.dart';
import 'package:exentialoils/models/user.dart';
import 'package:exentialoils/models/recipe.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection("users");

  final CollectionReference _recipeCollectionReference =
      Firestore.instance.collection("recipe");

  final CollectionReference _tagsCollectionReference =
      Firestore.instance.collection("tags");

  final CollectionReference _reportCollectionReference =
      Firestore.instance.collection("reports");

  final CollectionReference _favoriteCollectionReference =
      Firestore.instance.collection("favorites");

  final StreamController<List<Recipe>> _recipesController =
      StreamController<List<Recipe>>.broadcast();

  final StreamController<bool> _favoriteController =
      StreamController<bool>.broadcast();

  //* USER methods =============================
  Future createUser(User user) async {
    try {
      await _usersCollectionReference.document(user.id).setData(user.toJson());
    } catch (e) {
      return e.message;
    }
  }

  Future getUser(String uid) async {
    try {
      DocumentSnapshot userData =
          await _usersCollectionReference.document(uid).get();
      return User.fromData(userData.data);
    } catch (e) {
      return e.message;
    }
  }

  //* REPORT methods =============================
  Future submitReport({Report report}) async {
    try {
      await _reportCollectionReference.add(report.toJson());
    } catch (e) {
      return e.message;
    }
  }

  //* FAVORITE methods =============================
  Future addFavorite({Favorite favorite}) async {
    try {
      await _favoriteCollectionReference.add(favorite.toJson());
    } catch (e) {
      return e.message;
    }
  }

  Future removeFavorite({Favorite favorite}) async {
    try {
      await _favoriteCollectionReference
          .where('recipeId', isEqualTo: favorite.recipeId)
          .where('userId', isEqualTo: favorite.userId)
          .getDocuments()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.documents) {
          ds.reference.delete();
        }
      });
    } catch (e) {
      return e.message;
    }
  }

  Stream isFavorite({String recipeId, String userId}) {
    bool isFavorite = false;

    _favoriteCollectionReference
        .where('recipeId', isEqualTo: recipeId)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((favoriteSnapshot) {
      var result = favoriteSnapshot.documents.length;

      if (result > 0) isFavorite = true;

      _favoriteController.add(isFavorite);
    });

    return _favoriteController.stream;
  }

  //* RECIPE methods =============================
  // Future addRecipe({Recipe recipe}) async {
  //   try {
  //     recipe.id = _recipeCollectionReference.document().documentID;
  //     await _recipeCollectionReference
  //         .document(recipe.id)
  //         .setData(recipe.toJson());

  //     await addTagsPerRecipeId(
  //         recipeId: recipe.id, tags: recipe.name + ' ' + recipe.recipe);
  //   } catch (e) {
  //     return e.message;
  //   }
  // }

  Future addRecipe({Recipe recipe}) async {
    try {
      DocumentReference result =
          await _recipeCollectionReference.add(recipe.toJson());
      await addTagsPerRecipeId(
          recipeId: result.documentID, tags: recipe.name + ' ' + recipe.recipe);
    } catch (e) {
      return e.message;
    }
  }

  //not realtime
  Future getTrendingRecipes() async {
    try {
      var recipeDocumentSnapshot = await _recipeCollectionReference
          .orderBy('favoriteCount', descending: true)
          .limit(3)
          .getDocuments();

      if (recipeDocumentSnapshot.documents.isNotEmpty) {
        return recipeDocumentSnapshot.documents
            .map((snapshot) =>
                Recipe.fromData(snapshot.data, snapshot.documentID))
            .where((mappedItem) => mappedItem.name != null)
            .toList();
      }
    } catch (e) {
      return e.message;
    }
  }

  Stream getRecipes() {
    _recipeCollectionReference.snapshots().listen((recipesSnapshop) {
      if (recipesSnapshop.documents.isNotEmpty) {
        var recipes = recipesSnapshop.documents
            .map((snapshot) =>
                Recipe.fromData(snapshot.data, snapshot.documentID))
            .where((mappedItem) => mappedItem.name != null)
            .toList();

        _recipesController.add(recipes);
      }
    });

    return _recipesController.stream;
  }

  Future searchRecipes({@required String keyword}) async {
    try {
      //get recipeId
      List<Tag> tagsList;

      QuerySnapshot tagDocumentSnapshot = await _tagsCollectionReference
          .where('tagName', isEqualTo: keyword.toLowerCase())
          .getDocuments();

      if (tagDocumentSnapshot.documents.isNotEmpty) {
        tagsList = tagDocumentSnapshot.documents
            .map((snapshot) => Tag.fromData(snapshot.data))
            .toList();
      }

      List<String> tagsListResult = tagsList.map((x) => x.recipeId).toList();

      QuerySnapshot recipeDocumentSnapshot = await _recipeCollectionReference
          .where('documentId', whereIn: tagsListResult)
          .getDocuments();

      if (recipeDocumentSnapshot.documents.isNotEmpty) {
        return recipeDocumentSnapshot.documents
            .map((snapshot) =>
                Recipe.fromData(snapshot.data, snapshot.documentID))
            .where((mappedItem) => mappedItem.name != null)
            .toList();
      }
    } catch (e) {
      return e.message;
    }
  }

  Future deleteRecipe(String documentId) async {
    await _recipeCollectionReference.document(documentId).delete();
  }

  Future updateRecipe(Recipe recipe) async {
    try {
      await _recipeCollectionReference
          .document(recipe.documentId)
          .updateData(recipe.toJson());
    } catch (e) {
      return e.message;
    }
  }

  //* TAGS methods =============================
  Future getTagsByRecipe({String recipId}) async {
    var tagItems = List<Tag>();
    QuerySnapshot documents;

    documents = await _tagsCollectionReference
        .where('recipeId', isEqualTo: recipId)
        .getDocuments();

    var hasDocuments = documents.documents.length > 0;

    if (hasDocuments) {
      for (var document in documents.documents) {
        Map<String, dynamic> documentData = document.data;
        documentData['id'] = document.documentID;
        tagItems.add(Tag.fromData(documentData));
      }
    }

    return tagItems;
  }

  Future addTagsPerRecipeId({String recipeId, String tags}) async {
    try {
      tags = tags.replaceAll("\n", " ");
      RegExp exp = new RegExp(r"(\b\w{3,}\b)(?!.*\1)");
      Iterable<RegExpMatch> matches = exp.allMatches(tags);
      var cleanedMatches = matches.toSet().toList();

      cleanedMatches.forEach(
        (match) async {
          var tagName = tags.substring(match.start, match.end).toLowerCase();
          var tagId = _tagsCollectionReference.document().documentID;
          Tag newTag = Tag(recipeId: recipeId, tagName: tagName);
          await _tagsCollectionReference
              .document(tagId)
              .setData(newTag.toJson());
        },
      );
    } catch (e) {
      return e.message;
    }
  }
}
