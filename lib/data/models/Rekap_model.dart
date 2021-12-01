class HistoriModel {
  HistoriModel({
    required this.statuses,
    required this.data,
  });

  String statuses;
  List<Datum> data;

  factory HistoriModel.fromJson(Map<String, dynamic> json) => HistoriModel(
        statuses: json["statuses"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "statuses": statuses,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.username,
    required this.date,
    required this.status,
    required this.address,
    required this.jenis,
  });

  int id;
  String username;
  DateTime date;
  int status;
  String address;
  int jenis;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        username: json["username"],
        date: DateTime.parse(json["date"]),
        status: json["status"],
        address: json["address"],
        jenis: json["jenis"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "date": date.toIso8601String(),
        "status": status,
        "address": address,
        "jenis": jenis,
      };
}
