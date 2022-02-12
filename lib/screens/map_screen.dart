import 'dart:io';

import 'package:cuddly_telegram/model/journal.dart';
import 'package:cuddly_telegram/model/journal_store.dart';
import 'package:cuddly_telegram/screens/editor_screen.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);
  static const routeName = '/map';

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: SafeArea(
        child: FutureBuilder<Position>(
          future: _determinePosition(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final position = snapshot.data!;
              final initialLatLng =
                  LatLng(position.latitude, position.longitude);
              return Consumer<JournalStore>(
                builder: ((context, journalStore, child) {
                  Set<Journal> journalsWithLatLng = journalStore.journals
                      .where((element) =>
                          element.latitude != null && element.longitude != null)
                      .toSet();
                  Set<Marker> markers = journalsWithLatLng
                      .map(
                        (e) => Marker(
                          markerId: MarkerId(e.id),
                          infoWindow: InfoWindow(
                            title: e.title,
                            snippet: DateFormat.yMMMd(Platform.localeName)
                                .format(e.dateCreated),
                          ),
                          position: LatLng(e.latitude!, e.longitude!),
                          onTap: () {
                            Navigator.of(context).pushReplacementNamed(
                                EditorScreen.routeName,
                                arguments: e);
                          },
                        ),
                      )
                      .toSet();
                  return GoogleMap(
                    initialCameraPosition:
                        CameraPosition(target: initialLatLng),
                    markers: markers,
                  );
                }),
              );
            } else if (snapshot.hasError) {
              final error = snapshot.error as String;
              return Center(
                child: Text(error),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
