import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../main/main_provider.dart';
import '../search/search_screen.dart';
import 'bottom_sheet/bottom_sheet_provider.dart';
import 'bottom_sheet/bottom_sheet_screen.dart';
import 'home_provider.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();

    return Scaffold(
      body: Stack(
        children: [
          _GoogleMap(),
          _MyLocationButton(),
          if(homeProvider.isBottomSheetOpen)
            CustomBottomSheet(
            warehouse: homeProvider.selectedWarehouse!,
            spaces: homeProvider.spaces,
            ),
          _SearchBox(),
        ],
      )
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: GestureDetector(
            onTap: () => _onSearchTap(context),
            child: Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(3, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Icon(Icons.map),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '장소나 위치를 검색하세요.',
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.search),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSearchTap(BuildContext context) async {
    final homeProvider = context.read<HomeProvider>();
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SearchScreen()),
    );

    if (result is Map<String, dynamic> && result['location'] is LatLng) {
      final LatLng location = result['location'];
      homeProvider.mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: location, zoom: 16),
        ),
      );
    }
  }
}


class _GoogleMap extends StatelessWidget {
  const _GoogleMap({super.key});

  @override
  Widget build(BuildContext context) {
    final mainProvider = context.read<MainProvider>();
    final homeProvider = context.read<HomeProvider>();

    return GoogleMap(
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      initialCameraPosition: CameraPosition(
        target: mainProvider.location ?? LatLng(126.9312417,37.59996944),
        zoom: 16,
      ),
      onMapCreated: (controller) {
        homeProvider.mapController = controller;
      },
      markers: homeProvider.markers,
    );
  }
}

class _MyLocationButton extends StatelessWidget {
  const _MyLocationButton({super.key});

  @override
  Widget build(BuildContext context) {

    final homeProvider = context.read<HomeProvider>();
    final mainProvider = context.read<MainProvider>();

    return Positioned(
      bottom: 16,
      left : 16,
      child: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        onPressed: () async {
          mainProvider.locationUpdate();
          if(mainProvider.location == null) return;
          homeProvider.mapController.animateCamera(
            CameraUpdate.newLatLng(
              mainProvider.location!,
            ),
          );
        },
        child: Icon(Icons.my_location),
      ),
    );
  }
}




