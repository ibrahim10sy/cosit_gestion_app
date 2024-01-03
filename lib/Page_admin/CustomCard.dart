import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final String? imagePath;
  final Column? children; // New attribute for additional widgets

  const CustomCard({
    super.key,
    this.title,
    this.subTitle,
    this.imagePath,
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        alignment: const Alignment(0.9, -0.8),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 215,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                  color: Colors
                      .red, // You can replace this with a variable if needed
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 15.0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title != null)
                          Text(
                            title!,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        if (subTitle != null)
                          Text(
                            subTitle!,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        if (children != null) children!,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (imagePath != null)
            Image.asset(
              imagePath!,
              width: 150,
              height: 99,
            ),
        ],
      ),
    );
  }
}
