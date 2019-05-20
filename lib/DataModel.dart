import 'dart:convert';

ImcMeasurement imcMeasurementFromJson(String str) => ImcMeasurement.fromMap(json.decode(str));

String imcMeasurementToJson(ImcMeasurement data) => json.encode(data.toMap());

class ImcMeasurement {
  int id;
  String clientHeight;
  String clientWeight;
  String clientImc;

  ImcMeasurement({
    this.id,
    this.clientHeight,
    this.clientWeight,
    this.clientImc,
  });

  factory ImcMeasurement.fromMap(Map<String, dynamic> json) => new ImcMeasurement(
    id: json["id"],
    clientHeight: json["client_height"],
    clientWeight: json["client_weight"],
    clientImc: json["client_IMC"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "client_height": clientHeight,
    "client_weight": clientWeight,
    "client_IMC": clientImc,
  };
}
