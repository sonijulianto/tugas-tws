class AbsenModel {
  // ignore: non_constant_identifier_names
  final int? absIdents;
  final String? absNipas;
  final String? absDivisi;
  final int? absStatus;
  final int? absAlasan;
  final int? absTransportasi;
  final int? absKondisi;
  final int? absJenis;
  final double? absLatitude;
  final double? absLongitude;
  final int? absDoc;
  final String? absDocName;
  final String? absDocType;
  final int? absDocSize;
  final String? absDocMime;
  final String? absUsrnam;
  final String? absUsrdat;
  final String? absSuhu;
  final String? absAddress;
  final String? absOther;
  final int? divisiid;
  final String? absZona;
  final String? absDateAbsen;
  final String? absKegiatan;

  AbsenModel(
      {this.absIdents,
      required this.absNipas,
      required this.absDivisi,
      required this.absStatus,
      required this.absAlasan,
      this.absTransportasi,
      this.absKondisi,
      required this.absJenis,
      this.absLatitude,
      this.absLongitude,
      this.absDoc,
      this.absDocName,
      this.absDocType,
      this.absDocSize,
      this.absDocMime,
      this.absUsrnam,
      this.absUsrdat,
      this.absSuhu,
      this.absAddress,
      this.absOther,
      this.divisiid,
      this.absZona,
      this.absDateAbsen,
      this.absKegiatan});

  factory AbsenModel.fromJson(Map<String, dynamic> json) {
    return AbsenModel(
        absIdents: json["abs_idents"],
        absNipas: json["abs_nipas"],
        absDivisi: json["abs_divisi"],
        absStatus: json["abs_status"],
        absAlasan: json["abs_alasan"],
        absTransportasi: json["abs_transportasi"],
        absKondisi: json["abs_kondisi"],
        absJenis: json["abs_jenis"],
        absLatitude: json["abs_latitude"],
        absLongitude: json["abs_longitude"],
        absDoc: json["abs_doc"],
        absDocName: json["abs_doc_name"],
        absDocType: json["abs_doc_type"],
        absDocSize: json["abs_doc_size"],
        absDocMime: json["abs_doc_mime"],
        absUsrnam: json["abs_usrnam"],
        absUsrdat: json["abs_usrdat"],
        absSuhu: json["abs_suhu"],
        absAddress: json["abs_address"],
        absOther: json["abs_other"],
        divisiid: json["divisiid"],
        absZona: json["abs_zona"],
        absDateAbsen: json["abs_date_absen"],
        absKegiatan: json["abs_kegiatan"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "abs_idents": absIdents,
      "abs_nipas": absNipas,
      "abs_divisi": absDivisi,
      "abs_status": absStatus,
      "abs_alasan": absAlasan,
      "abs_transportasi": absTransportasi,
      "abs_kondisi": absKondisi,
      "abs_jenis": absJenis,
      "abs_latitude": absLatitude,
      "abs_longitude": absLongitude,
      "abs_doc": absDoc,
      "abs_doc_name": absDocName,
      "abs_doc_type": absDocType,
      "abs_doc_size": absDocSize,
      "abs_doc_mime": absDocMime,
      "abs_usrnam": absUsrnam,
      "abs_usrdat": absUsrdat,
      "abs_suhu": absSuhu,
      "abs_address": absAddress,
      "abs_other": absOther,
      "divisiid": divisiid,
      "abs_zona": absZona,
      "abs_date_absen": absDateAbsen,
      "abs_kegiatan": absKegiatan
    };
  }
}
