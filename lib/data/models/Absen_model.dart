class AbsenModel {
  // ignore: non_constant_identifier_names
  final int? id;
  final String? nipas;
  final String? divisi;
  final int? status;
  final int? alasan;
  final int? transportasi;
  final int? kondisi;
  final int? jenis;
  final double? latitude;
  final double? longitude;
  final int? doc;
  final String? docName;
  final String? docType;
  final int? docSize;
  final String? docMime;
  final String? username;
  final String? userdate;
  final String? suhu;
  final String? address;
  final String? other;
  final int? divisiid;
  final String? zona;
  final String? dateAbsen;
  final String? kegiatan;

  AbsenModel(
      {this.id,
      required this.nipas,
      required this.divisi,
      required this.status,
      required this.alasan,
      this.transportasi,
      this.kondisi,
      required this.jenis,
      this.latitude,
      this.longitude,
      this.doc,
      this.docName,
      this.docType,
      this.docSize,
      this.docMime,
      this.username,
      this.userdate,
      this.suhu,
      this.address,
      this.other,
      this.divisiid,
      this.zona,
      this.dateAbsen,
      this.kegiatan});

  factory AbsenModel.fromJson(Map<dynamic, dynamic> json) {
    return AbsenModel(
        id: json["id"],
        nipas: json["nipas"],
        divisi: json["divisi"],
        status: json["status"],
        alasan: json["alasan"],
        transportasi: json["transportasi"],
        kondisi: json["kondisi"],
        jenis: json["jenis"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        doc: json["doc"],
        docName: json["doc_name"],
        docType: json["doc_type"],
        docSize: json["doc_size"],
        docMime: json["doc_mime"],
        username: json["username"],
        userdate: json["userdate"],
        suhu: json["suhu"],
        address: json["address"],
        other: json["other"],
        divisiid: json["divisiid"],
        zona: json["zona"],
        dateAbsen: json["date_absen"],
        kegiatan: json["kegiatan"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nipas": nipas,
      "divisi": divisi,
      "status": status!,
      "alasan": alasan!,
      "transportasi": transportasi!.toInt(),
      "kondisi": kondisi!.toInt(),
      "jenis": jenis!.toInt(),
      "latitude": latitude,
      "longitude": longitude,
      "doc": doc,
      "doc_name": docName,
      "doc_type": docType,
      "doc_size": docSize,
      "doc_mime": docMime,
      "username": username,
      "userdate": userdate,
      "suhu": suhu,
      "address": address,
      "other": other,
      "divisiid": divisiid,
      "zona": zona,
      "date_absen": dateAbsen,
      "kegiatan": kegiatan
    };
  }
}
