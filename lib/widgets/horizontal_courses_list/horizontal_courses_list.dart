import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:world_wisdom/model/course_model/course.dart';
import 'package:world_wisdom/model/course_model/course_model.dart';

class HorizontalCoursesList extends StatelessWidget {
  final CourseModel courseModel;

  HorizontalCoursesList(this.courseModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: courseModel.courses.length,
          itemBuilder: (context, index) {
            Course course = courseModel.courses[index];
            return Container(
              margin: EdgeInsets.only(right: 10),
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: 200,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          course.imageUrl,
                          width: double.infinity,
                          height: 100,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          course.title,
                          overflow: TextOverflow.clip,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        course.instructorUserName == null
                            ? SizedBox()
                            : Text(
                                course.instructorUserName,
                                style: Theme.of(context).textTheme.caption,
                              ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          course.price == 0
                              ? "Free"
                              : NumberFormat.currency(
                                      locale: Localizations.localeOf(context)
                                          .toString())
                                  .format(course.price),
                          style: Theme.of(context).textTheme.caption,
                        ),
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
                  ),
                ),
              ),
            );
          }),
    );
  }
}
