class EducationItem {
  final String jenjang; // SD, SMP, SMA/SMK, Perguruan Tinggi
  final String namaInstitusi;
  final String jurusan;
  final String periode;
  final String nilaiAkhir;

  EducationItem({
    required this.jenjang,
    required this.namaInstitusi,
    required this.jurusan,
    required this.periode,
    required this.nilaiAkhir,
  });
}

class WorkExperienceItem {
  final String posisi;
  final String perusahaan;
  final String periode;
  final String tipe; // Magang, Full-time, Freelance
  final String deskripsi;

  WorkExperienceItem({
    required this.posisi,
    required this.perusahaan,
    required this.periode,
    required this.tipe,
    required this.deskripsi,
  });
}

class OrganizationItem {
  final String namaOrganisasi;
  final String jabatan;
  final String periode;
  final String peran;

  OrganizationItem({
    required this.namaOrganisasi,
    required this.jabatan,
    required this.periode,
    required this.peran,
  });
}

class BiodataMahasiswa {
  // 1. Biodata Pribadi
  String namaLengkap;
  String namaPanggilan;
  String nim;
  String tempatTanggalLahir;
  String jenisKelamin;
  String agama;
  String alamat;
  String email;
  String noHp;
  String statusMahasiswa;

  // 2. Riwayat Pendidikan
  List<EducationItem> pendidikan;

  // 3. Pengalaman Kerja / Magang
  List<WorkExperienceItem> pekerjaan;

  // 4. Pengalaman Organisasi
  List<OrganizationItem> organisasi;

  BiodataMahasiswa({
    required this.namaLengkap,
    required this.namaPanggilan,
    required this.nim,
    required this.tempatTanggalLahir,
    required this.jenisKelamin,
    required this.agama,
    required this.alamat,
    required this.email,
    required this.noHp,
    required this.statusMahasiswa,
    required this.pendidikan,
    required this.pekerjaan,
    required this.organisasi,
  });
}
