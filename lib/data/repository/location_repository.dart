

import '../dataSource/location_source.dart';
import '../model/location.dart';

class LocationRepository{

  final LocationSource _locationSource;

  LocationRepository(this._locationSource);

  Future<Location?> getLocationFromLatLng(double lat,double lng){
    return _locationSource.getLocationFromLatLng(lat, lng);
  }

  Future<String> addLocation(double lat,double lng){
    return _locationSource.addLocation(lat, lng);
  }
}