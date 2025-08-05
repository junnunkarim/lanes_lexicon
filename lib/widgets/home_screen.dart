import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import 'home_page_cards.dart' show HomePageCards;

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return GridView.count(
          padding: const EdgeInsets.fromLTRB(10, 70, 10, 50),
          crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
          children: [
            const HomePageCards(
              imagePath: favImage,
              route: "/favorites",
            ),
            const HomePageCards(
              imagePath: quranImage,
              route: "/quranicWords",
            ),
            const HomePageCards(
              imagePath: donateImage,
              route: "/donate",
            ),
            HomePageCards(
              imagePath: quranleImage,
              uri: quranleUri,
            ),
            HomePageCards(
              imagePath: forHireImage,
              uri: portfolioUri,
            ),
            HomePageCards(
              imagePath: hadithhubImage,
              uri: hadithHubUri,
            ),
          ],
        );
      },
    );
  }
}
