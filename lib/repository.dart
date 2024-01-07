import 'package:dio/dio.dart';
import 'package:pure_match/userModel.dart';

class UserRepository{

  // Get users data from URL and map to the User object
  Future<List<User>> fetchUsers() async {
    try {
      final response = await Dio().get('https://api.stage.purematch.co/users/sample');
      final List<dynamic> jsonList = response.data['users'];

      // Map JSON data to User objects
      List<User> users = jsonList.map((json) => User.fromJson(json)).toList();

      return users;
    } catch (e) {
      // Handle errors
      print('Error fetching users: $e');
      return [];
    }
  }
}