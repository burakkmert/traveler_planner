import 'package:flutter/material.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Nereye Keşfe Çıkalım?',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.flight_takeoff_rounded,
                  color: theme.colorScheme.primary,
                  size: 26,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'En uygun rotaları ve seyahat planlarını keşfet',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        CircleAvatar(
          radius: 22,
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
          child: Icon(
            Icons.person_outline_rounded,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
