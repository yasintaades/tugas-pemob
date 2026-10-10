class StudentGrade {
  final String id;
  final String nim;
  final String nama;
  final String mataKuliah;
  final double nilaiKehadiran;
  final double nilaiTugas;
  final double nilaiUTS;
  final double nilaiUAS;
  final double nilaiAkhir;
  final String grade;
  final String status; // "LULUS" atau "TIDAK LULUS"

  StudentGrade({
    required this.id,
    required this.nim,
    required this.nama,
    required this.mataKuliah,
    required this.nilaiKehadiran,
    required this.nilaiTugas,
    required this.nilaiUTS,
    required this.nilaiUAS,
    required this.nilaiAkhir,
    required this.grade,
    required this.status,
  });

  // Helper kalkulasi otomatis nilai akhir dan grade
  static StudentGrade calculate({
    required String id,
    required String nim,
    required String nama,
    required String mataKuliah,
    required double nilaiKehadiran,
    required double nilaiTugas,
    required double nilaiUTS,
    required double nilaiUAS,
  }) {
    // Formula umum perkuliahan:
    // 10% Kehadiran + 20% Tugas + 30% UTS + 40% UAS
    final double akhir = (nilaiKehadiran * 0.10) +
        (nilaiTugas * 0.20) +
        (nilaiUTS * 0.30) +
        (nilaiUAS * 0.40);

    String grade;
    if (akhir >= 85) {
      grade = 'A';
    } else if (akhir >= 80) {
      grade = 'A-';
    } else if (akhir >= 75) {
      grade = 'B+';
    } else if (akhir >= 70) {
      grade = 'B';
    } else if (akhir >= 65) {
      grade = 'B-';
    } else if (akhir >= 60) {
      grade = 'C+';
    } else if (akhir >= 55) {
      grade = 'C';
    } else if (akhir >= 40) {
      grade = 'D';
    } else {
      grade = 'E';
    }

    final String status = akhir >= 55 ? 'LULUS' : 'TIDAK LULUS';

    return StudentGrade(
      id: id,
      nim: nim,
      nama: nama,
      mataKuliah: mataKuliah,
      nilaiKehadiran: nilaiKehadiran,
      nilaiTugas: nilaiTugas,
      nilaiUTS: nilaiUTS,
      nilaiUAS: nilaiUAS,
      nilaiAkhir: akhir,
      grade: grade,
      status: status,
    );
  }
}
