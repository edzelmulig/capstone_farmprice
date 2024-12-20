import 'package:flutter/material.dart';
import 'package:myapp/ui/screens/admin_screen/login_screen.dart';
import 'package:myapp/ui/screens/basic_user_screen/login_user_account.dart';
import 'package:myapp/ui/widgets/custom_button.dart';
import 'package:myapp/ui/widgets/custom_image_display.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final logoMargin = screenHeight * 0.1;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          return;
        }
        Navigator.of(context).pop;
      },
      child: Scaffold(
        body: Column(
          children: <Widget>[
            // APP LOGO
            Center(
              child: Container(
                margin: EdgeInsets.only(top: logoMargin, bottom: 10),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return CustomImageDisplay(
                      imageSource: "lib/ui/assets/farm_price_logo.png",
                      imageHeight: screenHeight * 0.5,
                      imageWidth: screenWidth * 0.6,
                    );
                  },
                ),
              ),
            ),

            // CONTINUE BUTTON
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.3),
              child: CustomButton(
                buttonLabel: "Continue",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginUserAccount()),
                  );
                },
                buttonColor: const Color(0xFF39590e),
                buttonHeight: 45,
                fontWeight: FontWeight.w500,
                fontSize: 15,
                fontColor: Colors.white,
                borderRadius: 10,
              ),
            ),

            // SIZED BOX
            const Spacer(),

            // ADMIN ACCESS
            TextButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(
                  const Color.fromARGB(255, 38, 63, 4),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: const Text(
                'ADMIN ACCESS',
                style: TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF133c0b),
                ),
              ),
            ),

            // SPACING
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
