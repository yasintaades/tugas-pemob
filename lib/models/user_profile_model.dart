class UserProfile {
  String nama;
  String nim;
  String email;
  String programStudi;
  String fakultas;
  String universitas;
  String semester;
  String avatarUrl;
  double ipk;
  int sksLulus;

  UserProfile({
    required this.nama,
    required this.nim,
    required this.email,
    required this.programStudi,
    required this.fakultas,
    required this.universitas,
    required this.semester,
    required this.avatarUrl,
    required this.ipk,
    required this.sksLulus,
  });

  UserProfile copyWith({
    String? nama,
    String? nim,
    String? email,
    String? programStudi,
    String? fakultas,
    String? universitas,
    String? semester,
    String? avatarUrl,
    double? ipk,
    int? sksLulus,
  }) {
    return UserProfile(
      nama: nama ?? this.nama,
      nim: nim ?? this.nim,
      email: email ?? this.email,
      programStudi: programStudi ?? this.programStudi,
      fakultas: fakultas ?? this.fakultas,
      universitas: universitas ?? this.universitas,
      semester: semester ?? this.semester,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      ipk: ipk ?? this.ipk,
      sksLulus: sksLulus ?? this.sksLulus,
    );
  }
}
