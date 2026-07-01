import 'package:e_cource/general/widgets/button_with_icon.dart';
import 'package:flutter/material.dart';

class CourseLiveWidget extends StatelessWidget {
  const CourseLiveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        child: Column(
          children: [
            //  header
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  "Live",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: .bold,
                    fontSize: 18,
                  ),
                ),

                ButtonWithIcon(
                  name: "Go Live",
                  ontap: () {},
                  icon: Icons.live_tv_outlined,
                ),
              ],
            ),
            const SizedBox(height: 8),
            //
            SizedBox(
              width: double.infinity,
              height: 1400,
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      height: 300,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
