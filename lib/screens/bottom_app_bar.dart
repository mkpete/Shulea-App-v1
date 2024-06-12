import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shulea_app/colors/colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: greyColor,
          items: const [
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.th,
                size: 30,
                color: Color.fromARGB(200, 49, 48, 48),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.wallet,
                size: 30,
                color: Color.fromARGB(200, 49, 48, 48),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.user,
                size: 30,
                color: Color.fromARGB(200, 49, 48, 48),
              ),
              label: '',
            )
          ],
        ),
      ),
    );
  }
}
