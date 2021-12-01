class UserModel {
    UserModel({
        required this.statuses,
        required this.user,
        required this.token,
    });

    String statuses;
    User user;
    String token;

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        statuses: json["statuses"],
        user: User.fromJson(json["user"]),
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "statuses": statuses,
        "user": user.toJson(),
        "token": token,
    };
}

class User {
    User({
        required this.id,
        required this.name,
        required this.nip,
        required this.divisi,
        required this.username,
        required this.divisiid,
        required this.password,
        required this.createdAt,
        required this.updatedAt,
    });

    int id;
    String name;
    String nip;
    String divisi;
    String username;
    int divisiid;
    String password;
    DateTime createdAt;
    DateTime updatedAt;

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        nip: json["nip"],
        divisi: json["divisi"],
        username: json["username"],
        divisiid: json["divisiid"],
        password: json["password"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "nip": nip,
        "divisi": divisi,
        "username": username,
        "divisiid": divisiid,
        "password": password,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}
