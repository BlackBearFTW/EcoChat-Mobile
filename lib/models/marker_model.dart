class MarkerModel {
  late String id;
  late bool roofed;
  late double latitude;
  late double longitude;
  late int batteryLevel;
  late int availableSlots;
  late int totalSlots;

  MarkerModel(this.id, this.roofed, this.latitude, this.longitude, this.batteryLevel, this.availableSlots, this.totalSlots);

  MarkerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roofed = json['roofed'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    batteryLevel = json['batteryLevel'];
    availableSlots = json['availableSlots'];
    totalSlots = json['totalSlots'];
  }

}

