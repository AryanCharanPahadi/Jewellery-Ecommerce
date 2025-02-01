import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jewellary/Login%20Page/login_page.dart';
import 'package:jewellary/Shared%20Preferences/shared_preferences_helper.dart';

import '../Component/show_pop_up.dart';
import '../Component/text_style.dart';

class Header2 extends StatefulWidget {
  const Header2({super.key});

  @override
  State<Header2> createState() => _Header2State();
}

class _Header2State extends State<Header2> {
  bool _isHovered = false;
  bool _isHovered2 = false;
  bool _isHovered3 = false;
  bool _isHovered4 = false;

  @override
  Widget build(BuildContext context) {
    // Get screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Determine font size, icon size, and padding based on screen width
    double fontSize = screenWidth <= 200
        ? 12
        : screenWidth <= 250
            ? 14
            : screenWidth <= 300
                ? 16
                : screenWidth <= 600
                    ? 20
                    : 24;

    double iconSize = screenWidth <= 200
        ? 14
        : screenWidth <= 250
            ? 16
            : screenWidth <= 300
                ? 18
                : 24;

    double horizontalPadding = screenWidth <= 200
        ? 6
        : screenWidth <= 250
            ? 8
            : screenWidth <= 300
                ? 12
                : 16;

    double iconSpacing = screenWidth <= 200
        ? 6
        : screenWidth <= 250
            ? 8
            : 16;

    return Container(
      color: Colors.white,
      height: 70,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Row(
              children: [
                MouseRegion(
                  onEnter: (_) {
                    // Change the color to red when the mouse enters the region
                    setState(() {
                      _isHovered4 = true;
                    });
                  },
                  onExit: (_) {
                    // Reset the color when the mouse exits the region
                    setState(() {
                      _isHovered4 = false;
                    });
                  },
                  cursor:
                      SystemMouseCursors.click, // Set the hand cursor on hover
                  child: GestureDetector(
                    onTap: () {
                      context.go('/'); // Navigate to the root route
                    },
                    child: Text(
                      "DAZZLE",
                      style: getTextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: _isHovered4
                            ? Colors.red
                            : Colors.black, // Change color based on hover
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    width: screenWidth <= 200
                        ? 2
                        : screenWidth <= 250
                            ? 3
                            : 5),
                Icon(
                  Icons.diamond,
                  size: iconSize,
                  color: Colors.black,
                ),
              ],
            ),
          ),

          // Icons and Links
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding + 4),
            child: Row(
              children: [
                // Account Icon

                MouseRegion(
                    onEnter: (_) {
                      // Change the color to red when the mouse enters the region
                      setState(() {
                        _isHovered2 = true;
                      });
                    },
                    onExit: (_) {
                      // Reset the color when the mouse exits the region
                      setState(() {
                        _isHovered2 = false;
                      });
                    },
                    cursor: SystemMouseCursors
                        .click, // Set the hand cursor on hover
                    child: GestureDetector(
                      onTap: () async {
                        bool isLoggedIn = await _checkLoginStatus();
                        print("profile tap");

                        // Check login status and navigate accordingly
                        if (isLoggedIn) {
                          // Navigate to UserDetailsScreen
                          context.go('/user-details');
                        } else {
                          // Navigate to SignupContent
                          PopupDialog(
                            parentContext: context,
                            childWidget: LoginPage(),
                          ).show(); // Show signup popup
                        }
                      },
                      child: Icon(
                        Icons.person_outline,
                        color: _isHovered2
                            ? Colors.red
                            : Colors.black, // Change color based on hover
                        size: iconSize,
                      ),
                    )),

                SizedBox(width: iconSpacing),

                // Wishlist Icon
                MouseRegion(
                  onEnter: (_) {
                    // Change the color to red when the mouse enters the region
                    setState(() {
                      _isHovered3 = true;
                    });
                  },
                  onExit: (_) {
                    // Reset the color when the mouse exits the region
                    setState(() {
                      _isHovered3 = false;
                    });
                  },
                  cursor:
                      SystemMouseCursors.click, // Set the hand cursor on hover
                  child: GestureDetector(
                    onTap: () async {
                      bool isLoggedIn = await _checkLoginStatus();

                      // Skip the post-frame callback and directly perform actions
                      if (context.mounted) {
                        if (isLoggedIn) {
                          context.go('/wishlist'); // Navigate to the cart
                        } else {
                          PopupDialog(
                            parentContext: context,
                            childWidget: LoginPage(),
                          ).show(); // Show signup popup
                        }
                      }
                    },
                    child: Icon(
                      Icons.favorite_border,
                      color: _isHovered3
                          ? Colors.red
                          : Colors.black, // Change color based on hover
                      size: iconSize,
                    ),
                  ),
                ),

                SizedBox(width: iconSpacing),

                // Cart Icon
                MouseRegion(
                  onEnter: (_) {
                    // Change the color to red when the mouse enters the region
                    setState(() {
                      _isHovered = true;
                    });
                  },
                  onExit: (_) {
                    // Reset the color when the mouse exits the region
                    setState(() {
                      _isHovered = false;
                    });
                  },
                  cursor:
                      SystemMouseCursors.click, // Set the hand cursor on hover
                  child: GestureDetector(
                    onTap: () async {
                      bool isLoggedIn = await _checkLoginStatus();

                      // Skip the post-frame callback and directly perform actions
                      if (context.mounted) {
                        if (isLoggedIn) {
                          context.go('/add-to-cart'); // Navigate to the cart
                        } else {
                          PopupDialog(
                            parentContext: context,
                            childWidget: LoginPage(),
                          ).show(); // Show signup popup
                        }
                      }
                    },
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      color: _isHovered
                          ? Colors.red
                          : Colors.black, // Change color based on hover
                      size: iconSize,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _checkLoginStatus() async {
    bool isLoggedIn = await SharedPreferencesHelper.getLoginStatus();
    return isLoggedIn;
  }
}
