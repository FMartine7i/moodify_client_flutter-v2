import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  Future<bool> loginUser() async {
    final username = usernameController.text;
    final password = passwordController.text;
    try{
      final storedUser = await _apiService.compareUserDetails(username, password);
      if (storedUser['username'] == username) {
        await saveUser(storedUser['id'], storedUser['username']);
        return true;
      } else {
        print('Error: Usuario o contraseña incorrectos');
        return false;
      }
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<void> saveUser(int userId, String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id', userId);
    await prefs.setString('username', username);
  }
// ==================================== registar usuario ====================================
  Future<bool> registerUser() async {
    final username = usernameController.text;
    final email = emailController.text;
    final password = passwordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      print('Error: All fields are required');
      return false;
    }

    try{
      final response = await _apiService.createUser(username, email, password);
      return response.isNotEmpty;
    } catch (err) {
      print(err);
      return false;
    }
  }
  //validar campos del formulario
  bool validateForm(GlobalKey<FormState> formKey) {
    return formKey.currentState?.validate() ?? false;
  }

  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}