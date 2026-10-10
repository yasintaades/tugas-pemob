import 'package:flutter/material.dart';
import '../models/user_profile_model.dart';
import '../services/api_service.dart';

class ProfileProvider extends ChangeNotifier {
  // State Profil Pengguna (Yasinta Desty Natalia - Universitas Esa Unggul)
  UserProfile _userProfile = UserProfile(
    nama: 'Yasinta Desty Natalia',
    nim: '20230801033',
    email: 'harahapyasinta@student.esaunggul.ac.id',
    programStudi: 'S1 Teknik Informatika',
    fakultas: 'Fakultas Ilmu Komputer',
    universitas: 'Universitas Esa Unggul',
    semester: 'Semester 7 (Ganjil)',
    avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=400&q=80',
    ipk: 3.99,
    sksLulus: 132,
  );

  ThemeMode _themeMode = ThemeMode.light;

  UserProfile get userProfile => _userProfile;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ProfileProvider() {
    loadProfileFromBackend();
  }

  Future<void> loadProfileFromBackend() async {
    try {
      final backendProfile = await ApiService.instance.getProfile();
      if (backendProfile != null) {
        _userProfile = backendProfile;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Fallback in-memory profile: $e');
    }
  }

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void updateProfile({
    required String nama,
    required String email,
    required String programStudi,
    required String fakultas,
    required String universitas,
    required String semester,
  }) {
    _userProfile = _userProfile.copyWith(
      nama: nama,
      email: email,
      programStudi: programStudi,
      fakultas: fakultas,
      universitas: universitas,
      semester: semester,
    );
    notifyListeners();

    // Kirim update ke .NET Web API
    ApiService.instance.updateProfile(_userProfile);
  }
}
