import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/biodata_model.dart';
import '../models/student_grade_model.dart';
import '../models/user_profile_model.dart';

class ApiService {
  static final ApiService instance = ApiService._internal();
  ApiService._internal();

  // Menyesuaikan host backend .NET Web API secara otomatis:
  // - HP Fisik Android (Realme): IP Wi-Fi laptop (192.168.0.41:5050)
  // - Emulator Android: 10.0.2.2:5050
  // - Chrome Web / Desktop: localhost:5050
  static String get defaultBaseUrl {
    if (kIsWeb) return 'http://localhost:5050';
    if (Platform.isAndroid) {
      return 'http://192.168.0.41:5050';
    }
    return 'http://localhost:5050';
  }

  String baseUrl = defaultBaseUrl;
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  // ==========================================
  // 1. BIODATA MAHASISWA (MENU 1)
  // ==========================================

  Future<BiodataMahasiswa?> getBiodata() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/api/biodata'))
          .timeout(const Duration(seconds: 4));

      if (res.statusCode == 200) {
        _isConnected = true;
        final data = jsonDecode(res.body);

        final listEdu = (data['pendidikan'] as List? ?? []).map((e) {
          return EducationItem(
            jenjang: e['jenjang']?.toString() ?? '',
            namaInstitusi: e['nama_institusi']?.toString() ?? '',
            jurusan: e['jurusan']?.toString() ?? '',
            periode: e['periode']?.toString() ?? '',
            nilaiAkhir: e['nilai_akhir']?.toString() ?? '',
          );
        }).toList();

        final listWork = (data['pekerjaan'] as List? ?? []).map((w) {
          return WorkExperienceItem(
            posisi: w['posisi']?.toString() ?? '',
            perusahaan: w['perusahaan']?.toString() ?? '',
            periode: w['periode']?.toString() ?? '',
            tipe: w['tipe']?.toString() ?? '',
            deskripsi: w['deskripsi']?.toString() ?? '',
          );
        }).toList();

        final listOrg = (data['organisasi'] as List? ?? []).map((o) {
          return OrganizationItem(
            namaOrganisasi: o['nama_organisasi']?.toString() ?? '',
            jabatan: o['jabatan']?.toString() ?? '',
            periode: o['periode']?.toString() ?? '',
            peran: o['peran']?.toString() ?? '',
          );
        }).toList();

        return BiodataMahasiswa(
          nim: data['nim']?.toString() ?? '20230801033',
          namaLengkap: data['namaLengkap']?.toString() ?? 'Yasinta Desty Natalia',
          namaPanggilan: data['namaPanggilan']?.toString() ?? 'Sinta',
          tempatTanggalLahir: data['tempatTanggalLahir']?.toString() ?? 'Jakarta, 15 Januari 2003',
          jenisKelamin: data['jenisKelamin']?.toString() ?? 'Perempuan',
          agama: data['agama']?.toString() ?? 'Kristen',
          alamat: data['alamat']?.toString() ?? '',
          email: data['email']?.toString() ?? 'harahapyasinta@student.esaunggul.ac.id',
          noHp: data['noHp']?.toString() ?? '0812-3456-7890',
          statusMahasiswa: data['statusMahasiswa']?.toString() ?? 'Aktif (Semester 7)',
          pendidikan: listEdu,
          pekerjaan: listWork,
          organisasi: listOrg,
        );
      }
    } catch (e) {
      _isConnected = false;
      debugPrint('ApiService getBiodata error: $e');
    }
    return null;
  }

  Future<bool> updateBiodata(BiodataMahasiswa bio) async {
    try {
      final res = await http.put(
        Uri.parse('$baseUrl/api/biodata'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nim': bio.nim,
          'namaLengkap': bio.namaLengkap,
          'namaPanggilan': bio.namaPanggilan,
          'tempatTanggalLahir': bio.tempatTanggalLahir,
          'jenisKelamin': bio.jenisKelamin,
          'agama': bio.agama,
          'alamat': bio.alamat,
          'email': bio.email,
          'noHp': bio.noHp,
        }),
      ).timeout(const Duration(seconds: 4));

      return res.statusCode == 200;
    } catch (e) {
      debugPrint('ApiService updateBiodata error: $e');
      return false;
    }
  }

  // ==========================================
  // 2. NILAI MAHASISWA (MENU 2)
  // ==========================================

  Future<List<StudentGrade>> getGrades() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/api/nilai'))
          .timeout(const Duration(seconds: 4));

      if (res.statusCode == 200) {
        _isConnected = true;
        final list = jsonDecode(res.body) as List;
        return list.map((item) {
          return StudentGrade(
            id: item['id']?.toString() ?? '',
            nim: item['nim']?.toString() ?? '',
            nama: item['nama']?.toString() ?? '',
            mataKuliah: item['mataKuliah']?.toString() ?? '',
            nilaiKehadiran: double.tryParse(item['nilaiKehadiran'].toString()) ?? 0,
            nilaiTugas: double.tryParse(item['nilaiTugas'].toString()) ?? 0,
            nilaiUTS: double.tryParse(item['nilaiUTS'].toString()) ?? 0,
            nilaiUAS: double.tryParse(item['nilaiUAS'].toString()) ?? 0,
            nilaiAkhir: double.tryParse(item['nilaiAkhir'].toString()) ?? 0,
            grade: item['grade']?.toString() ?? 'E',
            status: item['status']?.toString() ?? 'TIDAK LULUS',
          );
        }).toList();
      }
    } catch (e) {
      _isConnected = false;
      debugPrint('ApiService getGrades error: $e');
    }
    return [];
  }

  Future<bool> saveGrade(StudentGrade grade) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/api/nilai'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': grade.id,
          'nim': grade.nim,
          'nama': grade.nama,
          'mataKuliah': grade.mataKuliah,
          'nilaiKehadiran': grade.nilaiKehadiran,
          'nilaiTugas': grade.nilaiTugas,
          'nilaiUTS': grade.nilaiUTS,
          'nilaiUAS': grade.nilaiUAS,
        }),
      ).timeout(const Duration(seconds: 4));

      return res.statusCode == 200;
    } catch (e) {
      debugPrint('ApiService saveGrade error: $e');
      return false;
    }
  }

  Future<bool> deleteGrade(String id) async {
    try {
      final res = await http
          .delete(Uri.parse('$baseUrl/api/nilai/$id'))
          .timeout(const Duration(seconds: 4));
      return res.statusCode == 200;
    } catch (e) {
      debugPrint('ApiService deleteGrade error: $e');
      return false;
    }
  }

  // ==========================================
  // 3. PROFIL PENGGUNA (MENU 3)
  // ==========================================

  Future<UserProfile?> getProfile() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/api/profile'))
          .timeout(const Duration(seconds: 4));

      if (res.statusCode == 200) {
        _isConnected = true;
        final data = jsonDecode(res.body);
        return UserProfile(
          nim: data['nim']?.toString() ?? '20230801033',
          nama: data['nama']?.toString() ?? 'Yasinta Desty Natalia',
          email: data['email']?.toString() ?? 'harahapyasinta@student.esaunggul.ac.id',
          programStudi: data['programStudi']?.toString() ?? 'S1 Teknik Informatika',
          fakultas: data['fakultas']?.toString() ?? 'Fakultas Ilmu Komputer',
          universitas: data['universitas']?.toString() ?? 'Universitas Esa Unggul',
          semester: data['semester']?.toString() ?? 'Semester 7 (Ganjil)',
          ipk: double.tryParse(data['ipk'].toString()) ?? 3.99,
          sksLulus: int.tryParse(data['sksLulus'].toString()) ?? 132,
          avatarUrl: data['avatarUrl']?.toString() ?? 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=400&q=80',
        );
      }
    } catch (e) {
      _isConnected = false;
      debugPrint('ApiService getProfile error: $e');
    }
    return null;
  }

  Future<bool> updateProfile(UserProfile profile) async {
    try {
      final res = await http.put(
        Uri.parse('$baseUrl/api/profile'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nim': profile.nim,
          'nama': profile.nama,
          'email': profile.email,
          'programStudi': profile.programStudi,
          'fakultas': profile.fakultas,
          'universitas': profile.universitas,
          'semester': profile.semester,
        }),
      ).timeout(const Duration(seconds: 4));

      return res.statusCode == 200;
    } catch (e) {
      debugPrint('ApiService updateProfile error: $e');
      return false;
    }
  }
}
