import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 58, 169),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/images/Logo.PNG',
                  height: 28,
                ),
                const SizedBox(width: 10),
                Text(
                  "TEMU EKSPOR",
                  style: GoogleFonts.dmSerifDisplay(
                    fontSize: 28,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              width: double.infinity,
              child: Image.asset(
                'lib/images/shippy.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 25),
            Text(
              "Connecting International Buyers & Our Local Suppliers",
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 22,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "We connect buyers and suppliers for efficient trading and increased visibility in global markets.",
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 16,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Get Started'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color.fromARGB(255, 21, 58, 169),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
