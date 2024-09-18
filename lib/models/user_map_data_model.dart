import 'latlng_model.dart';
import 'marker_meta_data.dart';

class UserMapDataModel {
  final String id;
  final String userId;
  final LatLangModel latlangModel;
  final MarkerMetaData markerMetaData;
  final String? timeStamp;
  final List<String> urls;

  const UserMapDataModel({
    required this.id,
    required this.userId,
    required this.latlangModel,
    
  required this.markerMetaData,
    required this.timeStamp,
    required this.urls,
  });

  factory UserMapDataModel.fromJson(Map<String, dynamic> json, String id) {
    return UserMapDataModel(
      id: id,
      userId: json['userId'] ?? '',
      latlangModel: LatLangModel.fromJson(json['latlangModel'] ?? {}),
       markerMetaData: MarkerMetaData.fromJson(
           json['markerMetaData'] ?? {}),
      timeStamp: json['timeStamp'] ?? '',
      urls: List<String>.from(json['urls'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'latlangModel': latlangModel.toJson(),
      'markerMetaData': markerMetaData.toJson(),
      'timeStamp': timeStamp,
      'urls': urls,
    };
  }
}
