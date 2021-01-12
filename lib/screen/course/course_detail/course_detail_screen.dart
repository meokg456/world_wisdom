import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:world_wisdom/generated/l10n.dart';
import 'package:world_wisdom/model/authentication_model/authentication_model.dart';
import 'package:world_wisdom/model/course_model/check_own_course_model.dart';
import 'package:world_wisdom/model/course_model/course.dart';
import 'package:world_wisdom/model/course_model/course_detail.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:world_wisdom/model/course_model/course_detail_model.dart';
import 'package:world_wisdom/model/course_model/course_model.dart';
import 'package:world_wisdom/model/exercise_model/exercises_in_lesson_model.dart';
import 'package:world_wisdom/model/lesson_model/last_watched_lesson_model.dart';
import 'package:world_wisdom/model/lesson_model/lesson.dart';
import 'package:world_wisdom/model/rate_model/rating.dart';
import 'package:world_wisdom/model/section_model/section.dart';
import 'package:world_wisdom/model/video_progress_model/video_progress_model.dart';
import 'package:world_wisdom/screen/constants/constants.dart';
import 'package:world_wisdom/screen/screen_mode/app_mode.dart';
import 'package:world_wisdom/widgets/custom_rounded_rectangle_track_shape/custom_rounded_rectangle_track_shape.dart';
import 'package:world_wisdom/widgets/horizontal_courses_list/horizontal_courses_list.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CourseDetailScreen extends StatefulWidget {
  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  VideoPlayerController videoPlayerController;
  AuthenticationModel authenticationModel;
  bool isLoading = true;
  CourseDetail courseDetail;
  int descriptionMaxLines = 2;
  String currentLessonId;
  bool isRegistered = false;
  bool isExercisesExpanded = false;
  bool isLiked = false;
  bool isFullScreen = false;
  bool isControlHided = false;
  bool isVideoEnded = false;
  bool isYoutubeFullScreen = false;
  bool isRatingExpanded = false;
  bool isUserRatingExpanded = false;
  double learnedHours = 0;
  String videoId;
  Duration youtubeLastWatchedPosition = Duration();
  ExercisesInLessonModel exercisesInLessonModel;
  Future<void> initialize;
  double playedRatio = 0.0;
  Rating userRating;
  Timer videoControlTimer;
  YoutubePlayerController youtubePlayerController;

  Future<CourseDetail> fetchCourseData(String courseId) async {
    var response = await http.get(
        "${Constants.apiUrl}/course/get-course-detail/$courseId/${authenticationModel.user == null ? "null" : authenticationModel.user.id}");
    print(response.body);
    if (response.statusCode == 200) {
      return CourseDetailModel.fromJson(jsonDecode(response.body)).payload;
    }
    return null;
  }

  Future<bool> getLikeStatus(String courseId) async {
    var response = await http.get(
        "${Constants.apiUrl}/user/get-course-like-status/$courseId",
        headers: {"Authorization": "Bearer ${authenticationModel.token}"});
    print(response.body);
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      return json['likeStatus'] == null ? false : json['likeStatus'];
    }
    return false;
  }

  void rateSubmit() async {
    var response = await http.post("${Constants.apiUrl}/course/rating-course",
        headers: {
          "Authorization": "Bearer ${authenticationModel.token}",
          "Content-Type": "application/json"
        },
        body: jsonEncode(userRating.toJson()));
    print(response.body);
    if (response.statusCode == 200) {
      Rating rating = Rating.fromJson(jsonDecode(response.body)["payload"]);
      rating.user = authenticationModel.user;
      rating.averagePoint = (rating.formalityPoint +
              rating.contentPoint +
              rating.presentationPoint) /
          3;
      int index = courseDetail.ratings.ratingList
          .indexWhere((element) => element.user.id == rating.user.id);
      setState(() {
        courseDetail.ratings.ratingList[index] = rating;
        isUserRatingExpanded = false;
      });

      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                title: Text(S.of(context).thankYou),
                content: Text(S.of(context).rateSuccess),
                actions: <Widget>[
                  TextButton(
                    child: Text(S.of(context).gotIt),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
    }
  }

  Future<bool> likeCourse(String courseId) async {
    var response = await http.post("${Constants.apiUrl}/user/like-course",
        body: jsonEncode({"courseId": courseId}),
        headers: {
          "Authorization": "Bearer ${authenticationModel.token}",
          "Content-Type": "application/json"
        });
    print(response.body);
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      return json['likeStatus'] == null ? false : json['likeStatus'];
    }
    return false;
  }

  Future<ExercisesInLessonModel> fetchExercisesInLesson(String lessonId) async {
    var response = await http.post(
        "${Constants.apiUrl}/exercise/student/list-exercise-lesson",
        body: jsonEncode({"lessonId": lessonId}),
        headers: {
          "Authorization": "Bearer ${authenticationModel.token}",
          "Content-Type": "application/json"
        });
    print(response.body);
    if (response.statusCode == 200) {
      return ExercisesInLessonModel.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<bool> getFreeCourse(String courseId) async {
    var response = await http.post(
        "${Constants.apiUrl}/payment/get-free-courses",
        body: jsonEncode({"courseId": courseId}),
        headers: {
          "Authorization": "Bearer ${authenticationModel.token}",
          "Content-Type": "application/json"
        });
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<LastWatchedLessonModel> getLastWatchedLesson(String courseId) async {
    var response = await http.get(
        "${Constants.apiUrl}/course/last-watched-lesson/$courseId",
        headers: {
          "Authorization": "Bearer ${authenticationModel.token}",
          "Content-Type": "application/json"
        });
    print(response.body);
    if (response.statusCode == 200) {
      return LastWatchedLessonModel.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<CheckOwnCourseModel> checkOwnCourse(String courseId) async {
    var response = await http.get(
        "${Constants.apiUrl}/user/check-own-course/$courseId",
        headers: {"Authorization": "Bearer ${authenticationModel.token}"});
    print(response.body);
    if (response.statusCode == 200) {
      return CheckOwnCourseModel.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<VideoProgressModel> getVideoInfo(
      String courseId, String lessonId) async {
    var response = await http.get(
        "${Constants.apiUrl}/lesson/video/$courseId/$lessonId",
        headers: {"Authorization": "Bearer ${authenticationModel.token}"});
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
    videoControlTimer = Timer(Duration(seconds: 2), () {
      setState(() {
        if (videoPlayerController != null) if (videoPlayerController
            .value.isPlaying) isControlHided = true;
      });
    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  void updateCurrentVideoPosition(double currentTime) async {
    if ((currentLessonId != null &&
            videoPlayerController != null &&
            videoPlayerController.value.duration != null) ||
        (videoId != null && currentLessonId != null)) {
      var response = await http.put(
          "${Constants.apiUrl}/lesson/update-current-time-learn-video",
          body: jsonEncode(
              {"lessonId": currentLessonId, "currentTime": currentTime}),
          headers: {
            "Authorization": "Bearer ${authenticationModel.token}",
            "Content-Type": "application/json"
          });
      print(response.body);
    }
  }

  void finishLesson() async {
    var response = await http.post("${Constants.apiUrl}/lesson/update-status",
        body: jsonEncode({"lessonId": currentLessonId}),
        headers: {
          "Authorization": "Bearer ${authenticationModel.token}",
          "Content-Type": "application/json"
        });
    print(response.body);
  }

  void updateVideoPlayer() {
    if (videoPlayerController.value.position ==
        videoPlayerController.value.duration) {
      videoControlTimer.cancel();
      setState(() {
        isControlHided = false;
        isVideoEnded = true;
      });
      finishLesson();
    }
    double ratio = videoPlayerController.value.position.inSeconds /
        videoPlayerController.value.duration.inSeconds;
    if (ratio > 0.9) {
      Lesson currentLesson;
      courseDetail.section.forEach((section) {
        section.lesson.forEach((lesson) {
          if (currentLessonId == lesson.id) {
            currentLesson = lesson;
            return;
          }
        });
      });
      setState(() {
        currentLesson.currentProgress.isFinish = true;
      });
      finishLesson();
    }
    print(ratio);
    updateCurrentVideoPosition(
        videoPlayerController.value.position.inSeconds.toDouble());
    setState(() {
      playedRatio = ratio;
    });
  }

  void initVideoPlayer(String videoUrl, Duration start) {
    if (videoPlayerController != null) {
      videoPlayerController.pause();
      videoPlayerController.dispose();
    }

    setState(() {
      videoPlayerController = VideoPlayerController.network(videoUrl);
      initialize = videoPlayerController.initialize().whenComplete(() {
        if (videoPlayerController.value.duration != null) {
          videoPlayerController.addListener(updateVideoPlayer);
          videoPlayerController.seekTo(start);
        }
      });
      isFullScreen = false;
      isControlHided = false;
      isVideoEnded = false;
      playedRatio = 0.0;
    });
  }

  void initYoutubeVideoPlayer() {
    setState(() {
      youtubePlayerController =
          YoutubePlayerController(initialVideoId: videoId);
    });
  }

  void enterFullScreen() {
    AppMode screenMode = Provider.of<AppMode>(context, listen: false);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    screenMode.setFullScreen(true);
  }

  void exitFullScreen() {
    AppMode screenMode = Provider.of<AppMode>(context, listen: false);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    screenMode.setFullScreen(false);
  }

  Future<bool> onPop() async {
    if (isFullScreen) {
      setState(() {
        isFullScreen = false;
      });
      AppMode screenMode = Provider.of<AppMode>(context, listen: false);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      screenMode.setFullScreen(false);
      return false;
    }
    return true;
  }

  void onScreenTap() {
    videoControlTimer.cancel();
    if (videoPlayerController.value.isPlaying) {
      setState(() {
        isControlHided = !isControlHided;
      });
      videoControlTimer = Timer(Duration(seconds: 2), () {
        setState(() {
          if (videoPlayerController.value.isPlaying) isControlHided = true;
        });
      });
    }
  }

  Widget getVideoPlayerWidget() {
    return courseDetail.promoVidUrl == null
        ? Container(
            height: 220, child: Center(child: CircularProgressIndicator()))
        : FutureBuilder(
            future: initialize,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  videoPlayerController.value.duration != null) {
                // If the VideoPlayerController has finished initialization, use
                // the data it provides to limit the aspect ratio of the VideoPlayer.
                return Container(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: onScreenTap,
                    child: AspectRatio(
                      aspectRatio: videoPlayerController.value.aspectRatio,
                      // Use the VideoPlayer widget to display the video.
                      child: Stack(children: [
                        VideoPlayer(videoPlayerController),
                        AnimatedOpacity(
                          opacity: !isControlHided ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 500),
                          child: Container(
                            color: Colors.black38,
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: !isControlHided ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 500),
                          child: Center(
                            child: IconButton(
                              icon: Icon(
                                isVideoEnded
                                    ? Icons.replay
                                    : videoPlayerController.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                size: 40,
                              ),
                              onPressed: () {
                                if (isControlHided) {
                                  onScreenTap();
                                  return;
                                }
                                videoControlTimer.cancel();
                                if (isVideoEnded) {
                                  videoPlayerController
                                      .seekTo(Duration())
                                      .whenComplete(() {
                                    setState(() {
                                      isVideoEnded = false;
                                    });
                                  });
                                }
                                if (videoPlayerController.value.isPlaying) {
                                  videoPlayerController.pause();
                                } else {
                                  videoPlayerController.play();
                                  videoControlTimer =
                                      Timer(Duration(seconds: 2), () {
                                    if (videoPlayerController.value.isPlaying)
                                      setState(() {
                                        isControlHided = true;
                                      });
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: !isControlHided ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 500),
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "${videoPlayerController.value.position.inHours > 0 ? "${videoPlayerController.value.position.inHours}:" : ""}${videoPlayerController.value.position.inHours > 0 ? (videoPlayerController.value.position.inMinutes % 60).toString().padLeft(2, '0') : videoPlayerController.value.position.inMinutes}:${(videoPlayerController.value.position.inSeconds % 60).toString().padLeft(2, '0')} / ${videoPlayerController.value.duration.inHours > 0 ? "${videoPlayerController.value.duration.inHours}:" : ""}${videoPlayerController.value.duration.inHours > 0 ? (videoPlayerController.value.duration.inMinutes % 60).toString().padLeft(2, '0') : videoPlayerController.value.duration.inMinutes}:${(videoPlayerController.value.duration.inSeconds % 60).toString().padLeft(2, '0')}",
                              ),
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: !isControlHided ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 500),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              margin: EdgeInsets.only(
                                  bottom: isFullScreen ? 10 : 0),
                              child: IconButton(
                                icon: Icon(isFullScreen
                                    ? Icons.fullscreen_exit
                                    : Icons.fullscreen),
                                onPressed: () {
                                  if (isControlHided) {
                                    onScreenTap();
                                    return;
                                  }
                                  if (isFullScreen) {
                                    exitFullScreen();
                                  } else {
                                    enterFullScreen();
                                  }
                                  setState(() {
                                    isFullScreen = !isFullScreen;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: !isControlHided ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 500),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              margin: EdgeInsets.only(
                                  bottom: isFullScreen ? 10 : 0),
                              height: 20,
                              child: SliderTheme(
                                data: SliderThemeData(
                                  overlayShape:
                                      RoundSliderOverlayShape(overlayRadius: 0),
                                  trackShape:
                                      CustomRoundedRectSliderTrackShape(),
                                ),
                                child: Slider(
                                  onChanged: (double value) {
                                    if (isControlHided) {
                                      onScreenTap();
                                      return;
                                    }
                                    Duration seekDuration = Duration(
                                        seconds: (value *
                                                videoPlayerController
                                                    .value.duration.inSeconds)
                                            .round());
                                    videoPlayerController
                                        .seekTo(seekDuration)
                                        .whenComplete(() {
                                      setState(() {
                                        playedRatio = value;
                                        isVideoEnded = false;
                                      });
                                      videoPlayerController.play();
                                      videoControlTimer =
                                          Timer(Duration(seconds: 2), () {
                                        setState(() {
                                          if (videoPlayerController.value
                                              .isPlaying) isControlHided = true;
                                        });
                                      });
                                    });
                                  },
                                  value: playedRatio,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                );
              } else {
                // If the VideoPlayerController is still initializing, show a
                // loading spinner.
                return Container(
                    height: 220,
                    child: Center(child: CircularProgressIndicator()));
              }
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    String courseId = ModalRoute.of(context).settings.arguments;
    authenticationModel = Provider.of<AuthenticationModel>(context);
    CourseModel favoriteCourseModel = Provider.of<CourseModel>(context);

    //Load data
    if (isLoading) {
      fetchCourseData(courseId).then((value) {
        setState(() {
          courseDetail = value;
          print("video url: ${courseDetail.promoVidUrl}");
        });
        userRating = Rating(
            formalityPoint: 0,
            presentationPoint: 0,
            contentPoint: 0,
            courseId: courseDetail.id,
            content: "");
        initVideoPlayer(courseDetail.promoVidUrl, Duration());

        getLastWatchedLesson(courseId).then((lastLessonModel) {
          if (lastLessonModel == null) return;
          courseDetail.section.forEach((section) {
            section.lesson.forEach((lesson) {
              String id = YoutubePlayer.convertUrlToId(
                  lastLessonModel.payload.videoUrl);

              if (id != null) {
                setState(() {
                  youtubePlayerController =
                      YoutubePlayerController(initialVideoId: id);
                  videoId = id;
                });
                youtubeLastWatchedPosition = Duration(
                    seconds: lastLessonModel.payload.currentTime.round());
              } else {
                initVideoPlayer(
                    lastLessonModel.payload.videoUrl,
                    Duration(
                        seconds: lastLessonModel.payload.currentTime.round()));
              }
              if (lastLessonModel.payload.lessonId == lesson.id) {
                fetchExercisesInLesson(lesson.id).then((value) {
                  setState(() {
                    exercisesInLessonModel = value;
                    section.isExpanded = true;
                    currentLessonId = lesson.id;
                  });
                });
              }
            });
          });
        });

        checkOwnCourse(courseId).then((checkOwnCourseModel) {
          setState(() {
            isRegistered = checkOwnCourseModel.payload.isUserOwnCourse;
          });
        });
        getLikeStatus(courseId).then((value) {
          setState(() {
            isLiked = value;
          });
        });
        setState(() {
          isLoading = false;
        });
      });
    } else {
      learnedHours = 0;
      courseDetail.section.forEach((section) {
        section.lesson.forEach((lesson) {
          if (lesson.currentProgress != null) {
            setState(() {
              if (lesson.currentProgress.isFinish) {
                learnedHours += lesson.hours;
              } else {
                learnedHours += lesson.currentProgress.currentTime / 3600;
              }
            });
          }
          print(learnedHours);
        });
      });
    }
    return WillPopScope(
      onWillPop: onPop,
      child: Scaffold(
        floatingActionButton: isFullScreen || isYoutubeFullScreen
            ? null
            : FloatingActionButton(
                mini: true,
                child: Icon(isRegistered ? Icons.done : Icons.app_registration),
                onPressed: () {
                  if (!isRegistered) {
                    if (courseDetail.price == 0) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                insetPadding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 10),
                                title: Text(S.of(context).register),
                                content: Text(
                                    S.of(context).registerCourseConfirmation),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(S.of(context).signOutCancel),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text(S.of(context).register),
                                    onPressed: () {
                                      getFreeCourse(courseId).then((value) {
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
                  videoId != null
                      ? Expanded(
                          child: Container(
                            child: YoutubePlayerBuilder(
                              player: YoutubePlayer(
                                controller: youtubePlayerController,
                                showVideoProgressIndicator: true,
                                onEnded: (data) {
                                  setState(() {
                                    Lesson currentLesson;
                                    courseDetail.section.forEach((section) {
                                      section.lesson.forEach((lesson) {
                                        if (currentLessonId == lesson.id) {
                                          currentLesson = lesson;
                                          return;
                                        }
                                      });
                                    });
                                    currentLesson.currentProgress.isFinish =
                                        true;
                                  });
                                  finishLesson();
                                },
                                onReady: () {
                                  youtubePlayerController.addListener(() {
                                    if (youtubePlayerController
                                                .value.position.inSeconds /
                                            youtubePlayerController
                                                .metadata.duration.inSeconds >
                                        0.9) {
                                      Lesson currentLesson;
                                      courseDetail.section.forEach((section) {
                                        section.lesson.forEach((lesson) {
                                          if (currentLessonId == lesson.id) {
                                            currentLesson = lesson;
                                            return;
                                          }
                                        });
                                      });
                                      setState(() {
                                        currentLesson.currentProgress.isFinish =
                                            true;
                                      });
                                      finishLesson();
                                    }
                                    updateCurrentVideoPosition(
                                        youtubePlayerController
                                            .value.position.inSeconds
                                            .toDouble());
                                  });
                                  youtubePlayerController
                                      .seekTo(youtubeLastWatchedPosition);
                                },
                              ),
                              builder: (context, player) {
                                return player;
                              },
                              onExitFullScreen: () {
                                AppMode screenMode = Provider.of<AppMode>(
                                    context,
                                    listen: false);
                                screenMode.setFullScreen(false);
                                setState(() {
                                  isYoutubeFullScreen = false;
                                });
                              },
                              onEnterFullScreen: () {
                                AppMode screenMode = Provider.of<AppMode>(
                                    context,
                                    listen: false);
                                screenMode.setFullScreen(true);
                                setState(() {
                                  isYoutubeFullScreen = true;
                                });
                              },
                            ),
                          ),
                        )
                      : isYoutubeFullScreen || isFullScreen
                          ? Expanded(child: getVideoPlayerWidget())
                          : getVideoPlayerWidget(),
                  isYoutubeFullScreen || isFullScreen
                      ? SizedBox()
                      : Expanded(
                          child: ListView(
                            padding: EdgeInsets.only(
                                left: 20, top: 20, right: 20, bottom: 100),
                            children: [
                              Text(
                                courseDetail.title,
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Chip(
                                    avatar: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          courseDetail.instructor.avatar),
                                    ),
                                    label: Text(courseDetail.instructor.name)),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${new DateFormat.yMMMMd().format(courseDetail.createdAt.toLocal())} · ${Duration(seconds: (learnedHours * 3600).round()).inHours}h ${Duration(seconds: (learnedHours * 3600).round()).inMinutes}m / ${Duration(seconds: (courseDetail.totalHours * 3600).round()).inHours}h ${Duration(seconds: (courseDetail.totalHours * 3600).round()).inMinutes}m",
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
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 1),
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
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Chip(
                                    avatar: courseDetail.price == 0
                                        ? Icon(
                                            Icons.done,
                                            color: Colors.green,
                                          )
                                        : Icon(
                                            Icons.attach_money,
                                            color: Colors.yellow,
                                          ),
                                    label: Text(
                                      courseDetail.price == 0
                                          ? S.of(context).free
                                          : NumberFormat.currency(
                                                  locale:
                                                      Localizations.localeOf(
                                                              context)
                                                          .toString())
                                              .format(courseDetail.price),
                                    )),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          isLiked
                                              ? Icons.favorite
                                              : Icons.favorite_outline,
                                          color: Colors.redAccent,
                                        ),
                                        onPressed: () {
                                          likeCourse(courseId).then((value) {
                                            setState(() {
                                              isLiked = value;
                                            });
                                            Course course = Course(
                                              id: courseDetail.id,
                                              title: courseDetail.title,
                                              price: courseDetail.price,
                                              imageUrl: courseDetail.imageUrl,
                                              instructorId:
                                                  courseDetail.instructorId,
                                              instructorUserName:
                                                  courseDetail.instructor.name,
                                              contentPoint:
                                                  courseDetail.contentPoint,
                                              formalityPoint:
                                                  courseDetail.formalityPoint,
                                              presentationPoint: courseDetail
                                                  .presentationPoint,
                                            );
                                            favoriteCourseModel.add(course);
                                          });
                                        },
                                      ),
                                      Text(S.of(context).like)
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.share,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () {},
                                      ),
                                      Text(S.of(context).share)
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.download_rounded),
                                        onPressed: () {},
                                      ),
                                      Text(S.of(context).download)
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Card(
                                margin: EdgeInsets.all(0),
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    courseDetail.subtitle,
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Card(
                                margin: EdgeInsets.all(0),
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          S.of(context).achievement,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Column(
                                            children: courseDetail.learnWhat
                                                .map((skill) {
                                              return ListTile(
                                                  contentPadding:
                                                      EdgeInsets.all(0),
                                                  dense: true,
                                                  leading: Icon(
                                                    Icons.done,
                                                    color: Colors.green,
                                                  ),
                                                  title: Text("- $skill"));
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                margin: EdgeInsets.all(0),
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          S.of(context).requirement,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Column(
                                            children: courseDetail.requirement
                                                .map((skill) {
                                              return ListTile(
                                                  contentPadding:
                                                      EdgeInsets.all(0),
                                                  dense: true,
                                                  leading: Icon(
                                                    Icons.done,
                                                    color: Colors.green,
                                                  ),
                                                  title: Text("$skill"));
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Card(
                                margin: EdgeInsets.all(0),
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          S.of(context).descriptions,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          courseDetail.description,
                                          maxLines: descriptionMaxLines,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
                                expansionCallback:
                                    (int index, bool isExpanded) {
                                  setState(() {
                                    courseDetail.section[index].isExpanded =
                                        !isExpanded;
                                  });
                                },
                                children: courseDetail.section
                                    .map<ExpansionPanel>((Section section) {
                                  return ExpansionPanel(
                                      headerBuilder: (BuildContext context,
                                          bool isExpanded) {
                                        Duration sectionDuration = Duration(
                                            seconds: (section.sumHours * 3600)
                                                .round());
                                        return ListTile(
                                          leading: Container(
                                            height: 40,
                                            width: 40,
                                            child: Center(
                                                child: Text(
                                                    "${section.numberOrder}")),
                                          ),
                                          title: Text(section.name),
                                          subtitle: Text(
                                              "${sectionDuration.inHours > 0 ? "${sectionDuration.inHours}:" : ""}${sectionDuration.inHours > 0 ? (sectionDuration.inMinutes % 60).toString().padLeft(2, '0') : sectionDuration.inMinutes}:${(sectionDuration.inSeconds % 60).toString().padLeft(2, '0')}"),
                                        );
                                      },
                                      body: Container(
                                        width: double.infinity,
                                        child: Column(
                                          children:
                                              section.lesson.map((lesson) {
                                            Duration lessonDuration = Duration(
                                                seconds: (lesson.hours * 3600)
                                                    .round());
                                            if (isRegistered &&
                                                lesson.currentProgress ==
                                                    null) {
                                              getVideoInfo(courseId, lesson.id)
                                                  .then((videoProgressModel) {
                                                lesson.currentProgress =
                                                    videoProgressModel.payload;
                                              });
                                            }
                                            return Column(
                                              children: [
                                                ListTile(
                                                  onTap: isRegistered
                                                      ? () {
                                                          print(lesson.id);
                                                          getVideoInfo(courseId,
                                                                  lesson.id)
                                                              .then(
                                                                  (videoProgressModel) {
                                                            if (videoProgressModel ==
                                                                null) {
                                                              return;
                                                            }
                                                            String id = YoutubePlayer
                                                                .convertUrlToId(
                                                                    videoProgressModel
                                                                        .payload
                                                                        .videoUrl);

                                                            if (id != null) {
                                                              if (youtubePlayerController ==
                                                                  null) {
                                                                videoId = id;
                                                                initYoutubeVideoPlayer();
                                                              } else
                                                                youtubePlayerController
                                                                    .load(id);
                                                            } else
                                                              initVideoPlayer(
                                                                  videoProgressModel
                                                                      .payload
                                                                      .videoUrl,
                                                                  Duration(
                                                                      seconds: videoProgressModel
                                                                          .payload
                                                                          .currentTime
                                                                          .round()));
                                                            fetchExercisesInLesson(
                                                                    lesson.id)
                                                                .then((value) {
                                                              setState(() {
                                                                exercisesInLessonModel =
                                                                    value;
                                                                currentLessonId =
                                                                    lesson.id;
                                                              });
                                                            });
                                                          });
                                                        }
                                                      : null,
                                                  dense: true,
                                                  leading: currentLessonId ==
                                                          lesson.id
                                                      ? Icon(
                                                          Icons
                                                              .play_circle_fill,
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                        )
                                                      : (lesson.currentProgress !=
                                                                  null
                                                              ? lesson
                                                                  .currentProgress
                                                                  .isFinish
                                                              : false)
                                                          ? Icon(
                                                              Icons.done,
                                                              color:
                                                                  Colors.green,
                                                            )
                                                          : Icon(
                                                              Icons.circle,
                                                              color: Theme.of(
                                                                      context)
                                                                  .backgroundColor,
                                                            ),
                                                  title: InkWell(
                                                    child: Text(lesson.name),
                                                  ),
                                                  trailing: Text(
                                                      "${lessonDuration.inHours > 0 ? "${lessonDuration.inHours}:" : ""}${lessonDuration.inHours > 0 ? (lessonDuration.inMinutes % 60).toString().padLeft(2, '0') : lessonDuration.inMinutes}:${(lessonDuration.inSeconds % 60).toString().padLeft(2, '0')}"),
                                                ),
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      isExpanded: section.isExpanded);
                                }).toList(),
                              ),
                              exercisesInLessonModel == null ||
                                      exercisesInLessonModel
                                              .payload.exercises.length ==
                                          0
                                  ? SizedBox()
                                  : ExpansionPanelList(
                                      expansionCallback:
                                          (int index, bool isExpanded) {
                                        setState(() {
                                          isExercisesExpanded =
                                              !isExercisesExpanded;
                                        });
                                      },
                                      children: [
                                        ExpansionPanel(
                                            headerBuilder:
                                                (BuildContext context,
                                                    bool isExpanded) {
                                              return ListTile(
                                                title: Text(
                                                    S.of(context).exercise),
                                              );
                                            },
                                            body: Column(
                                              children: exercisesInLessonModel
                                                  .payload.exercises
                                                  .map((exercise) {
                                                return ListTile(
                                                  dense: true,
                                                  leading: Icon(
                                                    Icons.article_outlined,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                  ),
                                                  title: Text(exercise.title),
                                                );
                                              }).toList(),
                                            ),
                                            isExpanded: isExercisesExpanded)
                                      ],
                                    ),
                              SizedBox(
                                height: 20,
                              ),
                              ExpansionPanelList(
                                expansionCallback:
                                    (int index, bool isExpanded) {
                                  setState(() {
                                    isRatingExpanded = !isRatingExpanded;
                                  });
                                },
                                children: [
                                  ExpansionPanel(
                                      headerBuilder: (BuildContext context,
                                          bool isExpanded) {
                                        return ListTile(
                                          leading: Icon(
                                            Icons.rate_review,
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                          title: Text(S.of(context).rating),
                                        );
                                      },
                                      body: Column(
                                        children: courseDetail
                                            .ratings.ratingList
                                            .map((rating) {
                                          return Column(
                                            children: [
                                              Divider(
                                                thickness: 1,
                                              ),
                                              ListTile(
                                                dense: true,
                                                title: ListTile(
                                                  contentPadding:
                                                      EdgeInsets.all(0),
                                                  dense: true,
                                                  leading: CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                            rating.user.avatar),
                                                  ),
                                                  title: ListTile(
                                                      trailing: Text(
                                                          "${DateFormat.yMMMMd().format(rating.createdAt.toLocal())}"),
                                                      contentPadding:
                                                          EdgeInsets.all(0),
                                                      title: Text(
                                                          rating.user.name)),
                                                  subtitle: RatingBar.builder(
                                                    initialRating:
                                                        rating.averagePoint,
                                                    minRating: 1,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    itemCount: 5,
                                                    itemSize: 12,
                                                    itemPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 1),
                                                    itemBuilder: (context, _) =>
                                                        Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                    ignoreGestures: true,
                                                    onRatingUpdate:
                                                        (double value) {},
                                                  ),
                                                ),
                                                subtitle: ListTile(
                                                  contentPadding:
                                                      EdgeInsets.all(0),
                                                  title: Text(
                                                    rating.content,
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                      isExpanded: isRatingExpanded)
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Card(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Column(
                                    children: [
                                      ListTile(
                                          onTap: () {
                                            setState(() {
                                              isUserRatingExpanded =
                                                  !isUserRatingExpanded;
                                            });
                                          },
                                          contentPadding: EdgeInsets.all(0),
                                          leading: Icon(
                                            Icons.star_rate_rounded,
                                            color: Colors.amber,
                                          ),
                                          title: Text(S.of(context).leaveRate)),
                                      !isUserRatingExpanded
                                          ? SizedBox()
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Icon(Icons.article_outlined,
                                                    color: Theme.of(context)
                                                        .accentColor),
                                                Expanded(
                                                  child: Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child: Text(
                                                        "${S.of(context).contentPoint}:"),
                                                  ),
                                                ),
                                                RatingBar.builder(
                                                  initialRating: 0,
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 5,
                                                  itemSize: 24,
                                                  itemPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 1),
                                                  itemBuilder: (context, _) =>
                                                      Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                                  onRatingUpdate:
                                                      (double value) {
                                                    userRating.contentPoint =
                                                        value;
                                                  },
                                                ),
                                              ],
                                            ),
                                      !isUserRatingExpanded
                                          ? SizedBox()
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Icon(
                                                    Icons
                                                        .add_to_photos_outlined,
                                                    color: Theme.of(context)
                                                        .accentColor),
                                                Expanded(
                                                  child: Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child: Text(
                                                        "${S.of(context).formalityPoint}:"),
                                                  ),
                                                ),
                                                RatingBar.builder(
                                                  initialRating: 0,
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 5,
                                                  itemSize: 24,
                                                  itemPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 1),
                                                  itemBuilder: (context, _) =>
                                                      Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                                  onRatingUpdate:
                                                      (double value) {
                                                    userRating.formalityPoint =
                                                        value;
                                                  },
                                                ),
                                              ],
                                            ),
                                      !isUserRatingExpanded
                                          ? SizedBox()
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Icon(Icons.present_to_all,
                                                    color: Theme.of(context)
                                                        .accentColor),
                                                Expanded(
                                                  child: Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child: Text(
                                                        "${S.of(context).presentationPoint}:"),
                                                  ),
                                                ),
                                                RatingBar.builder(
                                                  initialRating: 0,
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 5,
                                                  itemSize: 24,
                                                  itemPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 1),
                                                  itemBuilder: (context, _) =>
                                                      Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                                  onRatingUpdate:
                                                      (double value) {
                                                    userRating
                                                            .presentationPoint =
                                                        value;
                                                  },
                                                ),
                                              ],
                                            ),
                                      !isUserRatingExpanded
                                          ? SizedBox()
                                          : Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: TextField(
                                                onChanged: (text) {
                                                  userRating.content = text;
                                                },
                                                decoration: InputDecoration(
                                                    hintText:
                                                        "${S.of(context).comments}...",
                                                    border:
                                                        OutlineInputBorder()),
                                              ),
                                            ),
                                      !isUserRatingExpanded
                                          ? SizedBox()
                                          : Align(
                                              alignment: Alignment.bottomRight,
                                              child: ElevatedButton(
                                                  onPressed: () {
                                                    rateSubmit();
                                                  },
                                                  child:
                                                      Text(S.of(context).rate)),
                                            ),
                                      !isUserRatingExpanded
                                          ? SizedBox()
                                          : IconButton(
                                              icon: Icon(Icons.arrow_drop_up),
                                              onPressed: () {
                                                setState(() {
                                                  isUserRatingExpanded = false;
                                                });
                                              })
                                    ],
                                  ),
                                ),
                              ),
                              Text(
                                S.of(context).sameCategory,
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              HorizontalCoursesList(CourseModel(
                                  courses: courseDetail.coursesLikeCategory))
                            ],
                          ),
                        ),
                ],
              ),
      ),
    );
  }
}
