import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../data/models/exercise_model.dart';

/// Service for managing favorite exercises locally
class FavoriteExerciseService {
  static const String _favoritesKey = 'favorite_exercises';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Get all favorite exercises
  Future<List<ExerciseModel>> getFavorites() async {
    try {
      final jsonString = await _storage.read(key: _favoritesKey);
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error getting favorites: $e');
      return [];
    }
  }

  /// Add exercise to favorites
  Future<void> addFavorite(ExerciseModel exercise) async {
    try {
      final favorites = await getFavorites();

      // Check if already exists
      if (favorites.any((e) => e.id == exercise.id)) {
        return;
      }

      favorites.add(exercise);
      await _saveFavorites(favorites);
    } catch (e) {
      debugPrint('Error adding favorite: $e');
      rethrow;
    }
  }

  /// Remove exercise from favorites
  Future<void> removeFavorite(String exerciseId) async {
    try {
      final favorites = await getFavorites();
      favorites.removeWhere((e) => e.id == exerciseId);
      await _saveFavorites(favorites);
    } catch (e) {
      debugPrint('Error removing favorite: $e');
      rethrow;
    }
  }

  /// Check if exercise is favorite
  Future<bool> isFavorite(String exerciseId) async {
    try {
      final favorites = await getFavorites();
      return favorites.any((e) => e.id == exerciseId);
    } catch (e) {
      debugPrint('Error checking favorite: $e');
      return false;
    }
  }

  /// Toggle favorite status
  Future<bool> toggleFavorite(ExerciseModel exercise) async {
    final isFav = await isFavorite(exercise.id);
    if (isFav) {
      await removeFavorite(exercise.id);
      return false;
    } else {
      await addFavorite(exercise);
      return true;
    }
  }

  /// Clear all favorites
  Future<void> clearFavorites() async {
    try {
      await _storage.delete(key: _favoritesKey);
    } catch (e) {
      debugPrint('Error clearing favorites: $e');
      rethrow;
    }
  }

  /// Get favorite count
  Future<int> getFavoriteCount() async {
    final favorites = await getFavorites();
    return favorites.length;
  }

  Future<void> _saveFavorites(List<ExerciseModel> favorites) async {
    final jsonList = favorites.map((e) => e.toJson()).toList();
    final jsonString = json.encode(jsonList);
    await _storage.write(key: _favoritesKey, value: jsonString);
  }
}
