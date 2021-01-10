import 'dart:convert';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:world_wisdom/model/authentication_model/authentication_model.dart';
import 'package:world_wisdom/model/check_own_course_model/check_own_course_model.dart';
import 'package:world_wisdom/model/course_model/course_detail.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:world_wisdom/model/course_model/course_detail_model.dart';
import 'package:world_wisdom/model/lesson_model/lesson.dart';
import 'package:world_wisdom/model/section_model/section.dart';
import 'package:world_wisdom/model/video_progress_model/video_progress_model.dart';
import 'package:world_wisdom/screen/constants/constants.dart';
import 'package:world_wisdom/screen/key/key.dart';
import 'package:world_wisdom/screen_mode/screen_mode.dart';

class CourseDetailScreen extends StatefulWidget {
  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  VideoPlayerController videoPlayerController;
  bool isLoading = true;
  CourseDetail courseDetail;
  FlickManager flickManager;
  int descriptionMaxLines = 2;
  int currentLesson = -1;
  int currentSection = -1;
  bool isRegistered = false;

  Future<CourseDetail> fetchCourseData(String courseId, String userId) async {
    var response = await http
        .get("${Constants.apiUrl}/course/get-course-detail/$courseId/$userId");
    print(response.body);
    if (response.statusCode == 200) {
      return CourseDetailModel.fromJson(jsonDecode(response.body)).payload;
    }
    return null;
  }

