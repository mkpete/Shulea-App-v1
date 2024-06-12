import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shulea_app/colors/colors.dart';
import 'package:shulea_app/defaults/menu_items.dart';
import 'package:shulea_app/screens/bottom_app_bar.dart';
import 'package:shulea_app/screens/progress_data_area.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  List<Color> gradientColors = const [
    Color(0xffFF0069),
    Color(0xffFED602),
    Color(0xff7639FB),
    Color(0xffD500C5),
    Color(0xffFF7A01),
    Color(0xffFF0069),
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final backGroundColor = theme.colorScheme.background;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
        body: Column(
      children: [
        SafeArea(
            child: Row(
          children: [
            Container(
              width: screenWidth,
              height: 100,
              color: backGroundColor,
              child: Text("David, Welcome back",
                  style: textTheme.titleLarge ?? const TextStyle()),
            )
          ],
        )),
        Expanded(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  DecoratedBox(
                    decoration: const BoxDecoration(
                      color: greyColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: SizedBox(
                      width: screenWidth * 0.65,
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("200  \$ saved"),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () => {},
                                    style: TextButton.styleFrom(
                                      backgroundColor: aquaColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    child: const Text("Deposit"),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextButton(
                                    onPressed: () => {},
                                    style: TextButton.styleFrom(
                                        backgroundColor: aquaColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    child: const Text("withdraw"),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: greyColor,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: SizedBox(
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("2 kids"),
                              Text("studying"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: greyColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: screenWidth,
                      height: screenHeight * 0.3,
                      child: PageView.builder(itemBuilder: (context, index) {
                        return GridView.count(
                            crossAxisCount: 3,
                            crossAxisSpacing: 1,
                            children: <Widget>[
                              CustomSizeBox(
                                  icon: FontAwesomeIcons.bookOpen,
                                  text: "Progress",
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return const AcademicSelectionPage();
                                    }));
                                  }),
                              CustomSizeBox(
                                  icon: FontAwesomeIcons.dollarSign,
                                  text: "Fees",
                                  onTap: () {}),
                              CustomSizeBox(
                                  icon: FontAwesomeIcons.moneyBill,
                                  text: "Biils",
                                  onTap: () {}),
                              CustomSizeBox(
                                  icon: FontAwesomeIcons.bell,
                                  text: "Updates",
                                  onTap: () {}),
                              CustomSizeBox(
                                  icon: FontAwesomeIcons.user,
                                  text: "Me",
                                  onTap: () {}),
                            ]);
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: SizedBox(
                                      height: 15,
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                            ),
                                          ),
                                          LayoutBuilder(
                                            builder: (context, constraints) {
                                              return Container(
                                                width:
                                                    constraints.maxWidth * 0.2,
                                                decoration: BoxDecoration(
                                                  color: aquaColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Text("20%"),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text("Total saved "),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("20\$"),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("~~ "),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("KES 26,000")
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )),
        CustomBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ],
    ));
  }
}
