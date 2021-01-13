import 'package:flutter/material.dart';

class HorizontalRatingStatisticItem extends StatelessWidget {
  final int index;
  final int ratingPercent;

  HorizontalRatingStatisticItem(this.index, this.ratingPercent);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 5,
        ),
        Text("${index + 1}"),
        SizedBox(
          width: 5,
        ),
        Icon(Icons.star, color: Colors.amber),
        SizedBox(
          width: 5,
        ),
        Container(
            width: 100,
            child: LinearProgressIndicator(
              value: ratingPercent / 100,
            )),
        SizedBox(
          width: 10,
        ),
        Text("$ratingPercent%")
      ],
    );
  }
}
