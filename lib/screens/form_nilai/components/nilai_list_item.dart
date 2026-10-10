import 'package:flutter/material.dart';
import '../../../models/student_grade_model.dart';
import 'nilai_detail_dialog.dart';

class NilaiListItem extends StatelessWidget {
  final StudentGrade grade;
  final VoidCallback onDelete;

  const NilaiListItem({
    super.key,
    required this.grade,
    required this.onDelete,
  });

  Color _getGradeColor(String gradeLetter) {
    if (gradeLetter.startsWith('A')) return const Color(0xFF10B981); // Emerald Green
    if (gradeLetter.startsWith('B')) return const Color(0xFF3B82F6); // Blue
    if (gradeLetter.startsWith('C')) return const Color(0xFFF59E0B); // Amber
    return const Color(0xFFEF4444); // Red for D or E
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final gradeColor = _getGradeColor(grade.grade);
    final bool isLulus = grade.status == 'LULUS';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          showDialog(
            context: context,
            builder: (ctx) => NilaiDetailDialog(grade: grade),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Badge Grade Lingkaran
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: gradeColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: gradeColor, width: 2),
                ),
                child: Center(
                  child: Text(
                    grade.grade,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: gradeColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Detail Data Mahasiswa
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      grade.nama,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'NIM: ${grade.nim} • ${grade.mataKuliah}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          'Nilai Akhir: ${grade.nilaiAkhir.toStringAsFixed(1)}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isLulus
                                ? const Color(0xFF10B981).withValues(alpha: 0.15)
                                : const Color(0xFFEF4444).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            grade.status,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isLulus
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFEF4444),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action Buttons
              IconButton(
                icon: const Icon(Icons.info_outline, size: 20, color: Color(0xFF3B82F6)),
                tooltip: 'Detail Nilai',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => NilaiDetailDialog(grade: grade),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20, color: Color(0xFFEF4444)),
                tooltip: 'Hapus',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Konfirmasi Hapus'),
                      content: Text('Hapus data nilai untuk ${grade.nama}?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Batal'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEF4444),
                          ),
                          onPressed: () {
                            Navigator.pop(ctx);
                            onDelete();
                          },
                          child: const Text('Hapus'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
