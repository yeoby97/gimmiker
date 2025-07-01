

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/main/main_provider.dart';
import '../features/sign/signin/sign_in_screen.dart';

Future<bool> checkLogin(BuildContext context) async {
  final mainProvider = context.read<MainProvider>();
  final user = mainProvider.currentUser;
  // 유저확인
  if (user == null) {
    final loginResult = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const SignInScreen(),
      ),
    );
    if (loginResult != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인 후 이용해주세요.')),
      );
      return false;
    }
    mainProvider.subscribeToUser();
  }
  return true;
}