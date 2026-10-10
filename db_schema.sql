-- Schema Database Pemob Mahasiswa (PostgreSQL)
-- Database: pemob_db

CREATE TABLE IF NOT EXISTS biodata (
    nim VARCHAR(30) PRIMARY KEY,
    nama_lengkap VARCHAR(150),
    nama_panggilan VARCHAR(50),
    tempat_tanggal_lahir VARCHAR(100),
    jenis_kelamin VARCHAR(20),
    agama VARCHAR(50),
    alamat TEXT,
    email VARCHAR(100),
    no_hp VARCHAR(30),
    status_mahasiswa VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS pendidikan (
    id SERIAL PRIMARY KEY,
    nim VARCHAR(30) REFERENCES biodata(nim) ON DELETE CASCADE,
    jenjang VARCHAR(50),
    nama_institusi VARCHAR(150),
    jurusan VARCHAR(100),
    periode VARCHAR(50),
    nilai_akhir VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS pekerjaan (
    id SERIAL PRIMARY KEY,
    nim VARCHAR(30) REFERENCES biodata(nim) ON DELETE CASCADE,
    posisi VARCHAR(100),
    perusahaan VARCHAR(150),
    periode VARCHAR(50),
    tipe VARCHAR(50),
    deskripsi TEXT
);

CREATE TABLE IF NOT EXISTS organisasi (
    id SERIAL PRIMARY KEY,
    nim VARCHAR(30) REFERENCES biodata(nim) ON DELETE CASCADE,
    nama_organisasi VARCHAR(150),
    jabatan VARCHAR(100),
    periode VARCHAR(50),
    peran TEXT
);

CREATE TABLE IF NOT EXISTS nilai_mahasiswa (
    id VARCHAR(50) PRIMARY KEY,
    nim VARCHAR(30),
    nama VARCHAR(150),
    mata_kuliah VARCHAR(100),
    nilai_kehadiran NUMERIC(5,2),
    nilai_tugas NUMERIC(5,2),
    nilai_uts NUMERIC(5,2),
    nilai_uas NUMERIC(5,2),
    nilai_akhir NUMERIC(5,2),
    grade VARCHAR(5),
    status VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS user_profile (
    nim VARCHAR(30) PRIMARY KEY,
    nama VARCHAR(150),
    email VARCHAR(100),
    program_studi VARCHAR(100),
    fakultas VARCHAR(100),
    universitas VARCHAR(150),
    semester VARCHAR(50),
    ipk NUMERIC(4,2),
    sks_lulus INT,
    avatar_url TEXT
);

-- Seed Data: Biodata Yasinta Desty Natalia
INSERT INTO biodata (nim, nama_lengkap, nama_panggilan, tempat_tanggal_lahir, jenis_kelamin, agama, alamat, email, no_hp, status_mahasiswa)
VALUES (
    '20230801033',
    'Yasinta Desty Natalia',
    'Sinta',
    'Jakarta, 15 Januari 2003',
    'Perempuan',
    'Kristen',
    'Jl. Merdeka No. 45, Kebayoran Baru, Jakarta Selatan',
    'harahapyasinta@student.esaunggul.ac.id',
    '0812-3456-7890',
    'Aktif (Semester 7)'
) ON CONFLICT (nim) DO UPDATE SET 
    nama_lengkap = EXCLUDED.nama_lengkap,
    email = EXCLUDED.email;

-- Seed Data: Pendidikan
DELETE FROM pendidikan WHERE nim = '20230801033';
INSERT INTO pendidikan (nim, jenjang, nama_institusi, jurusan, periode, nilai_akhir) VALUES
('20230801033', 'Perguruan Tinggi', 'Universitas Esa Unggul', 'S1 Teknik Informatika', '2023 - Sekarang', 'IPK 3.99'),
('20230801033', 'SMA / SMK', 'SMAN 28 Jakarta', 'MIPA', '2020 - 2023', 'Nilai Rata-rata: 98.5'),
('20230801033', 'SMP', 'SMPN 115 Jakarta', 'Umum', '2017 - 2020', 'Nilai UN: 372.0'),
('20230801033', 'SD', 'SDN Menteng 01', 'Umum', '2011 - 2017', 'Lulus');

-- Seed Data: Pekerjaan
DELETE FROM pekerjaan WHERE nim = '20230801033';
INSERT INTO pekerjaan (nim, posisi, perusahaan, periode, tipe, deskripsi) VALUES
('20230801033', 'Mobile Flutter Developer Intern', 'PT Teknologi Nusantara Solusindo', 'Februari 2024 - Juli 2024', 'Magang (Internship)', 'Mengembangkan fitur autentikasi, integrasi REST API, dan modul katalog produk menggunakan Flutter & Provider.'),
('20230801033', 'Freelance UI/UX & Flutter Developer', 'Self-employed / Upwork', 'Agustus 2023 - Sekarang', 'Freelance', 'Mendesain wireframe, mockup aplikasi Android/iOS, serta mengimplementasikan slicing code Flutter.');

-- Seed Data: Organisasi
DELETE FROM organisasi WHERE nim = '20230801033';
INSERT INTO organisasi (nim, nama_organisasi, jabatan, periode, peran) VALUES
('20230801033', 'Himpunan Mahasiswa Informatika (HIMATIF)', 'Ketua Divisi Penelitian & Pengembangan (Litbang)', '2023 - 2024', 'Memimpin workshop mobile development dan mengoordinasikan bootcamp coding untuk 120+ anggota.'),
('20230801033', 'Google Developer Student Clubs (GDSC)', 'Core Team - Flutter Specialist', '2022 - 2023', 'Menjadi pemateri workshop dasar Flutter dan membimbing peserta dalam pembuatan submission aplikasi.'),
('20230801033', 'BEM Fakultas Ilmu Komputer', 'Staff Departemen Hubungan Masyarakat', '2021 - 2022', 'Menjalin kerja sama sponsor dengan 5 institusi luar dan mengelola media publikasi acara fakultas.');

-- Seed Data: Nilai Mahasiswa
DELETE FROM nilai_mahasiswa WHERE id IN ('1', '2', '3');
INSERT INTO nilai_mahasiswa (id, nim, nama, mata_kuliah, nilai_kehadiran, nilai_tugas, nilai_uts, nilai_uas, nilai_akhir, grade, status) VALUES
('1', '20230801033', 'Yasinta Desty Natalia', 'Pemrograman Mobile', 95.0, 92.0, 88.0, 94.0, 92.50, 'A', 'LULUS'),
('2', '2110512014', 'Siti Nurhaliza', 'Pemrograman Mobile', 90.0, 82.0, 78.0, 84.0, 82.40, 'A-', 'LULUS'),
('3', '2110512028', 'Budi Santoso', 'Pemrograman Mobile', 75.0, 65.0, 60.0, 50.0, 58.50, 'C', 'LULUS');

-- Seed Data: User Profile
INSERT INTO user_profile (nim, nama, email, program_studi, fakultas, universitas, semester, ipk, sks_lulus, avatar_url)
VALUES (
    '20230801033',
    'Yasinta Desty Natalia',
    'harahapyasinta@student.esaunggul.ac.id',
    'S1 Teknik Informatika',
    'Fakultas Ilmu Komputer',
    'Universitas Esa Unggul',
    'Semester 7 (Ganjil)',
    3.99,
    132,
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=400&q=80'
) ON CONFLICT (nim) DO UPDATE SET 
    nama = EXCLUDED.nama,
    email = EXCLUDED.email,
    universitas = EXCLUDED.universitas;
