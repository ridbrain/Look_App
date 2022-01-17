import 'package:look_app/services/extensions.dart';
import 'package:flutter/material.dart';

class MasterNRE extends StatelessWidget {
  MasterNRE({
    required this.name,
    required this.rating,
    required this.experience,
    required this.address,
  });

  final String name;
  final String address;
  final double? rating;
  final int experience;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 10, bottom: 5),
          child: Text(
            name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          child: rating != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Оценка ",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      rating.toString(),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                )
              : Text(
                  "Пока нет оценок",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                  ),
                ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            experience.getExperience(),
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 5, left: 30, right: 30),
          child: Text(
            address,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.blueGrey,
            ),
          ),
        ),
      ],
    );
  }
}
