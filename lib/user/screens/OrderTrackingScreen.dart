import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/string_extensions.dart';

import '../../main.dart';
import '../../main/components/CommonScaffoldComponent.dart';
import '../../main/models/LoginResponse.dart';
import '../../main/models/OrderListModel.dart';
import '../../main/network/RestApis.dart';
import '../../main/utils/Common.dart';
import '../../main/utils/Constants.dart';

class OrderTrackingScreen extends StatefulWidget {
  static String tag = '/OrderTrackingScreen';

  final OrderData orderData;

  OrderTrackingScreen({required this.orderData});

  @override
  OrderTrackingScreenState createState() => OrderTrackingScreenState();
}

class OrderTrackingScreenState extends State<OrderTrackingScreen> {
  Timer? timer;

  List<Marker> markers = [];
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];


  LatLng? sourceLocation;

  double cameraZoom = 13;

  double cameraTilt = 0;
  double cameraBearing = 30;

  UserData? deliveryBoyData;

  late Marker deliveryBoyMarker;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => getDeliveryBoyDetails());
  }

  getDeliveryBoyDetails() {
    getUserDetail(widget.orderData.deliveryManId.validate()).then((value) {
      deliveryBoyData = value;
      sourceLocation = LatLng(deliveryBoyData!.latitude.toDouble(), deliveryBoyData!.longitude.toDouble());
      MarkerId id = MarkerId("DeliveryBoy");
      markers.remove(id);
      deliveryBoyMarker = Marker(
        markerId: id,
        position: LatLng(deliveryBoyData!.latitude.toDouble(), deliveryBoyData!.longitude.toDouble()),
        infoWindow: InfoWindow(
            title: '${deliveryBoyData!.name.validate()}', snippet: '${language.lastUpdatedAt} ${dateParse(deliveryBoyData!.updatedAt!)}'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );
      markers.add(deliveryBoyMarker);
      markers.add(
        Marker(
          markerId: MarkerId(widget.orderData.cityName.validate()),
          position: widget.orderData.status == ORDER_ACCEPTED
              ? LatLng(widget.orderData.pickupPoint!.latitude.toDouble(), widget.orderData.pickupPoint!.longitude.toDouble())
              : LatLng(widget.orderData.deliveryPoint!.latitude.toDouble(), widget.orderData.deliveryPoint!.longitude.toDouble()),
          infoWindow: InfoWindow(
              title: widget.orderData.status == ORDER_ACCEPTED
                  ? widget.orderData.pickupPoint!.address.validate()
                  : widget.orderData.deliveryPoint!.address.validate()),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
      setPolyLines(deliveryLatLng: LatLng(deliveryBoyData!.latitude.toDouble(), deliveryBoyData!.longitude.toDouble()));
      setState(() {});
    }).catchError((error) {
      print(error);
    });
  }

  Future<void> setPolyLines({required LatLng deliveryLatLng}) async {
    _polylines.clear();
    polylineCoordinates.clear();
    String? originLat = deliveryLatLng.latitude.toString();
    String? originLong = deliveryLatLng.longitude.toString();
    String? destinationLat = widget.orderData.status == ORDER_ACCEPTED ? widget.orderData.pickupPoint!.latitude : widget.orderData.deliveryPoint!.latitude ;
    String? destinationLong = widget.orderData.status == ORDER_ACCEPTED ? widget.orderData.pickupPoint!.longitude : widget.orderData.deliveryPoint!.longitude;
    String origins = "${originLat},${originLong}";
    String destinations = "${destinationLat},${destinationLong}";
    await getPolylineData(origins, destinations).then((value) async {
      if(value.status != null && value.status!){
        if(value.polyline != null){
          final points = decodePolyline(value.polyline!);
          if(points.isNotEmpty){
            polylineCoordinates = points;
            _polylines.add(Polyline(
              visible: true,
              width: 5,
              polylineId: PolylineId('poly'),
              color: Color.fromARGB(255, 40, 122, 198),
              points: polylineCoordinates,
            ));
            setState(() {});
          }else{
            debugPrint('---No Data--');
          }
        }else{
          debugPrint('---Polyline Null---');
        }
      }else{
        debugPrint('---Status False or Null---');
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffoldComponent(
      appBarTitle: language.trackOrder,
      body: sourceLocation != null
          ? GoogleMap(
              markers: markers.map((e) => e).toSet(),
              polylines: _polylines,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: sourceLocation!,
                zoom: cameraZoom,
                tilt: cameraTilt,
                bearing: cameraBearing,
              ),
            )
          : loaderWidget(),
    );
  }
}
