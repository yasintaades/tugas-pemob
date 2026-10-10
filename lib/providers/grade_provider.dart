import 'package:flutter/material.dart';
import '../models/student_grade_model.dart';
import '../services/api_service.dart';

class GradeProvider extends ChangeNotifier {
  // State Daftar Nilai Mahasiswa
  List<StudentGrade> _gradeList = [
    StudentGrade.calculate(
      id: '1',
      nim: '20230801033',
      nama: 'Yasinta Desty Natalia',
      mataKuliah: 'Pemrograman Mobile',
      nilaiKehadiran: 95.0,
      nilaiTugas: 92.0,
      nilaiUTS: 88.0,
      nilaiUAS: 94.0,
    ),
    StudentGrade.calculate(
      id: '2',
      nim: '2110512014',
      nama: 'Siti Nurhaliza',
      mataKuliah: 'Pemrograman Mobile',
      nilaiKehadiran: 90.0,
      nilaiTugas: 82.0,
      nilaiUTS: 78.0,
      nilaiUAS: 84.0,
    ),
    StudentGrade.calculate(
      id: '3',
      nim: '2110512028',
      nama: 'Budi Santoso',
      mataKuliah: 'Pemrograman Mobile',
      nilaiKehadiran: 75.0,
      nilaiTugas: 65.0,
      nilaiUTS: 60.0,
      nilaiUAS: 50.0,
    ),
  ];

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool get isBackendConnected => ApiService.instance.isConnected;

  GradeProvider() {
    loadGradesFromBackend();
  }

  // Mengambil data nilai dari .NET Backend API (yang terhubung ke PostgreSQL)
  Future<void> loadGradesFromBackend() async {
    _isLoading = true;
    notifyListeners();

    try {
      final grades = await ApiService.instance.getGrades();
      if (grades.isNotEmpty) {
        _gradeList = grades;
      }
    } catch (e) {
      debugPrint('Fallback in-memory grade: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<StudentGrade> get gradeList => List.unmodifiable(_gradeList);

  int get totalMahasiswa => _gradeList.length;

  int get jumlahLulus =>
      _gradeList.where((item) => item.status == 'LULUS').length;

  int get jumlahTidakLulus =>
      _gradeList.where((item) => item.status == 'TIDAK LULUS').length;

  double get rataRataNilai {
    if (_gradeList.isEmpty) return 0.0;
    final total = _gradeList.fold<double>(
        0.0, (previousValue, element) => previousValue + element.nilaiAkhir);
    return total / _gradeList.length;
  }

  // Tambah Nilai Baru (State + POST ke .NET Backend)
  void addGrade({
    required String nim,
    required String nama,
    required String mataKuliah,
    required double nilaiKehadiran,
    required double nilaiTugas,
    required double nilaiUTS,
    required double nilaiUAS,
  }) {
    final newGrade = StudentGrade.calculate(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nim: nim,
      nama: nama,
      mataKuliah: mataKuliah,
      nilaiKehadiran: nilaiKehadiran,
      nilaiTugas: nilaiTugas,
      nilaiUTS: nilaiUTS,
      nilaiUAS: nilaiUAS,
    );

    _gradeList.insert(0, newGrade);
    notifyListeners();

    // Kirim ke .NET Web API
    ApiService.instance.saveGrade(newGrade);
  }

  // Hapus Nilai (State + DELETE ke .NET Backend)
  void deleteGrade(String id) {
    _gradeList.removeWhere((item) => item.id == id);
    notifyListeners();

    // Hapus di .NET Web API
    ApiService.instance.deleteGrade(id);
  }

  void clearAll() {
    _gradeList.clear();
    notifyListeners();
  }
}
