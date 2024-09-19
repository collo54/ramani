import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_platform_interface/location_platform_interface.dart';
import 'package:uuid/uuid.dart';

import '../constants/colors.dart';
import '../custom/asset_string.dart';
import '../models/latlng_model.dart';
import '../models/marker_meta_data.dart';
import '../models/user_map_data_model.dart';
import '../providers/providers.dart';

class CreateMyLocationMarkerBottomsheet extends ConsumerStatefulWidget {
  final List<String> iconList;
  //final LatLng latlng;
  late GoogleMapController? mapController;

  CreateMyLocationMarkerBottomsheet({
    super.key,
    required this.iconList,
    // required this.latlng,
    required this.mapController,
  });

  @override
  ConsumerState<CreateMyLocationMarkerBottomsheet> createState() =>
      _CreateMyLocationMarkerBottomsheetState();
}

class _CreateMyLocationMarkerBottomsheetState
    extends ConsumerState<CreateMyLocationMarkerBottomsheet> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _description;
  String? _markerId;
  String? _assetString;
  Uuid uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _markerId = uuid.v1();
    _assetString = widget.iconList[0];
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      form.reset();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(markerProvider);
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(blurRadius: 10, color: kgrey21721721705, spreadRadius: 5)
        ],
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.25,
        maxChildSize: 0.8,
        expand: false,
        builder: (
          _,
          draggableScrollController,
        ) {
          return ListView(
            controller: draggableScrollController,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                'Create Marker',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                    color: kblack12121210,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: kblack000010,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 300,
                height: 100,
                child: ListView.builder(
                  itemCount: widget.iconList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        setState(() {
                          _assetString = widget.iconList[index];
                        });
                        // await currentLocationCustomMarker(
                        //   ref,
                        //   context,
                        //   getIconName(widget.iconList[index]),
                        // );
                      },
                      child: Container(
                        width: 80,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _assetString == widget.iconList[index]
                                ? Colors.blue
                                : Colors.transparent,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: ListTile(
                            title: Image.asset(
                              widget.iconList[index],
                              width: 30,
                              height: 30,
                            ),
                            subtitle: Text(
                              getIconName(widget.iconList[index]),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 350,
                width: 300,
                child: _buildForm(),
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              // MaterialButton(
              //   onPressed: _assetString == null ||
              //           _title == null ||
              //           _description == null ||
              //           _markerId == null
              //       ? null
              //       : () async {
              //           await _saveToFirestore(ref);
              //         },
              //   color: kblue9813424010,
              //   shape: const RoundedRectangleBorder(
              //     borderRadius: BorderRadius.all(
              //       Radius.circular(10.0),
              //     ),
              //   ),
              //   height: 55,
              //   minWidth: 248,
              //   child: Text(
              //     'create',
              //     style: GoogleFonts.inter(
              //       textStyle: const TextStyle(
              //         color: kwhite25525525510,
              //         fontSize: 16,
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
            ],
          );
        },
      ),
    );
  }

  String getIconName(String path) {
    final regex = RegExp(r'/([^/]+)\.(png|jpg)');
    final match = regex.firstMatch(path);
    if (match != null) {
      return match.group(1) ?? 'null group';
    } else {
      return 'null match';
    }
  }

  Future<void> currentLocationCustomMarker(WidgetRef ref,
      String infoWindowString, LocationData? locationData) async {
    try {
      if (locationData != null) {
        var latlngHolder =
            LatLng(locationData.latitude ?? 0, locationData.longitude ?? 0);
        final assetMarkers = MarkersAssets();
        await assetMarkers
            .newsingleCustomMarkers(
          title: _title ?? infoWindowString,
          markerId: _markerId!,
          center: latlngHolder,
          context: context,
          pngString: _assetString!,
        )
            .then((value) {
          ref.read(markerProvider.notifier).addMarkerSet(value);
        });
        widget.mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: latlngHolder,
              zoom: 15.0,
              tilt: 20.0,
            ),
          ),
        );
        await Future.delayed(const Duration(milliseconds: 500));
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
            msg:
                "currentLocationCustomMarker method Exception: Null LocationData ",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: kred236575710,
            textColor: kwhite25525525510,
            fontSize: 16.0);
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
          msg: "CreateMarker class CustomMarker method Exception: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: kred236575710,
          textColor: kwhite25525525510,
          fontSize: 16.0);
    }
  }

  Future<LocationData?> getLatLang(WidgetRef ref) async {
    final locationService = ref.watch(locationServiceProvider);
    final locationData = await locationService.getLocation();
    return locationData;
  }

  Future<void> _saveToFirestore(WidgetRef ref) async {
    LocationData? locationData = await getLatLang(ref);

    if (_validateAndSaveForm() &&
        _assetString != null &&
        _markerId != null &&
        locationData != null) {
      try {
        List<String> urls = [];
        final userModel = ref.watch(userModelProvider);

        var latlngHolder =
            LatLng(locationData.latitude ?? 0, locationData.longitude ?? 0);
        final latlangModel = LatLangModel(
          lat: latlngHolder.latitude,
          lang: latlngHolder.longitude,
        );
        final firestoreservice = ref.watch(cloudFirestoreServiceProvider);

        final userMapDataModel = UserMapDataModel(
          id: documentIdFromCurrentDate(),
          userId: userModel.uid,
          latlangModel: latlangModel,
          markerMetaData: MarkerMetaData(
            description: _description ?? '',
            infoWindow: _title ?? '',
            markerId: _markerId!,
            assetString: _assetString ?? '',
          ),
          timeStamp: documentIdFromCurrentDate(),
          urls: urls,
        );
        await firestoreservice.setUserMapDataModel(userMapDataModel);
        await currentLocationCustomMarker(
          ref,
          _title!,
          locationData,
        );
      } on Exception catch (e) {
        Fluttertoast.showToast(
            msg: "Error saving file cloud firestore: $e",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0);
        if (kDebugMode) {
          print('Error saving file cloud firestore: $e');
        }
      }
    } else {
      Fluttertoast.showToast(
          msg:
              "Please fill all fields \nassetString: $_assetString \ntitle: $_title \ndescription: $_description \nmarkerId: $_markerId",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      Text(
        'Title',
        style: GoogleFonts.poppins(
          textStyle: const TextStyle(
            color: kblackgrey48484810,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'title';
          }
          return null;
        },
        initialValue: '',
        onSaved: (value) => _title = value!.trim(),
        style: GoogleFonts.roboto(
          textStyle: const TextStyle(
            color: kblackgrey62606310,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          // prefixIcon: const HugeIcon(
          //   icon: HugeIcons.strokeRoundedMail01,
          //   color: kblack00008,
          //   size: 24.0,
          // ),
          fillColor: kwhite25525525510,
          label: Text(
            ' Title ',
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                color: kblackgrey62606310,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          filled: true,
          hintText: '',
          labelStyle: const TextStyle(
            color: kblackgrey62606310,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kblackgrey79797910, width: 0.5),
            // borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(4.0),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: kblackgrey79797910, width: 0.5),
            // borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(4.0),
          ),
          focusColor: const Color.fromRGBO(243, 242, 242, 1),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kblackgrey79797910, width: 0.5),
            borderRadius: BorderRadius.circular(4.0),
          ),
          hintStyle: GoogleFonts.dmSans(
            textStyle: const TextStyle(
              color: kblackgrey62606310,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        maxLines: 1,
        textAlign: TextAlign.start,
      ),
      const SizedBox(
        height: 15,
      ),
      Text(
        'Description',
        style: GoogleFonts.inter(
          textStyle: const TextStyle(
            color: kblackgrey48484810,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Description';
          }
          return null;
        },
        initialValue: '',
        onSaved: (value) => _description = value!.trim(),
        style: GoogleFonts.roboto(
          textStyle: const TextStyle(
            color: kblackgrey62606310,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        decoration: InputDecoration(
          // prefixIcon: const HugeIcon(
          //   icon: HugeIcons.strokeRoundedLockPassword,
          //   color: kblack00008,
          //   size: 24.0,
          // ),
          fillColor: kwhite25525525510,
          filled: true,
          label: Text(
            ' Description ',
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                color: kblackgrey62606310,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          hintText: '',
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kblackgrey79797910, width: 0.5),
            // borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(4.0),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: kblackgrey79797910, width: 0.5),
            // borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(4.0),
          ),
          focusColor: const Color.fromRGBO(243, 242, 242, 1),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kblackgrey79797910, width: 0.5),
            borderRadius: BorderRadius.circular(4.0),
          ),
          hintStyle: GoogleFonts.dmSans(
            textStyle: const TextStyle(
              color: kblackgrey62606310,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        maxLines: 3,
        textAlign: TextAlign.start,
      ),
      const SizedBox(
        height: 15,
      ),
      MaterialButton(
        onPressed:
            //  _assetString == null ||
            //         _title == null ||
            //         _description == null ||
            //         _markerId == null
            //     ? () {
            //         Fluttertoast.showToast(
            //             msg:
            //                 "Please fill all fields \nassetString: $_assetString \ntitle: $_title \ndescription: $_description \nmarkerId: $_markerId",
            //             toastLength: Toast.LENGTH_LONG,
            //             gravity: ToastGravity.BOTTOM,
            //             timeInSecForIosWeb: 1,
            //             backgroundColor: Colors.redAccent,
            //             textColor: Colors.white,
            //             fontSize: 16.0);
            //       }
            //     :
            () async {
          await _saveToFirestore(ref);
        },
        color: kblue9813424010,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        height: 55,
        minWidth: 248,
        child: Text(
          'create',
          style: GoogleFonts.inter(
            textStyle: const TextStyle(
              color: kwhite25525525510,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
    ];
  }
}
