class RekapAbsen {
  RekapAbsen({
    this.totalRows,
    this.data,
  });

  int? totalRows;
  List<HistoriAbsen>? data;

  factory RekapAbsen.fromJson(Map<String, dynamic> json) => RekapAbsen(
        totalRows: json["totalRows"],
        data: List<HistoriAbsen>.from(
            json["data"].map((x) => HistoriAbsen.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalRows": totalRows,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class HistoriAbsen {
  HistoriAbsen({
    this.absIdents,
    this.absUsrnam,
    this.waktu,
    this.jenisAbsen,
    this.absUsrdat,
    this.absAddress,
  });

  int? absIdents;
  String? absUsrnam;
  String? waktu;
  String? jenisAbsen;
  String? absUsrdat;
  String? absAddress;

  factory HistoriAbsen.fromJson(Map<String, dynamic> json) => HistoriAbsen(
        absIdents: json["absIdents"],
        absUsrnam: json["absUsrnam"],
        waktu: json["waktu"],
        jenisAbsen: json["jenisAbsen"],
        absUsrdat: json["absUsrdat"],
        absAddress: json["absAddress"],
      );

  Map<String, dynamic> toJson() => {
        "absIdents": absIdents,
        "absUsrnam": absUsrnam,
        "waktu": waktu,
        "jenisAbsen": jenisAbsen,
        "absUsrdat": absUsrdat,
        "absAddress": absAddress,
      };
}
