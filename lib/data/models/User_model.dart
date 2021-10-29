class User {
  final String? nama;
  final String nipas;
  final String divisi;
  final String username;
  final int divisiid;

  User({
    this.nama,
    required this.nipas,
    required this.divisi,
    required this.username,
    required this.divisiid,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nama: json['nama'],
      nipas: json['nipas'],
      divisi: json['divisi'],
      username: json['username'],
      divisiid: json['divisiId'],
    );
  }
}
