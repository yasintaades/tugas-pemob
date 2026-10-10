import 'package:flutter/material.dart';
import '../models/biodata_model.dart';
import '../services/api_service.dart';

class BiodataProvider extends ChangeNotifier {
  // State Biodata Mahasiswa default (Yasinta Desty Natalia - Universitas Esa Unggul)
  BiodataMahasiswa _biodata = BiodataMahasiswa(
    namaLengkap: 'Yasinta Desty Natalia',
    namaPanggilan: 'Sinta',
    nim: '20230801033',
    tempatTanggalLahir: 'Jakarta, 15 Januari 2003',
    jenisKelamin: 'Perempuan',
    agama: 'Kristen',
    alamat: 'Jl. Merdeka No. 45, Kebayoran Baru, Jakarta Selatan',
    email: 'harahapyasinta@student.esaunggul.ac.id',
    noHp: '0812-3456-7890',
    statusMahasiswa: 'Aktif (Semester 7)',
    pendidikan: [
      EducationItem(
        jenjang: 'Perguruan Tinggi',
        namaInstitusi: 'Universitas Esa Unggul',
        jurusan: 'S1 Teknik Informatika',
        periode: '2023 - Sekarang',
        nilaiAkhir: 'IPK 3.99',
      ),
      EducationItem(
        jenjang: 'SMA / SMK',
        namaInstitusi: 'SMAN 28 Jakarta',
        jurusan: 'MIPA',
        periode: '2020 - 2023',
        nilaiAkhir: 'Nilai Rata-rata: 98.5',
      ),
      EducationItem(
        jenjang: 'SMP',
        namaInstitusi: 'SMPN 115 Jakarta',
        jurusan: 'Umum',
        periode: '2017 - 2020',
        nilaiAkhir: 'Nilai UN: 372.0',
      ),
      EducationItem(
        jenjang: 'SD',
        namaInstitusi: 'SDN Menteng 01',
        jurusan: 'Umum',
        periode: '2011 - 2017',
        nilaiAkhir: 'Lulus',
      ),
    ],
    pekerjaan: [
      WorkExperienceItem(
        posisi: 'Mobile Flutter Developer Intern',
        perusahaan: 'PT Teknologi Nusantara Solusindo',
        periode: 'Februari 2024 - Juli 2024',
        tipe: 'Magang (Internship)',
        deskripsi:
            'Mengembangkan fitur autentikasi, integrasi REST API, dan modul katalog produk menggunakan Flutter & Provider.',
      ),
      WorkExperienceItem(
        posisi: 'Freelance UI/UX & Flutter Developer',
        perusahaan: 'Self-employed / Upwork',
        periode: 'Agustus 2023 - Sekarang',
        tipe: 'Freelance',
        deskripsi:
            'Mendesain wireframe, mockup aplikasi Android/iOS, serta mengimplementasikan slicing code Flutter.',
      ),
    ],
    organisasi: [
      OrganizationItem(
        namaOrganisasi: 'Himpunan Mahasiswa Informatika (HIMATIF)',
        jabatan: 'Ketua Divisi Penelitian & Pengembangan (Litbang)',
        periode: '2023 - 2024',
        peran:
            'Memimpin workshop mobile development dan mengoordinasikan bootcamp coding untuk 120+ anggota.',
      ),
      OrganizationItem(
        namaOrganisasi: 'Google Developer Student Clubs (GDSC)',
        jabatan: 'Core Team - Flutter Specialist',
        periode: '2022 - 2023',
        peran:
            'Menjadi pemateri workshop dasar Flutter dan membimbing peserta dalam pembuatan submission aplikasi.',
      ),
      OrganizationItem(
        namaOrganisasi: 'BEM Fakultas Ilmu Komputer',
        jabatan: 'Staff Departemen Hubungan Masyarakat',
        periode: '2021 - 2022',
        peran:
            'Menjalin kerja sama sponsor dengan 5 institusi luar dan mengelola media publikasi acara fakultas.',
      ),
    ],
  );

  BiodataMahasiswa get biodata => _biodata;

  BiodataProvider() {
    loadBiodataFromBackend();
  }

  Future<void> loadBiodataFromBackend() async {
    try {
      final backendBio = await ApiService.instance.getBiodata();
      if (backendBio != null) {
        _biodata = backendBio;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Fallback in-memory biodata: $e');
    }
  }

  void updatePersonalData({
    required String namaLengkap,
    required String namaPanggilan,
    required String nim,
    required String tempatTanggalLahir,
    required String jenisKelamin,
    required String agama,
    required String alamat,
    required String email,
    required String noHp,
  }) {
    _biodata.namaLengkap = namaLengkap;
    _biodata.namaPanggilan = namaPanggilan;
    _biodata.nim = nim;
    _biodata.tempatTanggalLahir = tempatTanggalLahir;
    _biodata.jenisKelamin = jenisKelamin;
    _biodata.agama = agama;
    _biodata.alamat = alamat;
    _biodata.email = email;
    _biodata.noHp = noHp;

    notifyListeners();

    // Kirim update ke .NET Web API
    ApiService.instance.updateBiodata(_biodata);
  }
}
