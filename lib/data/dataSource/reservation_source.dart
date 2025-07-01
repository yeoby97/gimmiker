


import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/reservation.dart';
import '../model/user.dart';

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

  Future<void> eraseReservation(ReservationData reservationData)async{
    await _firestore.collection("reservations").doc(reservationData.id).delete();
    final ownerDoc = await _firestore.collection("users").doc(reservationData.owner.uid).get();
    AppUser user = AppUser.fromMap(ownerDoc.data()!);
    final userDoc = await _firestore.collection("users").doc(reservationData.user.uid).get();
    AppUser owner = AppUser.fromMap(userDoc.data()!);
    user.myReservations!.remove(reservationData.id);
    owner.receivedReservations!.remove(reservationData.id);
    await _firestore.collection("users").doc(reservationData.user.uid).update({
      "myReservations": user.myReservations
    });
    await _firestore.collection("users").doc(reservationData.owner.uid).update({
      "receivedReservations": owner.receivedReservations
    });
  }
}