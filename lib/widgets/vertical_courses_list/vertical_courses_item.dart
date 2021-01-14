import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:world_wisdom/generated/l10n.dart';
import 'package:world_wisdom/model/course_model/course.dart';
import 'package:world_wisdom/model/course_model/course_detail.dart';
import 'package:world_wisdom/screen/course/course_list/course_list_screen.dart';
import 'package:world_wisdom/screen/key/key.dart';

class VerticalCoursesListItem extends StatelessWidget {
  final Course course;

  VerticalCoursesListItem(this.course);

  void selectMenuItem(MenuItem value) {}
  @override
  Widget build(BuildContext context) {
    Duration duration = Duration(seconds: (course.totalHours * 3600).round());
    return ListTile(
      onTap: () {
        Keys.mainNavigatorKey.currentState.pushNamedAndRemoveUntil(
            "/course-detail",
            (route) => route.settings.name == "/course-detail" ? false : true,
            arguments: CourseDetail(id: course.id));
      },
      leading: course.imageUrl == null
          ? Image.asset(
              "resources/images/online-course.png",
              width: 70,
            )
          : Image.network(
              course.imageUrl,
              width: 70,
            ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(course.title, style: Theme.of(context).textTheme.subtitle2),
          SizedBox(
            height: 5,
          ),
          course.instructorUserName == null
              ? SizedBox()
              : Text(course.instructorUserName,
                  style: Theme.of(context).textTheme.caption),
          SizedBox(
            height: 2,
          ),
          course.createdAt == null
              ? SizedBox()
              : Text(
                  "${DateFormat.yMMMMd().format(course.createdAt.toLocal())}",
                  style: Theme.of(context).textTheme.caption),
          SizedBox(
            height: 2,
          ),
          Text(
              "${course.price == 0 || course.price == null ? S.of(context).free : NumberFormat.currency(locale: Localizations.localeOf(context).toString()).format(course.price)} · ${duration.inHours}h ${duration.inMinutes}m",
              style: Theme.of(context).textTheme.caption),
          SizedBox(
            height: 2,
          ),
          Row(
            children: [
              RatingBar.builder(
                initialRating: course.formalityPoint,
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
              SizedBox(width: 5),
              Text("(${course.ratedNumber})",
                  style: Theme.of(context).textTheme.caption),
            ],
          )
        ],
      ),
    );
  }
}
