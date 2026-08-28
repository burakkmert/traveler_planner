import 'package:flutter/material.dart';
import '../widgets/home_header_widget.dart';
import '../widgets/travel_search_card_widget.dart';
import '../widgets/recent_searches_widget.dart';
import '../widgets/popular_destinations_widget.dart';
import '../../../weather/presentation/widgets/weather_card_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeaderWidget(),
              SizedBox(height: 16),
              // Prominent Weather Card Placement (Right below header, before search card)
              WeatherCardWidget(),
              SizedBox(height: 16),
              TravelSearchCardWidget(),
              SizedBox(height: 24),
              RecentSearchesWidget(),
              SizedBox(height: 24),
              PopularDestinationsWidget(),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
