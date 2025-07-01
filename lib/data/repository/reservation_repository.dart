
import 'package:gimmiker/data/dataSource/reservation_source.dart';

import '../model/reservation.dart';

class ReservationRepository{

  final ReservationSource _reservationSource;

  ReservationRepository(this._reservationSource);

  Future<String> addReservation(Reservation reservation)async{
    return await _reservationSource.addReservation(reservation);
  }

  Future<List<Reservation>> getAllReservations(List<String>? reservationIds)async{
    return await _reservationSource.getAllReservations(reservationIds);
  }

  Future<void> eraseReservation(ReservationData reservationData)async{
    await _reservationSource.eraseReservation(reservationData);
  }

}