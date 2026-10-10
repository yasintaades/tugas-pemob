import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/profile_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showEditProfileDialog(BuildContext context, ProfileProvider provider) {
    final user = provider.userProfile;
    final namaCtrl = TextEditingController(text: user.nama);
    final emailCtrl = TextEditingController(text: user.email);
    final prodiCtrl = TextEditingController(text: user.programStudi);
    final fakultasCtrl = TextEditingController(text: user.fakultas);
    final universitasCtrl = TextEditingController(text: user.universitas);
    final semesterCtrl = TextEditingController(text: user.semester);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Row(
          children: [
            Icon(Icons.edit_rounded, color: Color(0xFF0F2B48)),
            SizedBox(width: 8),
            Text(
              'Edit Profil Pengguna',
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
                    controller: namaCtrl,
                    decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                    validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email Kampus'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: prodiCtrl,
                    decoration: const InputDecoration(labelText: 'Program Studi'),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: fakultasCtrl,
                    decoration: const InputDecoration(labelText: 'Fakultas'),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: universitasCtrl,
                    decoration: const InputDecoration(labelText: 'Universitas'),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: semesterCtrl,
                    decoration: const InputDecoration(labelText: 'Semester'),
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
                provider.updateProfile(
                  nama: namaCtrl.text.trim(),
                  email: emailCtrl.text.trim(),
                  programStudi: prodiCtrl.text.trim(),
                  fakultas: fakultasCtrl.text.trim(),
                  universitas: universitasCtrl.text.trim(),
                  semester: semesterCtrl.text.trim(),
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profil pengguna berhasil diperbarui!'),
                    backgroundColor: Color(0xFF0D9488),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        final user = profileProvider.userProfile;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profil Pengguna'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_note_rounded),
                tooltip: 'Edit Profil',
                onPressed: () => _showEditProfileDialog(context, profileProvider),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Header Avatar & Nama
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF0F2B48), Color(0xFF1E5BB0)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF0F2B48).withValues(alpha: 0.2),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.blue.shade100,
                              backgroundImage: NetworkImage(user.avatarUrl),
                              onBackgroundImageError: (exception, stackTrace) {},
                              child: user.avatarUrl.isEmpty
                                  ? const Icon(Icons.person, size: 50, color: Color(0xFF0F2B48))
                                  : null,
                            ),
                          ),
                          Positioned(
                            bottom: 2,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Color(0xFF0D9488),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        user.nama,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'NIM: ${user.nim} • ${user.universitas}',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.grey.shade400 : const Color(0xFF1E5BB0),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E5BB0).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF1E5BB0).withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          user.semester,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E5BB0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Card Statistik Akademik
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatColumn('IPK Kumulatif', user.ipk.toStringAsFixed(2),
                            Icons.star_rounded, color: const Color(0xFFEAB308)),
                        Container(height: 36, width: 1, color: Colors.grey.shade300),
                        _buildStatColumn('SKS Lulus', '${user.sksLulus}', Icons.school_rounded,
                            color: const Color(0xFF1E5BB0)),
                        Container(height: 36, width: 1, color: Colors.grey.shade300),
                        _buildStatColumn('Status', 'Aktif', Icons.verified_user_rounded,
                            color: const Color(0xFF0D9488)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Card Informasi Institusi
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.account_balance_rounded, color: Color(0xFF1E5BB0), size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Informasi Akademik',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        _buildProfileInfoRow(Icons.domain_rounded, 'Perguruan Tinggi', user.universitas),
                        _buildProfileInfoRow(Icons.layers_rounded, 'Fakultas', user.fakultas),
                        _buildProfileInfoRow(Icons.computer_rounded, 'Program Studi', user.programStudi),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Card Pengaturan Preferensi
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.tune_rounded, color: Color(0xFF1E5BB0), size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Pengaturan & Tampilan',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          secondary: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAB308).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              profileProvider.isDarkMode
                                  ? Icons.dark_mode_rounded
                                  : Icons.light_mode_rounded,
                              color: Colors.amber.shade800,
                            ),
                          ),
                          title: const Text(
                            'Mode Gelap (Dark Mode)',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            profileProvider.isDarkMode ? 'Tema aktif: Gelap' : 'Tema aktif: Terang',
                            style: const TextStyle(fontSize: 12),
                          ),
                          value: profileProvider.isDarkMode,
                          onChanged: (val) {
                            profileProvider.toggleTheme(val);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Card Tentang Aplikasi
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.info_outline_rounded, color: Color(0xFF1E5BB0), size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Informasi Projek Pemob',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Divider(height: 22),
                        _buildAppInfoItem('Mata Kuliah', 'Pemrograman Mobile (Pemob)'),
                        _buildAppInfoItem('Mahasiswa', 'Yasinta Desty Natalia'),
                        _buildAppInfoItem('State Management', 'Provider (ChangeNotifier)'),
                        _buildAppInfoItem('Framework', 'Flutter 3.47 & Material 3'),
                        _buildAppInfoItem('Kampus', 'Universitas Esa Unggul'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatColumn(String label, String value, IconData icon, {Color? color}) {
    return Column(
      children: [
        Icon(icon, size: 22, color: color ?? const Color(0xFF0F2B48)),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color ?? const Color(0xFF0F2B48),
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildProfileInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E5BB0).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF1E5BB0)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
