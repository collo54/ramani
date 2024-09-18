class DocumentPath {
  static String newUserMarkerData(String uid, String userMarkerDataId) =>
      'Users/$uid/userMarkers/$userMarkerDataId';
  static String streamUserMarkerData(String uid) => 'Users/$uid/userMarkers/';

  static String newUser(String uid, String userId) =>
      'Users/$uid/userData/$userId';
  static String streamUser(String uid) => 'Users/$uid/userData/';

  static String newLocation(String newLocationId) => 'Locations/$newLocationId';
  static String streamLocation() => 'Locations/';

  static String newStorageFile(String newFileId) => 'Uploads/$newFileId';
}
