import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:solutionchallenge/auth/auth_service.dart';
import 'auth/auth.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({Key? key, required this.showRegisterPage}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailandPassword() async {
    try {
      await Auth().signInWithEmailandPassword(
          email: _controllerEmail.text.trim(),
          password: _controllerPassword.text.trim());
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailandPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future signInWithGoogle() async {
    try {
      await AuthService().signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  // Widget _title() {
  //   return const Text('FAKit');
  // }

  Widget _entryField(
    String title,
    TextEditingController controller,
    bool obscureText,
  ) {
    return TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400)),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: title,
            hintStyle: TextStyle(color: Colors.grey.shade500)));
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : '$errorMessage');
  }

  Widget _oAuth(
    String imagePath,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey.shade200),
      child: Image.asset(
        imagePath,
        height: 40,
      ),
    );
  }

  Widget _submitButton() {
    // return ElevatedButton(
    //   onPressed:
    //       isLogin ? signInWithEmailandPassword : createUserWithEmailandPassword,
    //   child: Text(isLogin ? 'Login' : 'Register'),
    // );
    return GestureDetector(
      onTap: signInWithEmailandPassword,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(8)),
        child: const Center(
          child: Text(
            'Login',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
      ),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        widget.showRegisterPage;
      },
      child: const Text(
        'Register instead',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/firstaid1.png',
                  height: 275,
                ),
                // const Text(
                //   'FAKit',
                //   style: TextStyle(
                //     fontWeight: FontWeight.bold,
                //     fontSize: 30,
                //   ),
                // ),
                _entryField('email', _controllerEmail, false),
                const SizedBox(
                  height: 15,
                ),
                _entryField('password', _controllerPassword, true),
                _errorMessage(),
                _submitButton(),
                _loginOrRegisterButton(),
                const SizedBox(
                  height: 8,
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25),
                //   child: Row(
                //     children: [
                //       Expanded(
                //           child: Divider(
                //         color: Colors.grey.shade400,
                //         thickness: 0.5,
                //       )),
                //       Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 15),
                //         child: Text(
                //           'or continue with',
                //           style: TextStyle(color: Colors.grey.shade500),
                //         ),
                //       ),
                //       Expanded(
                //           child: Divider(
                //         color: Colors.grey.shade400,
                //         thickness: 0.5,
                //       )),
                //     ],
                //   ),
                // ),
                // const SizedBox(
                //   height: 25,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     _oAuth('assets/google.png'),
                //   ],
                // ),
              ],
            )));
  }
}
