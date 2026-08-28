import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/optimization_strategy.dart';
import '../providers/date_optimizer_provider.dart';
import '../widgets/date_candidate_card.dart';

class DateOptimizerScreen extends ConsumerWidget {
  const DateOptimizerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dateOptimizerProvider);
    final notifier = ref.read(dateOptimizerProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.black87,
              size: 20,
            ),
          ),
          tooltip: 'Geri Dön',
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: Column(
          children: [
            const Text(
              'En Uygun Tarih Bulucu',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${state.origin}  ✈️  ${state.destination}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.indigo.shade700,
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        foregroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          // Strategy Selector Header Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.tune, size: 18, color: Colors.indigo),
                      const SizedBox(width: 6),
                      const Text(
                        'Öncelikli Tercihiniz:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const Spacer(),
                      // Duration Control
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, size: 20),
                            onPressed: state.stayDurationDays > 1
                                ? () => notifier.setStayDuration(state.stayDurationDays - 1)
                                : null,
                          ),
                          Text(
                            '${state.stayDurationDays} Gece',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, size: 20),
                            onPressed: state.stayDurationDays < 20
                                ? () => notifier.setStayDuration(state.stayDurationDays + 1)
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Strategy Selector Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: OptimizationStrategy.values.map((strategy) {
                      final isSelected = state.selectedStrategy == strategy;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(strategy.label),
                          selected: isSelected,
                          onSelected: (_) => notifier.setStrategy(strategy),
                          selectedColor: Colors.indigo,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          backgroundColor: Colors.grey.shade100,
                          elevation: isSelected ? 2 : 0,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),
                // Strategy Description Notice
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, size: 16, color: Colors.indigo.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            state.selectedStrategy.description,
                            style: TextStyle(fontSize: 11, color: Colors.indigo.shade900),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Main Results Section
          Expanded(
            child: state.isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'En uygun seyahat tarihleri ve skorlar hesaplanıyor...',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : state.errorMessage != null
                    ? Center(
                        child: Text(
                          state.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    : state.results.isEmpty
                        ? const Center(
                            child: Text('Belirtilen aralıkta uygun tarih bulunamadı.'),
                          )
                        : ListView.builder(
                            itemCount: state.results.length,
                            padding: const EdgeInsets.only(top: 8, bottom: 80),
                            itemBuilder: (context, index) {
                              final result = state.results[index];
                              final isSelected =
                                  state.selectedResult?.candidate.id == result.candidate.id;

                              return DateCandidateCard(
                                result: result,
                                isSelected: isSelected,
                                onTap: () => notifier.selectResult(result),
                              );
                            },
                          ),
          ),
        ],
      ),
      // Bottom Confirmation Action Bar
      bottomSheet: state.selectedResult != null
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Seçilen Tarih:',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                          ),
                          Text(
                            '${state.selectedResult!.candidate.startDate.day}.${state.selectedResult!.candidate.startDate.month} - ${state.selectedResult!.candidate.startDate.endDateFormat}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        final res = state.selectedResult!.candidate;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Seçilen seyahat tarihi onaylandı: ${res.startDate.day}.${res.startDate.month} - ${res.endDate.day}.${res.endDate.month}',
                            ),
                            backgroundColor: Colors.indigo,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text(
                        'Bu Tarihi Seç',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}

extension on DateTime {
  String get endDateFormat => '$day.$month.$year';
}
