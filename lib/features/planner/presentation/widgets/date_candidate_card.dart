import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../profile/presentation/providers/settings_provider.dart';
import '../../domain/models/optimized_date_result.dart';

class DateCandidateCard extends ConsumerWidget {
  final OptimizedDateResult result;
  final bool isSelected;
  final VoidCallback onTap;

  const DateCandidateCard({
    super.key,
    required this.result,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final candidate = result.candidate;
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider);

    final totalFormatted = CurrencyFormatter.format(candidate.totalPrice, settings.currencyCode);
    final flightFormatted = CurrencyFormatter.format(candidate.flightPrice, settings.currencyCode);
    final hotelFormatted = CurrencyFormatter.format(candidate.hotelPrice, settings.currencyCode);

    final startStr = '${candidate.startDate.day} ${_getMonthName(candidate.startDate.month)}';
    final endStr = '${candidate.endDate.day} ${_getMonthName(candidate.endDate.month)}';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.indigo.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? Colors.indigo : Colors.grey.shade200,
          width: isSelected ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isSelected ? 15 : 6),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Row (Rank Badge + Score Badge)
                Row(
                  children: [
                    if (result.rank == 1)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF8C00), Color(0xFFFF4500)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.workspace_premium, color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'En İdeal Seçenek',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '#${result.rank} Seçenek',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    const Spacer(),
                    // Total Score Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getScoreColor(result.totalScore).withAlpha(30),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getScoreColor(result.totalScore),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.bolt,
                            color: _getScoreColor(result.totalScore),
                            size: 14,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'Skor: ${result.totalScore.toStringAsFixed(0)}/100',
                            style: TextStyle(
                              color: _getScoreColor(result.totalScore),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Main Info Row: Dates + Price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$startStr - $endStr',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${candidate.stayDurationDays} Gece Konaklama',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          totalFormatted,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade900,
                          ),
                        ),
                        Text(
                          'Uçuş: $flightFormatted + Otel: $hotelFormatted',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const Divider(height: 20),

                // Weather and Flight Details Row
                Row(
                  children: [
                    Icon(Icons.wb_sunny_outlined, size: 16, color: Colors.orange.shade700),
                    const SizedBox(width: 4),
                    Text(
                      candidate.weatherSummary,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    Icon(Icons.flight_outlined, size: 16, color: Colors.blue.shade700),
                    const SizedBox(width: 4),
                    Text(
                      '${candidate.travelDurationHours.toStringAsFixed(1)}s • ${candidate.transferCount == 0 ? 'Aktarmasız' : '${candidate.transferCount} Aktarma'}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Factor Score Breakdown Progress Bars
                Column(
                  children: [
                    _ScoreProgressBar(
                      label: 'Uçuş Fiyatı',
                      score: result.flightScore,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 4),
                    _ScoreProgressBar(
                      label: 'Otel Fiyatı',
                      score: result.hotelScore,
                      color: Colors.indigo,
                    ),
                    const SizedBox(height: 4),
                    _ScoreProgressBar(
                      label: 'Hava Konforu',
                      score: result.weatherScore,
                      color: Colors.amber.shade700,
                    ),
                    const SizedBox(height: 4),
                    _ScoreProgressBar(
                      label: 'Yolculuk Hızı',
                      score: result.durationScore,
                      color: Colors.teal,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 85) return Colors.green.shade700;
    if (score >= 70) return Colors.blue.shade700;
    if (score >= 55) return Colors.orange.shade700;
    return Colors.red.shade700;
  }

  String _getMonthName(int month) {
    const months = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    return months[month - 1];
  }
}

class _ScoreProgressBar extends StatelessWidget {
  final String label;
  final double score; // 0.0 to 1.0
  final Color color;

  const _ScoreProgressBar({
    required this.label,
    required this.score,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${(score * 100).toStringAsFixed(0)}%',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}
