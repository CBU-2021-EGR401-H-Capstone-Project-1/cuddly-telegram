import 'dart:io';

import 'package:cuddly_telegram/model/journal.dart';
import 'package:cuddly_telegram/model/journal_store.dart';
import 'package:cuddly_telegram/screens/editor_screen.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);
  static const routeName = '/map';

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? pickedLocation;

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

  Widget _journalMap(LatLng latLng) {
    return Consumer<JournalStore>(
      builder: ((context, journalStore, child) {
        Set<Journal> journalsWithLatLng = journalStore.journals
            .where((element) =>
                element.latitude != null && element.longitude != null)
            .toSet();
        Set<Marker> markers = journalsWithLatLng
            .map(
              (j) => Marker(
                markerId: MarkerId(j.id),
                infoWindow: InfoWindow(
                  title: j.title,
                  snippet: DateFormat.yMMMd(Platform.localeName)
                      .format(j.dateCreated),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditorScreen(journal: j),
                    ),
                  ),
                ),
                position: LatLng(j.latitude!, j.longitude!),
              ),
            )
            .toSet();
        return GoogleMap(
          buildingsEnabled: true,
          compassEnabled: true,
          initialCameraPosition: CameraPosition(target: latLng, zoom: 16.0),
          mapType: MapType.normal,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          markers: markers,
        );
      }),
    );
  }

  Widget _selectionMap(LatLng initialLatLng, BuildContext context) {
    return GoogleMap(
      buildingsEnabled: true,
      compassEnabled: true,
      initialCameraPosition: CameraPosition(target: initialLatLng, zoom: 16.0),
      mapType: MapType.normal,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      markers: (pickedLocation != null)
          ? {
              Marker(
                markerId: const MarkerId('selection'),
                position: pickedLocation ?? initialLatLng,
                infoWindow: InfoWindow(
                  title: 'Selected Location',
                  snippet:
                      'Latitude: ${pickedLocation!.latitude.toStringAsFixed(3)}, Longitude: ${pickedLocation!.longitude.toStringAsFixed(3)}',
                ),
              ),
            }
          : {},
      onTap: (e) => setState(() {
        pickedLocation = e;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    var isSelectingLocation = false;
    if (ModalRoute.of(context)?.settings.arguments is Tuple2<bool, LatLng?>) {
      final args =
          (ModalRoute.of(context)?.settings.arguments as Tuple2<bool, LatLng?>);
      isSelectingLocation = args.item1;
      pickedLocation ??= args.item2;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: pickedLocation != null
          ? FloatingActionButton.extended(
              extendedTextStyle: Theme.of(context).textTheme.labelLarge,
              backgroundColor: Theme.of(context).colorScheme.primary,
              label: const Text('Select Location'),
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pop(pickedLocation!);
              },
              extendedPadding: const EdgeInsets.all(32.0),
            )
          : null,
      body: SafeArea(
        child: FutureBuilder<Position>(
          future: _determinePosition(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final position = snapshot.data!;
              final initialLatLng =
                  LatLng(position.latitude, position.longitude);
              if (isSelectingLocation) {
                return _selectionMap(initialLatLng, context);
              } else {
                return _journalMap(initialLatLng);
              }
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
