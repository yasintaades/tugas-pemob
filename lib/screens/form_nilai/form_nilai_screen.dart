import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/grade_provider.dart';
import 'components/nilai_list_item.dart';

class FormNilaiScreen extends StatefulWidget {
  const FormNilaiScreen({super.key});

  @override
  State<FormNilaiScreen> createState() => _FormNilaiScreenState();
}

class _FormNilaiScreenState extends State<FormNilaiScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  // Text Editing Controllers
  final _nimController = TextEditingController(text: '20230801033');
  final _namaController = TextEditingController(text: 'Yasinta Desty Natalia');
  final _matkulController = TextEditingController(text: 'Pemrograman Mobile');
  final _absenController = TextEditingController();
  final _tugasController = TextEditingController();
  final _utsController = TextEditingController();
  final _uasController = TextEditingController();

  // Search filter for ListView
  String _searchQuery = '';

  // Preset Mata Kuliah Informatika Esa Unggul
  final List<String> _daftarMatkul = [
    'Pemrograman Mobile',
    'Pemrograman Web Lanjut',
    'Basis Data Terdistribusi',
    'Rekayasa Perangkat Lunak',
    'Kecerdasan Buatan',
    'Jaringan Komputer',
    'Keamanan Informasi',
    'Interaksi Manusia dan Komputer',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nimController.dispose();
    _namaController.dispose();
    _matkulController.dispose();
    _absenController.dispose();
    _tugasController.dispose();
    _utsController.dispose();
    _uasController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nimController.clear();
    _namaController.clear();
    _absenController.clear();
    _tugasController.clear();
    _utsController.clear();
    _uasController.clear();
    setState(() {});
  }

  // Kalkulasi live preview
  double _calculateLiveTotal() {
    final absen = double.tryParse(_absenController.text.trim()) ?? 0;
    final tugas = double.tryParse(_tugasController.text.trim()) ?? 0;
    final uts = double.tryParse(_utsController.text.trim()) ?? 0;
    final uas = double.tryParse(_uasController.text.trim()) ?? 0;
    return (absen * 0.10) + (tugas * 0.20) + (uts * 0.30) + (uas * 0.40);
  }

  String _calculateLiveGrade(double total) {
    if (total >= 85) return 'A';
    if (total >= 80) return 'A-';
    if (total >= 75) return 'B+';
    if (total >= 70) return 'B';
    if (total >= 65) return 'B-';
    if (total >= 60) return 'C+';
    if (total >= 55) return 'C';
    if (total >= 40) return 'D';
    return 'E';
  }

  void _submitNilai(GradeProvider provider) {
    if (_formKey.currentState!.validate()) {
      final double absen = double.tryParse(_absenController.text.trim()) ?? 0;
      final double tugas = double.tryParse(_tugasController.text.trim()) ?? 0;
      final double uts = double.tryParse(_utsController.text.trim()) ?? 0;
      final double uas = double.tryParse(_uasController.text.trim()) ?? 0;

      provider.addGrade(
        nim: _nimController.text.trim(),
        nama: _namaController.text.trim(),
        mataKuliah: _matkulController.text.trim(),
        nilaiKehadiran: absen,
        nilaiTugas: tugas,
        nilaiUTS: uts,
        nilaiUAS: uas,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nilai ${_namaController.text} berhasil ditambahkan!'),
          backgroundColor: const Color(0xFF0D9488),
          behavior: SnackBarBehavior.floating,
        ),
      );

      _resetForm();
      _tabController.animateTo(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer<GradeProvider>(
      builder: (context, gradeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Form & Nilai Mahasiswa',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Kalkulasi Otomatis • State Management',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Container(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFF0F2B48),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: const Color(0xFFEAB308),
                  indicatorWeight: 3,
                  labelColor: const Color(0xFFEAB308),
                  unselectedLabelColor: Colors.white70,
                  labelStyle: const TextStyle(fontWeight: FontWeight.w700),
                  tabs: [
                    const Tab(
                      icon: Icon(Icons.edit_calendar_rounded, size: 18),
                      text: 'Input Form Nilai',
                    ),
                    Tab(
                      icon: const Icon(Icons.table_rows_rounded, size: 18),
                      text: 'Daftar Nilai (${gradeProvider.totalMahasiswa})',
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildFormTab(context, gradeProvider),
              _buildListViewTab(context, gradeProvider),
            ],
          ),
        );
      },
    );
  }

  // TAB 1: FORM INPUT NILAI
  Widget _buildFormTab(BuildContext context, GradeProvider provider) {
    final liveTotal = _calculateLiveTotal();
    final liveGrade = _calculateLiveGrade(liveTotal);
    final isPassed = liveTotal >= 55;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner Bobot Penilaian
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E5BB0).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF93C5FD).withValues(alpha: 0.5)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: Color(0xFF1E5BB0), size: 22),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Formula Nilai: Kehadiran 10% + Tugas 20% + UTS 30% + UAS 40%. Nilai Akhir & Grade dihitung otomatis secara real-time!',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0F2B48),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Card Identitas
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.person_pin_rounded, color: Color(0xFF1E5BB0), size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Data Mahasiswa',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Divider(height: 22),
                    TextFormField(
                      controller: _nimController,
                      decoration: const InputDecoration(
                        labelText: 'NIM Mahasiswa',
                        hintText: 'Contoh: 20230801033',
                        prefixIcon: Icon(Icons.pin_outlined),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value == null || value.trim().isEmpty ? 'NIM wajib diisi' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _namaController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Lengkap Mahasiswa',
                        hintText: 'Contoh: Yasinta Desty Natalia',
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty ? 'Nama wajib diisi' : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _matkulController.text,
                      decoration: const InputDecoration(
                        labelText: 'Mata Kuliah',
                        prefixIcon: Icon(Icons.menu_book_rounded),
                      ),
                      items: _daftarMatkul.map((mk) {
                        return DropdownMenuItem(value: mk, child: Text(mk));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _matkulController.text = val;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Card Komponen Nilai
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.calculate_outlined, color: Color(0xFF1E5BB0), size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Komponen Nilai (0 - 100)',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Divider(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: _buildNumberField(
                            controller: _absenController,
                            label: 'Kehadiran (10%)',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildNumberField(
                            controller: _tugasController,
                            label: 'Tugas (20%)',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildNumberField(
                            controller: _utsController,
                            label: 'UTS (30%)',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildNumberField(
                            controller: _uasController,
                            label: 'UAS (40%)',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Live Simulation Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isPassed
                    ? const Color(0xFF0D9488).withValues(alpha: 0.1)
                    : const Color(0xFFE11D48).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isPassed
                      ? const Color(0xFF0D9488).withValues(alpha: 0.3)
                      : const Color(0xFFE11D48).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Simulasi Nilai Akhir',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        liveTotal.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isPassed ? const Color(0xFF0D9488) : const Color(0xFFE11D48),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isPassed ? const Color(0xFF0D9488) : const Color(0xFFE11D48),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Grade: $liveGrade (${isPassed ? "LULUS" : "GAGAL"})',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Simpan & Reset
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Reset'),
                    onPressed: _resetForm,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: const Color(0xFF0F2B48),
                    ),
                    icon: const Icon(Icons.save_rounded),
                    label: const Text('Simpan Nilai'),
                    onPressed: () => _submitNilai(provider),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // TAB 2: LISTVIEW NILAI
  Widget _buildListViewTab(BuildContext context, GradeProvider provider) {
    final list = provider.gradeList.where((item) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return item.nama.toLowerCase().contains(q) ||
          item.nim.toLowerCase().contains(q) ||
          item.mataKuliah.toLowerCase().contains(q);
    }).toList();

    return Column(
      children: [
        // Summary Card
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F2B48), Color(0xFF1E5BB0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F2B48).withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Mahasiswa', '${provider.totalMahasiswa}', Icons.groups_rounded),
              _buildStatDivider(),
              _buildStatItem(
                'Rata-rata',
                provider.rataRataNilai.toStringAsFixed(1),
                Icons.analytics_rounded,
                color: const Color(0xFFEAB308),
              ),
              _buildStatDivider(),
              _buildStatItem(
                'Lulus',
                '${provider.jumlahLulus}',
                Icons.check_circle_rounded,
                color: const Color(0xFF34D399),
              ),
              _buildStatDivider(),
              _buildStatItem(
                'Tidak Lulus',
                '${provider.jumlahTidakLulus}',
                Icons.cancel_rounded,
                color: const Color(0xFFF87171),
              ),
            ],
          ),
        ),

        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Cari berdasarkan nama, NIM, atau matkul...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () => setState(() => _searchQuery = ''),
                    )
                  : null,
            ),
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
          ),
        ),
        const SizedBox(height: 8),

        // ListView Builder
        Expanded(
          child: list.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox_rounded, size: 60, color: Colors.grey.shade400),
                      const SizedBox(height: 10),
                      Text(
                        _searchQuery.isEmpty
                            ? 'Belum ada data nilai.'
                            : 'Tidak ada data cocok dengan "$_searchQuery"',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: list.length,
                  padding: const EdgeInsets.only(top: 4, bottom: 20),
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return NilaiListItem(
                      grade: item,
                      onDelete: () => provider.deleteGrade(item.id),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon,
      {Color color = Colors.white}) {
    return Column(
      children: [
        Icon(icon, size: 22, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      height: 32,
      width: 1,
      color: Colors.white24,
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: '0 - 100',
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (_) => setState(() {}),
      validator: (val) {
        if (val == null || val.trim().isEmpty) return 'Wajib isi';
        final num = double.tryParse(val.trim());
        if (num == null) return 'Angka valid';
        if (num < 0 || num > 100) return '0 - 100';
        return null;
      },
    );
  }
}
