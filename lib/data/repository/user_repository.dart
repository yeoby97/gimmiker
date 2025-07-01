

import 'package:firebase_auth/firebase_auth.dart';

import '../dataSource/user_source.dart';
import '../model/user.dart';

class UserRepository{

  final UserSource _userSource;

  UserRepository(this._userSource);

  Future<AppUser?> getUser(String uid)async{
    return await _userSource.getUser(uid);
  }

  Future<AppUser?> getCurrentUser()async{
    return await _userSource.getCurrentUser();
  }

  Stream<AppUser?> getCurrentUserStream(){
    return _userSource.getCurrentUserStream();
  }

  Future<void> updateUser(AppUser user)async{
    await _userSource.updateUser(user);
  }
}