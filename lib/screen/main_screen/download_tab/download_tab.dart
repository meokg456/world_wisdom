import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:world_wisdom/generated/l10n.dart';
import 'package:world_wisdom/model/course_model/course_detail.dart';
import 'package:world_wisdom/model/course_model/downloaded_courses_model.dart';
import 'package:world_wisdom/screen/key/key.dart';
import 'package:world_wisdom/screen/main_screen/main_app_bar/main_app_bar.dart';

class DownloadTab extends StatefulWidget {
  @override
  _DownloadTabState createState() => _DownloadTabState();
}

class _DownloadTabState extends State<DownloadTab> {
  @override
  Widget build(BuildContext context) {
    DownloadedCoursesModel downloadedCoursesModel = Provider.of(context);

    return Scaffold(
      appBar: MainTabAppBar(S.of(context).download),
      body: downloadedCoursesModel.courses.length > 0
          ? Container(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 50),
                itemCount: downloadedCoursesModel.courses.length,
                itemBuilder: (context, index) {
                  CourseDetail course = downloadedCoursesModel.courses[index];
                  Duration duration =
                      Duration(seconds: (course.totalHours * 3600).round());
                  return ListTile(
                    onTap: () {
                      Keys.mainNavigatorKey.currentState.pushNamed(
                          "/course-detail",
                          arguments: CourseDetail(id: course.id));
                    },
                    leading: course.imageUrl == null
                        ? Image.asset(
                            "resources/images/online-course.png",
                            width: 70,
                          )
                        : Image.file(
                            File(course.imageUrl),
                            width: 70,
                          ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(course.title,
                            style: Theme.of(context).textTheme.subtitle2),
                        SizedBox(
                          height: 5,
                        ),
                        course.instructor.name == null
                            ? SizedBox()
                            : Text(course.instructor.name,
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
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
              ),
            )
          : Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Icon(
                      Icons.arrow_circle_down_outlined,
                      size: 100,
                      color: Color(0xFF2D3137),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      child: Text(
                        S.of(context).downloadHint,
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8, bottom: 20),
                      child: Text(
                        S.of(context).downloadDescriptions,
                        style: Theme.of(context).textTheme.subtitle1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            BottomNavigationBar bottomNavigationBar =
                                Keys.bottomNavigationBarKey.currentWidget;
                            bottomNavigationBar.onTap(3);
                          },
                          child: Text(
                            S.of(context).browseNavigateButtonText,
                            style: Theme.of(context).textTheme.button,
                          )),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 40, bottom: 5),
                      child: Text(S.of(context).downloadGuideHint),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          "resources/images/DownloadByButton.jpg",
                          height: 150,
                        ),
                        Image.asset(
                          "resources/images/DownloadByMenu.jpg",
                          height: 150,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
