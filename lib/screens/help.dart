import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xff3B7753),
        appBar: AppBar(
          backgroundColor: const Color(0xff3B7753),
          toolbarHeight: 90,
          automaticallyImplyLeading: true,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'To help you please tell us about your problem!!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 80,
              ),
              const Text(
                'Our Team:',
                style: TextStyle(
                    fontSize: 40,
                    color: Color.fromARGB(255, 122, 155, 140),
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 35,
              ),
              nameEmail('Jana Baqays', 42, 'Jbaqays@stu.kau.edu.sa'),
              const SizedBox(
                height: 24,
              ),
              nameEmail('Byan Alroqi', 60,  '@stu.kau.edu.sa'),
              const SizedBox(
                height: 24,
              ),
              nameEmail('Sara Attar', 73,  '@stu.kau.edu.sa'),
              const SizedBox(
                height: 24,
              ),
              nameEmail('Angham Sultan', 28,  '@stu.kau.edu.sa'),
              const SizedBox(
                height: 200,
              ),
              const Text(
                'KAU  |  Graduation Project  |  TechIntern',
                style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 122, 155, 140),
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );

  Widget nameEmail(String name, double width, String email) => Row(
        children: [
          Text(
            name,
            style: const TextStyle(
                fontSize: 20, color: Colors.white70, fontWeight: FontWeight.bold),
          ),
          VerticalDivider(width: width),
          Text(
            email,
            style: const TextStyle(
                fontSize: 18, color: Colors.black54, fontWeight: FontWeight.bold),
          ),
        ],
      );
}
