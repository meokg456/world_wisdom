import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:world_wisdom/model/rate_model/rating.dart';

class RatingListItem extends StatelessWidget {
  final Rating rating;

  RatingListItem(this.rating);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          thickness: 1,
        ),
        ListTile(
          dense: true,
          title: ListTile(
            contentPadding: EdgeInsets.all(0),
            dense: true,
            leading: CircleAvatar(
              backgroundImage: NetworkImage(rating.user.avatar),
            ),
            title: ListTile(
                trailing: Text(
                    "${DateFormat.yMMMMd().format(rating.createdAt.toLocal())}"),
                contentPadding: EdgeInsets.all(0),
                title: Text(rating.user.name)),
            subtitle: RatingBar.builder(
              initialRating: rating.averagePoint,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 12,
              itemPadding: EdgeInsets.symmetric(horizontal: 1),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              ignoreGestures: true,
              onRatingUpdate: (double value) {},
            ),
          ),
          subtitle: ListTile(
            contentPadding: EdgeInsets.all(0),
            title: Text(
              rating.content,
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ],
    );
  }
}