  Future<bool> getFreeCourse(String token, String courseId) async {
    var response = await http.post(
        "${Constants.apiUrl}/payment/get-free-courses",
        body: jsonEncode({"courseId": courseId}),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<CheckOwnCourseModel> checkOwnCourse(
      String token, String courseId) async {
    var response = await http.get(
        "${Constants.apiUrl}/user/check-own-course/$courseId",
        headers: {"Authorization": "Bearer $token"});
    print(response.body);
    if (response.statusCode == 200) {
      return CheckOwnCourseModel.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<VideoProgressModel> getVideoInfo(
      String token, String courseId, String lessonId) async {
    var response = await http.get(
        "${Constants.apiUrl}/lesson/video/$courseId/$lessonId",
        headers: {"Authorization": "Bearer $token"});
    print(response.body);
    if (response.statusCode == 200) {
      VideoProgressModel videoProgressModel =
          VideoProgressModel.fromJson(jsonDecode(response.body));
      return videoProgressModel;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String courseId = ModalRoute.of(context).settings.arguments;
    AuthenticationModel authenticationModel =
        Provider.of<AuthenticationModel>(context);
    Duration duration = Duration();
    if (isLoading) {
      fetchCourseData(courseId, authenticationModel.user.id).then((value) {
        setState(() {
          courseDetail = value;
          duration =
              Duration(seconds: (courseDetail.totalHours * 3600).round());
          videoPlayerController =
              VideoPlayerController.network(courseDetail.promoVidUrl);
          flickManager = FlickManager(
              videoPlayerController: videoPlayerController, autoPlay: false);
        });
        flickManager.flickControlManager.addListener(() {
          ScreenMode mode = Provider.of<ScreenMode>(context, listen: false);
          if (flickManager.flickControlManager.isFullscreen) {
            mode.setFullScreen(true);
          } else {
            mode.setFullScreen(false);
          }
        });
        checkOwnCourse(authenticationModel.token, courseId)
            .then((checkOwnCourseModel) {
          setState(() {
            isRegistered = checkOwnCourseModel.payload.isUserOwnCourse;
          });
          isLoading = false;
        });
      });
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(isRegistered ? Icons.done : Icons.app_registration),
        onPressed: () {
          if (!isRegistered) {
            if (courseDetail.price == 0) {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        insetPadding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        title: Text('Register'),
                        content: Text('Do you want to register this course?'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Yes'),
                            onPressed: () {
                              getFreeCourse(authenticationModel.token, courseId)
                                  .then((value) {
                                setState(() {
                                  isRegistered = value;
                                });
                                Navigator.of(context).pop();
                              });
                            },
                          ),
                        ],
                      ));
            }
          }
        },
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  child: FlickVideoPlayer(flickManager: flickManager),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(20),
                    children: [
                      Text(
                        courseDetail.title,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Chip(
                            avatar: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(courseDetail.instructor.avatar),
                            ),
                            label: Text(courseDetail.instructor.name)),
                      ),
                      Row(
                        children: [
                          Text(
                            "${new DateFormat.yMMMMd().format(courseDetail.createdAt.toLocal())} · ${duration.inHours}h ${duration.inMinutes}m",
                            style: Theme.of(context).textTheme.caption,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          RatingBar.builder(
                            initialRating: courseDetail.formalityPoint,
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
                          Text(
                            " (${courseDetail.ratedNumber})",
                            style: Theme.of(context).textTheme.caption,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        courseDetail.description,
                        maxLines: descriptionMaxLines,
                      ),
                      IconButton(
                          icon: Icon(descriptionMaxLines != null
                              ? Icons.expand_more
                              : Icons.expand_less),
                          onPressed: () {
                            if (descriptionMaxLines != null) {
                              setState(() {
                                descriptionMaxLines = null;
                              });
                            } else {
                              setState(() {
                                descriptionMaxLines = 2;
                              });
                            }
                          }),
                      ExpansionPanelList(
                        expansionCallback: (int index, bool isExpanded) {
                          setState(() {
                            courseDetail.section[index].isExpanded =
                                !isExpanded;
                          });
                        },
                        children: courseDetail.section
                            .map<ExpansionPanel>((Section section) {
                          return ExpansionPanel(
                              headerBuilder:
                                  (BuildContext context, bool isExpanded) {
                                Duration sectionDuration = Duration(
                                    seconds: (section.sumHours * 3600).round());
                                return ListTile(
                                  leading: Container(
                                    height: 40,
                                    width: 40,
                                    child: Center(
                                        child: Text("${section.numberOrder}")),
                                  ),
                                  title: Text(section.name),
                                  subtitle: Text(
                                      "${sectionDuration.inHours > 0 ? "${sectionDuration.inHours}:" : ""}${sectionDuration.inHours > 0 ? (sectionDuration.inMinutes % 60).toString().padLeft(2, '0') : sectionDuration.inMinutes}:${(sectionDuration.inSeconds % 60).toString().padLeft(2, '0')}"),
                                );
                              },
                              body: Container(
                                width: double.infinity,
                                child: Column(
                                  children: section.lesson.map((lesson) {
                                    Duration lessonDuration = Duration(
                                        seconds: (lesson.hours * 3600).round());
                                    return ListTile(
                                      dense: true,
                                      leading: currentSection ==
                                                  section.numberOrder &&
                                              currentLesson ==
                                                  lesson.numberOrder
                                          ? Icon(
                                              Icons.play_circle_fill,
                                              color:
                                                  Theme.of(context).accentColor,
                                            )
                                          : Icon(
                                              Icons.circle,
                                              color: Theme.of(context)
                                                  .backgroundColor,
                                            ),
                                      title: InkWell(
                                        child: Text(lesson.name),
                                        onTap: isRegistered
                                            ? () {
                                                print(lesson.id);
                                                getVideoInfo(
                                                        authenticationModel
                                                            .token,
                                                        courseId,
                                                        lesson.id)
                                                    .then((videoProgressModel) {
                                                  if (videoProgressModel ==
                                                      null) {
                                                    return;
                                                  }
                                                  VideoPlayerController
                                                      newController =
                                                      VideoPlayerController
                                                          .network(
                                                              videoProgressModel
                                                                  .payload
                                                                  .videoUrl);
                                                  flickManager
                                                      .handleChangeVideo(
                                                          newController);
                                                  setState(() {
                                                    currentSection =
                                                        section.numberOrder;
                                                    currentLesson =
                                                        lesson.numberOrder;
                                                  });
                                                });
                                              }
                                            : null,
                                      ),
                                      trailing: Text(
                                          "${lessonDuration.inHours > 0 ? "${lessonDuration.inHours}:" : ""}${lessonDuration.inHours > 0 ? (lessonDuration.inMinutes % 60).toString().padLeft(2, '0') : lessonDuration.inMinutes}:${(lessonDuration.inSeconds % 60).toString().padLeft(2, '0')}"),
                                    );
                                  }).toList(),
                                ),
                              ),
                              isExpanded: section.isExpanded);
                        }).toList(),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
