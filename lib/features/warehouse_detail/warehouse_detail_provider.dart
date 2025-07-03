

import 'package:flutter/material.dart';
import 'package:gimmiker/data/repository/user_repository.dart';
import 'package:provider/provider.dart';

import '../../data/dataSource/reservation_source.dart';
import '../../data/dataSource/user_source.dart';
import '../../data/model/reservation.dart';
import '../../data/model/space.dart';
import '../../data/model/user.dart';
import '../../data/model/warehouse.dart';
import '../../data/repository/reservation_repository.dart';
import '../../services/sign_in_service.dart';
import '../main/main_provider.dart';

class WarehouseDetailProvider extends ChangeNotifier{

  final userRepository = UserRepository(UserSource());
  final reservationRepository = ReservationRepository(ReservationSource());

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  int? _selectedSpaceNum;

  int? get selectedSpaceNum => _selectedSpaceNum;

  DateTime? _selectedDate = DateTime.now();

  bool isLoadings = false;

  DateTime? get selectedDate => _selectedDate;
  set selectedMonths(int? value) {
    _selectedMonths = value;
    notifyListeners();
  }

  int? _selectedMonths = 1;
  int? get selectedMonths => _selectedMonths;
  set selectedDate(DateTime? value) {
    _selectedDate = value;
    notifyListeners();
  }

  void setSelectedSpaceNum(int? num) {
    _selectedSpaceNum = num;
    notifyListeners();
  }

  void onBackgroundPress(){
    setSelectedSpaceNum(null);
  }

  void onSpacePress(int num){
    setSelectedSpaceNum(num);
  }

  Future<void> reserveButtonTap(BuildContext context, Warehouse warehouse, List<Space> spaces) async {
    setLoading(true);

    try {
      AppUser? user = context.read<MainProvider>().currentUser;

      if (user == null) {
        final loginSuccess = await checkLogin(context);
        setLoading(false);
        if (!loginSuccess) return;
        // 로그인 성공 후 다시 유저 정보 불러오기
        user = context.read<MainProvider>().currentUser;
        if (user == null) return;
      }

      if (_selectedSpaceNum != null && _selectedDate != null && _selectedMonths != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('예약을 신청합니다.'),
            backgroundColor: Colors.green,
          ),
        );

        final space = spaces.firstWhere((space) => space.num == _selectedSpaceNum);

        final reservation = Reservation(
          locationId: warehouse.locationId,
          warehouseId: warehouse.id,
          spaceId: space.id,
          createdAt: DateTime.now(),
          startAt: _selectedDate!,
          endAt: addMonths(_selectedDate!, _selectedMonths!), // 정확한 월 계산
          userId: user.uid,
          ownerId: warehouse.ownerId,
        );

        final reservationId = await reservationRepository.addReservation(reservation);
        final updatedUser = user.copyWith(
          myReservations: [
            ...(user.myReservations ?? []),
            reservationId
          ],
        );
        await userRepository.updateUser(updatedUser);

        AppUser? owner = await userRepository.getUser(warehouse.ownerId);
        final updatedOwner = owner?.copyWith(
          receivedReservations: [
            ...(owner.receivedReservations ?? []),
            reservationId
          ],
        );
        if (updatedOwner != null) await userRepository.updateUser(updatedOwner);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('예약이 완료되었습니다.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('모든 항목을 입력해주세요.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('예약 실패: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setLoading(false);
    }
  }



  DateTime addMonths(DateTime date, int months) {
    int year = date.year;
    int month = date.month + months;
    int day = date.day;

    while (month > 12) {
      month -= 12;
      year += 1;
    }

    while (month < 1) {
      month += 12;
      year -= 1;
    }

    int lastDay = DateTime(year, month + 1, 0).day;
    if (day > lastDay) day = lastDay;

    return DateTime(year, month, day);
  }

}