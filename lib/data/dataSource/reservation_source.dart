


import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/reservation.dart';

class ReservationSource{

  final _firestore = FirebaseFirestore.instance;

  Future<String> addReservation(Reservation reservation)async{
    final doc = await _firestore.collection("reservations").add(reservation.toMap());
    return doc.id;
  }

  Future<List<Reservation>> getAllReservations(List<String>? reservationIds)async{
    List<Reservation> reservations = [];
    if(reservationIds == null) return reservations;
    for(String reservationId in reservationIds) {
      final doc = await _firestore
          .collection("reservations")
          .doc(reservationId)
          .get();
      reservations.add(Reservation.fromDoc(doc));
    }
    return reservations;
  }
}