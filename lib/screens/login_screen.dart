import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  final _singUpFormKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  final AuthController _authController = AuthController();
  bool showSignUp = false;
  bool isLoading = true;

  void _handleLogin() async {
    if (_authController.validateForm(_loginFormKey)) {
      bool isLoggedIn = await _authController.loginUser();
      if (isLoggedIn) {
        setState(() {
          isLoading = false;
        });
        Navigator.pushNamed(context, 'home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed: incorrect username or password.')),
        );
      }
    }
  }
  
  void _handleRegister() async {
    if (_authController.validateForm(_singUpFormKey)) {
      bool isRegistered = await _authController.registerUser();
      if (isRegistered) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User registered successfully.')),
        );
      }
    }
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                        Color.fromARGB(255, 40, 34, 41),
                        Color.fromARGB(255, 26, 24, 29),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                )
            ),
            child: Center(
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                            const Image(image: AssetImage('assets/images/moodify_logo.png'), height: 150),
                            const Text( "welcome!", textAlign: TextAlign.center, style: TextStyle(fontSize: 38, color: Colors.white)),
                            const Text("to moodify", textAlign: TextAlign.center, style: TextStyle(fontSize: 32, color: Color.fromARGB(255, 122, 63, 241), fontWeight: FontWeight.bold),),
                            const SizedBox(height: 20),
                            showSignUp ? _buildSignUpForm() : _buildLoginForm(),
                        const SizedBox(height: 40),
                        ElevatedButton(
                            onPressed: () {
                              if (!showSignUp) { 
                                _handleLogin();
                              } else { 
                                _handleRegister();
                              }
                              _focusNode.requestFocus();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 89, 30, 138),
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                            ),
                            child: Text(showSignUp ? "sign up!" : "login", style: const TextStyle(color: Colors.white, fontSize: 18))
                            ),
                        const SizedBox(height: 5),
                        const Text("or", style: TextStyle(color: Color.fromARGB(200, 255, 255, 255), fontSize: 18), textAlign: TextAlign.center),
                        const SizedBox(height: 5),
                        ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                Colors.purpleAccent,
                                Colors.blueAccent,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                            ).createShader(bounds),
                            child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    if (!showSignUp) {
                                        setState( () {
                                          showSignUp = true;
                                      });
                                    } else {
                                      setState(() {
                                        showSignUp = false;
                                      });
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(color: Color.fromARGB(255, 108, 192, 228), width: 2)
                                    ),
                                ),
                                child: Text(showSignUp ? "login" : "sign up!", style: const TextStyle(color: Colors.white, fontSize: 18)),
                                ),
                            ),
                        ]
                    )
                )
            )
        )
    );
  }

  // vista formulario login
  Widget _buildLoginForm(){
    return Form(
      key: _loginFormKey,
      child: Column(
        children: [
          _buildTextField("username", controller: _authController.usernameController),
          const SizedBox(height: 20),
          _buildTextField("password", obscureText: true, controller: _authController.passwordController),
        ],
      )
    );
  }

  // Vista del formulario de Sign In
  Widget _buildSignUpForm() {
    return Form(
      key: _singUpFormKey,
      child: Column(
        children: [
          _buildTextField("username", controller: _authController.usernameController),
          const SizedBox(height: 20),
          _buildTextField("email", controller: _authController.emailController),
          const SizedBox(height: 20),
          _buildTextField("password", obscureText: true, controller: _authController.passwordController),
        ],
      )
    );
  }

  // metodo para construir textfield
  Widget _buildTextField(String hintText, {bool obscureText = false, TextEditingController ? controller}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 103, 5, 208),
            width: 2,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 52, 52, 52).withValues(alpha: 0.9),
            width: 2,
          ),
        ),
      ),
      obscureText: obscureText,
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _authController.usernameController.dispose();
    _authController.emailController.dispose();
    _authController.passwordController.dispose();
    super.dispose();
  }

  // validate() {
  //   String? validatePassword(String value) {
  //     RegExp  regex = RegExp(r'^(?=.*[a-z])(?=.*[0-9])(?=.*?[!@#\$&*~]){8,}$');
  //     if (value.isEmpty) {
  //       return  'Please enter password';
  //     } else if (!regex.hasMatch(value)) {
  //       return 'Enter valid password';
  //     } else {
  //       return null;
  //     }
  //   }
  // }

  // Future<void> _dialogBuilder(BuildContext context, String text) {
  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('password'),
  //         content: Text(text),
  //         actions: <Widget>[
  //           TextButton(
  //             style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
  //             child: const Text('OK'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             }
  //           )
  //         ],
  //       );
  //     }
  //   );
  // }
}