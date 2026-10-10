import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/biodata_provider.dart';
import 'components/biodata_info_tile.dart';

class BiodataScreen extends StatefulWidget {
  const BiodataScreen({super.key});

  @override
  State<BiodataScreen> createState() => _BiodataScreenState();
}

class _BiodataScreenState extends State<BiodataScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Dialog untuk mengedit Biodata Pribadi dan memperbarui State
  void _showEditBiodataDialog(BuildContext context, BiodataProvider provider) {
    final bio = provider.biodata;
    final namaLengkapCtrl = TextEditingController(text: bio.namaLengkap);
    final namaPanggilanCtrl = TextEditingController(text: bio.namaPanggilan);
    final nimCtrl = TextEditingController(text: bio.nim);
    final ttlCtrl = TextEditingController(text: bio.tempatTanggalLahir);
    final jenisKelaminCtrl = TextEditingController(text: bio.jenisKelamin);
    final agamaCtrl = TextEditingController(text: bio.agama);
    final alamatCtrl = TextEditingController(text: bio.alamat);
    final emailCtrl = TextEditingController(text: bio.email);
    final noHpCtrl = TextEditingController(text: bio.noHp);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Row(
          children: [
            Icon(Icons.edit_note_rounded, color: Color(0xFF0F2B48)),
            SizedBox(width: 8),
            Text(
              'Edit Biodata Pribadi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: namaLengkapCtrl,
                    decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                    validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: namaPanggilanCtrl,
                    decoration: const InputDecoration(labelText: 'Nama Panggilan'),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: nimCtrl,
                    decoration: const InputDecoration(labelText: 'NIM'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: ttlCtrl,
                    decoration: const InputDecoration(labelText: 'Tempat, Tanggal Lahir'),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: jenisKelaminCtrl,
                    decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: agamaCtrl,
                    decoration: const InputDecoration(labelText: 'Agama'),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email Mahasiswa'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: noHpCtrl,
                    decoration: const InputDecoration(labelText: 'Nomor WhatsApp / HP'),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: alamatCtrl,
                    decoration: const InputDecoration(labelText: 'Alamat Domisili'),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                provider.updatePersonalData(
                  namaLengkap: namaLengkapCtrl.text.trim(),
                  namaPanggilan: namaPanggilanCtrl.text.trim(),
                  nim: nimCtrl.text.trim(),
                  tempatTanggalLahir: ttlCtrl.text.trim(),
                  jenisKelamin: jenisKelaminCtrl.text.trim(),
                  agama: agamaCtrl.text.trim(),
                  alamat: alamatCtrl.text.trim(),
                  email: emailCtrl.text.trim(),
                  noHp: noHpCtrl.text.trim(),
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Biodata mahasiswa berhasil diperbarui!'),
                    backgroundColor: Color(0xFF0D9488),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Simpan Perubahan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer<BiodataProvider>(
      builder: (context, provider, child) {
        final bio = provider.biodata;

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Biodata Mahasiswa',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Universitas Esa Unggul • Fasilkom',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_note_rounded),
                tooltip: 'Edit Biodata',
                onPressed: () => _showEditBiodataDialog(context, provider),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Container(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFF0F2B48),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicatorColor: const Color(0xFFEAB308),
                  indicatorWeight: 3,
                  labelColor: const Color(0xFFEAB308),
                  unselectedLabelColor: Colors.white70,
                  labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  tabs: const [
                    Tab(icon: Icon(Icons.badge_outlined, size: 17), text: 'Pribadi'),
                    Tab(icon: Icon(Icons.school_outlined, size: 17), text: 'Pendidikan'),
                    Tab(icon: Icon(Icons.work_outline, size: 17), text: 'Pekerjaan'),
                    Tab(icon: Icon(Icons.groups_outlined, size: 17), text: 'Organisasi'),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildPersonalTab(context, bio, provider),
              _buildEducationTab(context, bio),
              _buildWorkTab(context, bio),
              _buildOrganizationTab(context, bio),
            ],
          ),
        );
      },
    );
  }

  // WIDGET TAB 1: PRIBADI (KTM DIGITAL ESA UNGGUL STYLE)
  Widget _buildPersonalTab(
      BuildContext context, dynamic bio, BiodataProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Virtual Student ID Card (KTM Digital)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFF0F2B48), Color(0xFF1E5BB0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F2B48).withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Watermark Decorative Circle
                Positioned(
                  right: -30,
                  top: -30,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // University Header on Card
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.school, color: Color(0xFFEAB308), size: 20),
                              SizedBox(width: 8),
                              Text(
                                'UNIVERSITAS ESA UNGGUL',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAB308),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'KTM DIGITAL',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F2B48),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFFEAB308), width: 2),
                            ),
                            child: CircleAvatar(
                              radius: 36,
                              backgroundColor: Colors.white.withValues(alpha: 0.15),
                              backgroundImage: const NetworkImage(
                                'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=400&q=80',
                              ),
                              child: const Icon(Icons.person, size: 40, color: Colors.white70),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bio.namaLengkap,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'NIM: ${bio.nim}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF93C5FD),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'S1 Teknik Informatika • Fasilkom',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0D9488),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    bio.statusMahasiswa,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Detail Card Biodata Pribadi
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.person_pin_rounded, color: Color(0xFF1E5BB0), size: 22),
                      SizedBox(width: 8),
                      Text(
                        'Informasi Identitas',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  BiodataInfoTile(
                    icon: Icons.badge_outlined,
                    label: 'Nama Lengkap',
                    value: bio.namaLengkap,
                  ),
                  BiodataInfoTile(
                    icon: Icons.tag,
                    label: 'Nama Panggilan',
                    value: bio.namaPanggilan,
                  ),
                  BiodataInfoTile(
                    icon: Icons.pin_outlined,
                    label: 'Nomor Induk Mahasiswa (NIM)',
                    value: bio.nim,
                  ),
                  BiodataInfoTile(
                    icon: Icons.cake_outlined,
                    label: 'Tempat, Tanggal Lahir',
                    value: bio.tempatTanggalLahir,
                  ),
                  BiodataInfoTile(
                    icon: Icons.female_rounded,
                    label: 'Jenis Kelamin',
                    value: bio.jenisKelamin,
                    iconColor: Colors.pinkAccent,
                  ),
                  BiodataInfoTile(
                    icon: Icons.church_outlined,
                    label: 'Agama',
                    value: bio.agama,
                    iconColor: const Color(0xFF1E5BB0),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Detail Card Kontak & Domisili
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.contact_mail_outlined, color: Color(0xFF1E5BB0), size: 22),
                      SizedBox(width: 8),
                      Text(
                        'Kontak & Domisili',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  BiodataInfoTile(
                    icon: Icons.email_outlined,
                    label: 'Email Kampus',
                    value: bio.email,
                  ),
                  BiodataInfoTile(
                    icon: Icons.phone_android_outlined,
                    label: 'Nomor Handphone / WhatsApp',
                    value: bio.noHp,
                  ),
                  BiodataInfoTile(
                    icon: Icons.home_outlined,
                    label: 'Alamat Tempat Tinggal',
                    value: bio.alamat,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET TAB 2: PENDIDIKAN
  Widget _buildEducationTab(BuildContext context, dynamic bio) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bio.pendidikan.length,
      itemBuilder: (context, index) {
        final edu = bio.pendidikan[index];
        final bool isCurrent = index == 0;

        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? const Color(0xFF1E5BB0).withValues(alpha: 0.12)
                        : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.school_rounded,
                    color: isCurrent ? const Color(0xFF1E5BB0) : Colors.grey.shade600,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isCurrent
                                  ? const Color(0xFF1E5BB0).withValues(alpha: 0.12)
                                  : Colors.grey.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              edu.jenjang,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isCurrent ? const Color(0xFF1E5BB0) : Colors.grey.shade700,
                              ),
                            ),
                          ),
                          Text(
                            edu.periode,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        edu.namaInstitusi,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Jurusan: ${edu.jurusan}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 16, color: Color(0xFFEAB308)),
                          const SizedBox(width: 4),
                          Text(
                            edu.nilaiAkhir,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // WIDGET TAB 3: PEKERJAAN
  Widget _buildWorkTab(BuildContext context, dynamic bio) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bio.pekerjaan.length,
      itemBuilder: (context, index) {
        final job = bio.pekerjaan[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D9488).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.work_rounded,
                        color: Color(0xFF0D9488),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.posisi,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            job.perusahaan,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF0D9488),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D9488).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        job.tipe,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D9488),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(Icons.calendar_today_rounded, size: 13, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      job.periode,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),
                Text(
                  job.deskripsi,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade800,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // WIDGET TAB 4: ORGANISASI
  Widget _buildOrganizationTab(BuildContext context, dynamic bio) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bio.organisasi.length,
      itemBuilder: (context, index) {
        final org = bio.organisasi[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.groups_rounded,
                        color: Color(0xFF8B5CF6),
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            org.namaOrganisasi,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            org.jabatan,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF8B5CF6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.date_range_rounded, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 6),
                    Text(
                      'Periode: ${org.periode}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),
                Text(
                  org.peran,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade800,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
