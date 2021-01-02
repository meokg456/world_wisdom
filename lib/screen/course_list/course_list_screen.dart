import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:world_wisdom/model/course_model/course.dart';
import 'package:world_wisdom/model/course_model/course_model.dart';
import 'package:world_wisdom/screen/course_list/course_list_data.dart';

enum MenuItem { download, share }

class CourseListScreen extends StatefulWidget {
  @override
  _CourseListScreenState createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  CourseModel courseModel = CourseModel(courses: []);
  CourseListData courseListData;
  bool isLoaded = false;

  void selectMenuItem(MenuItem value) {}

  @override
  Widget build(BuildContext context) {
    courseListData = ModalRoute.of(context).settings.arguments;
    if (!isLoaded) {
      isLoaded = true;
      courseListData.fetchDataFunction(10, 1).then((value) {
        setState(() {
          courseModel.courses.addAll(value.courses);
        });
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(courseListData.title),
        centerTitle: true,
      ),
      body: Container(
        child: ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 10),
          itemCount: courseModel.courses.length,
          itemBuilder: (context, index) {
            Course course = courseModel.courses[index];
            Duration duration =
                Duration(seconds: (course.totalHours * 3600).round());
            return ListTile(
              leading: Image.network(
                course.imageUrl,
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
                  Text(course.instructorUserName,
                      style: Theme.of(context).textTheme.caption),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                      "${new DateFormat.yMMMMd().format(course.createdAt.toLocal())}",
                      style: Theme.of(context).textTheme.caption),
                  SizedBox(
                    height: 2,
                  ),
                  Text("${duration.inHours}h ${duration.inMinutes}m",
                      style: Theme.of(context).textTheme.caption),
                  SizedBox(
                    height: 2,
                  ),
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
                  )
                ],
              ),
              trailing: PopupMenuButton<MenuItem>(
                onSelected: selectMenuItem,
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<MenuItem>>[
                  const PopupMenuItem<MenuItem>(
                    value: MenuItem.download,
                    child: Text('Download'),
                  ),
                  const PopupMenuItem<MenuItem>(
                    value: MenuItem.share,
                    child: Text('Share'),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
        ),
      ),
    );
  }
}
