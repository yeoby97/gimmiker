

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gimmiker/features/home/bottom_sheet/bottom_sheet_provider.dart';
import 'package:gimmiker/features/home/home_provider.dart';
import 'package:gimmiker/features/main/main_provider.dart';
import 'package:gimmiker/services/location_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../main/main_screen.dart';

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('로그아웃'),
      content: const Text('정말 로그아웃할까요?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);

            await GoogleSignIn().signOut();
            await FirebaseAuth.instance.signOut();

            if (context.mounted) {

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider(create: (_) => HomeProvider()),
                      ChangeNotifierProvider(create: (_) => MainProvider()),
                      ChangeNotifierProvider(create: (_) => BottomSheetProvider()),
                    ],
                    child: const MainScreen(),
                  ),
                ),
                    (_) => false,
              );
            }
          },
          child: const Text('확인'),
        ),
      ],
    ),
  );
}
