import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../data/dataSource/user_source.dart';
import '../../data/model/user.dart';
import '../../data/repository/user_repository.dart';
import '../../services/location_service.dart';
import '../sign/signin/sign_in_screen.dart';

class MainProvider extends ChangeNotifier {

  final UserRepository _userRepository;
  AppUser? _user;
  int _currentIndex = 0;
  DateTime? _lastBackPressedTime;
  LatLng? _location;

  StreamSubscription<AppUser?>? _userSubscription;
// 생성자
  MainProvider([this._location])
      : _userRepository = UserRepository(UserSource()){
    subscribeToUser();
  }

  AppUser? get currentUser => _user;
  int get currentIndex => _currentIndex;
  DateTime? get lastBackPressedTime => _lastBackPressedTime;
  LatLng? get location => _location;


  set currentIndex(int value) {
    _currentIndex = value;
    notifyListeners();
  }

  set lastBackPressedTime(DateTime? value) {
    _lastBackPressedTime = value;
    notifyListeners();
  }

  void subscribeToUser() async{
    _userSubscription?.cancel();
    _userSubscription = _userRepository.getCurrentUserStream().listen((user) {
      _user = user;
      print(user?.uid);
    });
  }

  void locationUpdate()async{
    _location = await findMyLocation();
  }

  Future<void> handleBackPressed(BuildContext context) async {
    if (_currentIndex != 0) {
      _currentIndex = 0;
      notifyListeners();
      return;
    }

    final now = DateTime.now();
    if (_lastBackPressedTime == null || now.difference(_lastBackPressedTime!) > const Duration(seconds: 2)) {
      _lastBackPressedTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('뒤로 버튼을 한 번 더 누르면 종료됩니다.')),
      );
    } else {
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else {
        exit(0);
      }
    }
  }

  Future<void> onTabSelected(int index, BuildContext context) async {

    final user = context.read<MainProvider>().currentUser;

    if (index == 2 && user == null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
      if (result == null) return;
    }
    _currentIndex = index;
    notifyListeners();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _userSubscription?.cancel();
  }
}