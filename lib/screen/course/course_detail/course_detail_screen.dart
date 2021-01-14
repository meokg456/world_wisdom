import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:sqflite/sqflite.dart';
import 'package:video_player/video_player.dart';
import 'package:world_wisdom/generated/l10n.dart';
import 'package:world_wisdom/handler/handler.dart';
import 'package:world_wisdom/model/authentication_model/authentication_model.dart';
import 'package:world_wisdom/model/course_model/check_own_course_model.dart';
import 'package:world_wisdom/model/course_model/course.dart';
import 'package:world_wisdom/model/course_model/course_detail.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:world_wisdom/model/course_model/course_detail_model.dart';
import 'package:world_wisdom/model/course_model/downloaded_courses_model.dart';
import 'package:world_wisdom/model/course_model/favorite_courses/favorite_courses_model.dart';
import 'package:world_wisdom/model/exercise_model/exercises_in_lesson_model.dart';
import 'package:world_wisdom/model/lesson_model/last_watched_lesson_model.dart';
import 'package:world_wisdom/model/lesson_model/lesson.dart';
import 'package:world_wisdom/model/rate_model/rating.dart';
import 'package:world_wisdom/model/section_model/section.dart';
import 'package:world_wisdom/model/video_progress_model/video_progress_model.dart';
import 'package:world_wisdom/screen/constants/constants.dart';
import 'package:world_wisdom/screen/screen_mode/app_mode.dart';
import 'package:world_wisdom/sql_lite/database_connector.dart';
import 'package:world_wisdom/widgets/custom_rounded_rectangle_track_shape/custom_rounded_rectangle_track_shape.dart';
import 'package:world_wisdom/widgets/horizontal_courses_list/horizontal_courses_list.dart';
import 'package:world_wisdom/widgets/rating/horizontal_rating_statistic_item.dart';
import 'package:world_wisdom/widgets/rating/rating_list_item.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CourseDetailScreen extends StatefulWidget {
  final CourseDetail courseDetail;

  CourseDetailScreen(this.courseDetail);

  @override
  _CourseDetailScreenState createState() =>
      _CourseDetailScreenState(this.courseDetail);
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  Database database;
  VideoPlayerController videoPlayerController;
  AuthenticationModel authenticationModel;
  bool isLoading = true;
  CourseDetail courseDetail;
  Lesson currentLesson;
  int descriptionMaxLines = 2;
  bool isRegistered = false;
  bool isExercisesExpanded = false;
  bool isYoutubeVideo = false;
  bool isLiked = false;
  bool isFullScreen = false;
  bool isControlHided = false;
  bool isVideoEnded = false;
  bool isRatingExpanded = false;
  bool isUserRatingExpanded = false;
  double downloadRatio = 0;

  bool isDownloaded = false;
  int totalVideos = 0;
  double learnedHours = 0;
  Future<void> initialize;
  double playedRatio = 0.0;
  Rating userRating;
  Timer videoControlTimer;
  YoutubePlayerController youtubePlayerController;

  Map<String, int> receivedBytesMap = {};
  Map<String, int> totalBytesMap = {};

  _CourseDetailScreenState(CourseDetail courseDetail) {
    this.courseDetail = courseDetail;
  }

  void loadData() {
    checkOwnCourse(courseDetail.id);
    checkLikeStatus(courseDetail.id);
    fetchCourseData(courseDetail.id);
    userRating = Rating(
        formalityPoint: 0,
        presentationPoint: 0,
        contentPoint: 0,
        courseId: courseDetail.id,
        content: "");
  }

  Future<void> getVideoData(String courseId) async {
    LastWatchedLessonModel lastLessonModel =
        await getLastWatchedLesson(courseId);
    learnedHours = 0;
    for (int i = 0; i < courseDetail.sections.length; i++) {
      Section section = courseDetail.sections[i];
      for (int j = 0; j < section.lessons.length; j++) {
        Lesson lesson = section.lessons[j];

        VideoProgressModel videoProgressModel =
            await getVideoInfo(courseId, lesson.id);

        lesson.currentProgress = videoProgressModel.payload;
        if (lesson.currentProgress.isFinish) {
          learnedHours += lesson.hours;
        } else {
          learnedHours += lesson.currentProgress.currentTime / 3600;
        }
        if (lastLessonModel.payload.lessonId == lesson.id) {
          section.isExpanded = true;
          selectLesson(lesson);
        }

        ExercisesInLessonModel exercisesInLessonModel =
            await fetchExercisesInLesson(lesson.id);
        lesson.exercises = exercisesInLessonModel.payload.exercises;
      }
    }
  }

  void fetchCourseData(String courseId) async {
    setState(() {
      isLoading = true;
    });
    var response = await http.get(
        "${Constants.apiUrl}/course/get-course-detail/$courseId/${authenticationModel.user == null ? "null" : authenticationModel.user.id}");
    print(response.body);
    if (response.statusCode == 200) {
      courseDetail =
          CourseDetailModel.fromJson(jsonDecode(response.body)).payload;

      loadVideoPlayer(courseDetail.promoVidUrl, Duration());
      if (isRegistered) {
        getVideoData(courseId);
      }
    } else {
      videoControlTimer.cancel();
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      isLoading = false;
    });
  }

  void checkLikeStatus(String courseId) async {
    var response = await http.get(
        "${Constants.apiUrl}/user/get-course-like-status/$courseId",
        headers: {"Authorization": "Bearer ${authenticationModel.token}"});
    print(response.body);
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      setState(() {
        isLiked = json['likeStatus'] == null ? false : json['likeStatus'];
      });
    }
    if (response.statusCode == 401) {
      Handler.unauthorizedHandler(context);
    }
  }

  void rateSubmit() async {
    var response = await http.post("${Constants.apiUrl}/course/rating-course",
        headers: {
          "Authorization": "Bearer ${authenticationModel.token}",
          "Content-Type": "application/json"
        },
        body: jsonEncode(userRating.toRateSubmitJson()));
    print(response.body);
    if (response.statusCode == 200) {
      var response = await http.get(
          "${Constants.apiUrl}/course/get-course-detail/${courseDetail.id}/${authenticationModel.user == null ? "null" : authenticationModel.user.id}");
      print(response.body);
      if (response.statusCode == 200) {
        CourseDetail data =
            CourseDetailModel.fromJson(jsonDecode(response.body)).payload;
        setState(() {
          courseDetail.ratings = data.ratings;
          courseDetail.ratedNumber = data.ratedNumber;
          courseDetail.contentPoint = data.contentPoint;
          courseDetail.formalityPoint = data.formalityPoint;
          courseDetail.presentationPoint = data.presentationPoint;
          courseDetail.averagePoint = data.averagePoint;
          isUserRatingExpanded = false;
        });
      }

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
    if (response.statusCode == 401) {
      Handler.unauthorizedHandler(context);
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
    if (response.statusCode == 401) {
      Handler.unauthorizedHandler(context);
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
    if (response.statusCode == 401) {
      Handler.unauthorizedHandler(context);
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
    if (response.statusCode == 401) {
      Handler.unauthorizedHandler(context);
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
    if (response.statusCode == 401) {
      Handler.unauthorizedHandler(context);
    }
    return null;
  }

  void checkOwnCourse(String courseId) async {
    var response = await http.get(
        "${Constants.apiUrl}/user/check-own-course/$courseId",
        headers: {"Authorization": "Bearer ${authenticationModel.token}"});
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        isRegistered = CheckOwnCourseModel.fromJson(jsonDecode(response.body))
            .payload
            .isUserOwnCourse;
      });
    }
    if (response.statusCode == 401) {
      Handler.unauthorizedHandler(context);
    }
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
    if (response.statusCode == 401) {
      Handler.unauthorizedHandler(context);
    }
    return null;
  }

  Future<void> downloadVideo(String url, String fileName) async {
    if (!url.contains(".mp4")) return;
    Dio dio = Dio();
    totalVideos++;

    try {
      var dir = await getApplicationDocumentsDirectory();
      String videoPath = path.join(dir.path, "$fileName.mp4");
      database.insert("videos", {"id": fileName, "videoPath": videoPath});
      await dio.download(url, videoPath, onReceiveProgress: (rec, total) {
        receivedBytesMap[fileName] = rec;
        totalBytesMap[fileName] = total;

        int receivedBytes = 0;
        int totalBytes = 0;
        receivedBytesMap.values.forEach((element) {
          receivedBytes += element;
        });
        totalBytesMap.values.forEach((element) {
          totalBytes += element;
        });
        setState(() {
          downloadRatio = receivedBytes / totalBytes;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> downloadImage(String url, String fileName) async {
    Dio dio = Dio();

    try {
      var dir = await getApplicationDocumentsDirectory();
      String ext = path.extension(url);
      String imagePath = path.join(dir.path, "$fileName$ext");
      database.insert("images", {"courseId": fileName, "imagePath": imagePath});
      await dio.download(url, imagePath, onReceiveProgress: (rec, total) {
        receivedBytesMap["$fileName-img"] = rec;
        totalBytesMap["$fileName-img"] = total;

        int receivedBytes = 0;
        int totalBytes = 0;
        receivedBytesMap.values.forEach((element) {
          receivedBytes += element;
        });
        totalBytesMap.values.forEach((element) {
          totalBytes += element;
        });
        setState(() {
          downloadRatio = receivedBytes / totalBytes;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  void downloadCourse() async {
    for (var section in courseDetail.sections) {
      for (var lesson in section.lessons) {
        if (lesson.currentProgress.videoUrl.contains("youtube")) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    insetPadding:
                        EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    title: Text(S.of(context).downloadDenied),
                    content: Text(S.of(context).downloadDeniedMessage),
                    actions: <Widget>[
                      TextButton(
                        child: Text(S.of(context).gotIt),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ));
          return;
        }
      }
    }
    var dir = await getApplicationDocumentsDirectory();
    downloadVideo(courseDetail.promoVidUrl, courseDetail.id);
    downloadImage(courseDetail.imageUrl, courseDetail.id);
    String ext = path.extension(courseDetail.imageUrl);
    courseDetail.imageUrl = path.join(dir.path, "${courseDetail.id}$ext");
    courseDetail.promoVidUrl = path.join(dir.path, "${courseDetail.id}.mp4");
    if (currentLesson != null)
      database.insert("lastWatchLesson",
          {"courseId": courseDetail.id, "data": jsonEncode(currentLesson)});
    for (var section in courseDetail.sections) {
      for (var lesson in section.lessons) {
        downloadVideo(lesson.currentProgress.videoUrl, lesson.id);
        lesson.currentProgress.videoUrl =
            path.join(dir.path, "${lesson.id}.mp4");
      }
    }
    await database.insert("courses",
        {"id": courseDetail.id, "data": jsonEncode(courseDetail.toJson())});
    Provider.of<DownloadedCoursesModel>(context, listen: false)
        .add(courseDetail);
  }

  @override
  void initState() {
    super.initState();

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

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      database = await DatabaseConnector.database;
      if (!isDownloaded) {
        loadData();
      } else {
        setState(() {
          isLoading = false;
          isRegistered = true;
        });
        var lastWatchLessons = await database.query("lastWatchLesson",
            where: "courseId = ?", whereArgs: [courseDetail.id]);
        Lesson lastWatchLesson;
        for (var lesson in lastWatchLessons)
          lastWatchLesson = Lesson.fromJson(jsonDecode(lesson["data"]));
        for (var section in courseDetail.sections) {
          for (var lesson in section.lessons) {
            if (lesson.id == lastWatchLesson.id) {
              setState(() {
                section.isExpanded = true;
                selectLesson(lesson);
              });
            }
          }
        }
      }
    });
  }

  @override
  void dispose() {
    if (videoPlayerController != null) videoPlayerController.dispose();
    if (youtubePlayerController != null) youtubePlayerController.dispose();
    super.dispose();
  }

  void onShare(BuildContext context) async {
    final RenderBox box = context.findRenderObject();
    await Share.share("${Constants.webUrl}/course-detail/${courseDetail.id}",
        subject: "${S.of(context).share} course - World wisdom",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  void updateCurrentVideoPosition(double currentTime) async {
    if ((videoPlayerController != null &&
            videoPlayerController.value.duration != null) ||
        (isYoutubeVideo && currentLesson.id != null)) {
      var response = await http.put(
          "${Constants.apiUrl}/lesson/update-current-time-learn-video",
          body: jsonEncode(
              {"lessonId": currentLesson.id, "currentTime": currentTime}),
          headers: {
            "Authorization": "Bearer ${authenticationModel.token}",
            "Content-Type": "application/json"
          });
      if (response.statusCode == 401) {
        Handler.unauthorizedHandler(context);
      }
    }
  }

  void finishLesson() async {
    var response = await http.post("${Constants.apiUrl}/lesson/update-status",
        body: jsonEncode({"lessonId": currentLesson.id}),
        headers: {
          "Authorization": "Bearer ${authenticationModel.token}",
          "Content-Type": "application/json"
        });
    if (response.statusCode == 401) {
      Handler.unauthorizedHandler(context);
    }
  }

  void updateVideoPlayer() {
    double ratio = videoPlayerController.value.position.inSeconds /
        videoPlayerController.value.duration.inSeconds;
    if (ratio == 1) {
      videoControlTimer.cancel();
      setState(() {
        isControlHided = false;
        isVideoEnded = true;
      });
      if (isRegistered) finishLesson();
    }
    if (isRegistered) {
      if (ratio > 0.9) {
        setState(() {
          currentLesson.currentProgress.isFinish = true;
        });
        finishLesson();
      }
      updateCurrentVideoPosition(
          videoPlayerController.value.position.inSeconds.toDouble());
    }
    setState(() {
      playedRatio = ratio;
    });
  }

  void loadVideoPlayer(String videoUrl, Duration start) {
    if (videoPlayerController != null) {
      videoPlayerController.pause();
      VideoPlayerController old = videoPlayerController;
      setState(() {
        videoPlayerController = null;
      });

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        old.dispose();
      });
    }
    if (isDownloaded)
      videoPlayerController = VideoPlayerController.file(File(videoUrl));
    else
      videoPlayerController = VideoPlayerController.network(videoUrl);
    setState(() {
      try {
        initialize = videoPlayerController.initialize().then((value) {
          if (videoPlayerController.value.position != null) {
            videoPlayerController.addListener(updateVideoPlayer);
            videoPlayerController.seekTo(start);
          }
        });
      } on Error catch (error) {
        print(error);
      }
      isFullScreen = false;
      isControlHided = false;
      isVideoEnded = false;
      playedRatio = 0.0;
      isYoutubeVideo = false;
    });
  }

  void updateYoutubePlayer() {
    if (youtubePlayerController.value.position.inSeconds /
            youtubePlayerController.metadata.duration.inSeconds >
        0.9) {
      setState(() {
        currentLesson.currentProgress.isFinish = true;
      });
      finishLesson();
    }
    updateCurrentVideoPosition(
        youtubePlayerController.value.position.inSeconds.toDouble());
  }

  void loadYoutubePlayer(String videoId, Duration start) {
    if (youtubePlayerController != null) {
      youtubePlayerController.load(videoId, startAt: start.inSeconds);
      setState(() {
        isYoutubeVideo = true;
      });
    } else {
      youtubePlayerController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: YoutubePlayerFlags(startAt: start.inSeconds));
    }
    setState(() {
      isYoutubeVideo = true;
    });
  }

  void enterFullScreen() {
    AppMode screenMode = Provider.of<AppMode>(context, listen: false);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    setState(() {
      isFullScreen = true;
    });
    screenMode.setFullScreen(true);
  }

  void exitFullScreen() {
    AppMode screenMode = Provider.of<AppMode>(context, listen: false);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    setState(() {
      isFullScreen = false;
    });
    screenMode.setFullScreen(false);
  }

  void selectLesson(Lesson lesson) {
    if (lesson == null) return;
    String videoId =
        YoutubePlayer.convertUrlToId(lesson.currentProgress.videoUrl);

    if (videoId != null) {
      loadYoutubePlayer(videoId,
          Duration(seconds: lesson.currentProgress.currentTime.round()));
    } else
      loadVideoPlayer(lesson.currentProgress.videoUrl,
          Duration(seconds: lesson.currentProgress.currentTime.round()));
    setState(() {
      currentLesson = lesson;
    });
  }

  Future<bool> onPop() async {
    if (isFullScreen) {
      exitFullScreen();
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
    return FutureBuilder(
      future: initialize,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            videoPlayerController != null &&
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
                            videoControlTimer = Timer(Duration(seconds: 2), () {
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
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                        margin: EdgeInsets.only(bottom: isFullScreen ? 10 : 0),
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
                        margin: EdgeInsets.only(bottom: isFullScreen ? 10 : 0),
                        height: 20,
                        child: SliderTheme(
                          data: SliderThemeData(
                            overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 0),
                            trackShape: CustomRoundedRectSliderTrackShape(),
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
                                    if (videoPlayerController.value.isPlaying)
                                      isControlHided = true;
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
              height: 220, child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget getYoutubePlayer() {
    return Container(
      child: YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: youtubePlayerController,
            showVideoProgressIndicator: true,
            onEnded: (data) {
              setState(() {
                currentLesson.currentProgress.isFinish = true;
              });
              finishLesson();
            },
            onReady: () {
              youtubePlayerController.addListener(() {
                updateYoutubePlayer();
              });
            },
          ),
          builder: (context, player) {
            return player;
          },
          onExitFullScreen: exitFullScreen,
          onEnterFullScreen: enterFullScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    FavoriteCoursesModel favoriteCourseModel =
        Provider.of<FavoriteCoursesModel>(context, listen: false);
    CourseDetail downloadedCourse =
        context.select((DownloadedCoursesModel model) {
      return model.find(courseDetail.id);
    });
    if (downloadedCourse != null) {
      isDownloaded = true;
      courseDetail = downloadedCourse;
    }
    authenticationModel = Provider.of<AuthenticationModel>(context);

    return WillPopScope(
      onWillPop: onPop,
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              floatingActionButton: isFullScreen
                  ? null
                  : FloatingActionButton(
                      mini: true,
                      child: Icon(
                          isRegistered ? Icons.done : Icons.app_registration),
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
                                      content: Text(S
                                          .of(context)
                                          .registerCourseConfirmation),
                                      actions: <Widget>[
                                        TextButton(
                                          child:
                                              Text(S.of(context).signOutCancel),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text(S.of(context).register),
                                          onPressed: () {
                                            getFreeCourse(courseDetail.id)
                                                .then((value) {
                                              setState(() {
                                                isRegistered = value;
                                                fetchCourseData(
                                                    courseDetail.id);
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
              body: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  isYoutubeVideo
                      ? Expanded(
                          flex: isFullScreen
                              ? 1
                              : ((MediaQuery.of(context).size.width / 16 * 9) /
                                      MediaQuery.of(context).size.height)
                                  .round(),
                          child: getYoutubePlayer())
                      : isFullScreen
                          ? Expanded(child: getVideoPlayerWidget())
                          : getVideoPlayerWidget(),
                  isFullScreen
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
                              Text(
                                "${new DateFormat.yMMMMd().format(courseDetail.createdAt.toLocal())} · ${Duration(seconds: (learnedHours * 3600).round()).inHours}h ${Duration(seconds: (learnedHours * 3600).round()).inMinutes}m / ${Duration(seconds: (courseDetail.totalHours * 3600).round()).inHours}h ${Duration(seconds: (courseDetail.totalHours * 3600).round()).inMinutes}m",
                                style: Theme.of(context).textTheme.caption,
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
                                          likeCourse(courseDetail.id)
                                              .then((value) {
                                            setState(() {
                                              isLiked = value;
                                            });

                                            if (isLiked) {
                                              Course course = Course(
                                                id: courseDetail.id,
                                                title: courseDetail.title,
                                                price: courseDetail.price,
                                                imageUrl: courseDetail.imageUrl,
                                                instructorId:
                                                    courseDetail.instructorId,
                                                instructorUserName: courseDetail
                                                    .instructor.name,
                                                contentPoint:
                                                    courseDetail.contentPoint,
                                                formalityPoint:
                                                    courseDetail.formalityPoint,
                                                presentationPoint: courseDetail
                                                    .presentationPoint,
                                              );
                                              favoriteCourseModel.add(course);
                                            } else {
                                              favoriteCourseModel
                                                  .remove(courseDetail.id);
                                            }
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
                                        onPressed: () {
                                          onShare(context);
                                        },
                                      ),
                                      Text(S.of(context).share)
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      InkWell(
                                        child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              IconButton(
                                                  icon: downloadedCourse != null
                                                      ? Icon(
                                                          Icons
                                                              .download_done_rounded,
                                                          color: Colors.green,
                                                        )
                                                      : Icon(
                                                          Icons
                                                              .download_rounded,
                                                          color:
                                                              downloadRatio == 0
                                                                  ? Colors
                                                                      .black87
                                                                  : Colors.blue,
                                                        ),
                                                  onPressed: () {}),
                                              CircularProgressIndicator(
                                                  value: downloadRatio),
                                            ]),
                                        onTap: () {
                                          if (downloadedCourse == null) {
                                            downloadCourse();
                                          }
                                        },
                                        customBorder: CircleBorder(),
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
                                    courseDetail.sections[index].isExpanded =
                                        !isExpanded;
                                  });
                                },
                                children: courseDetail.sections
                                    .map<ExpansionPanel>((Section section) {
                                  return ExpansionPanel(
                                      canTapOnHeader: true,
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
                                              section.lessons.map((lesson) {
                                            Duration lessonDuration = Duration(
                                                seconds: (lesson.hours * 3600)
                                                    .round());
                                            return Column(
                                              children: [
                                                ListTile(
                                                  onTap: isRegistered
                                                      ? () {
                                                          selectLesson(lesson);
                                                        }
                                                      : null,
                                                  dense: true,
                                                  leading: (currentLesson !=
                                                              null
                                                          ? currentLesson.id ==
                                                              lesson.id
                                                          : false)
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
                                                  title: Text(lesson.name),
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
                              currentLesson == null ||
                                      currentLesson.exercises == null ||
                                      currentLesson.exercises.length == 0
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
                                            canTapOnHeader: true,
                                            headerBuilder:
                                                (BuildContext context,
                                                    bool isExpanded) {
                                              return ListTile(
                                                title: Text(
                                                    S.of(context).exercise),
                                              );
                                            },
                                            body: Column(
                                              children: currentLesson.exercises
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
                              Card(
                                  margin: EdgeInsets.only(bottom: 0, top: 10),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: Icon(Icons.star,
                                            color: Colors.amber),
                                        title: Text(
                                            "${S.of(context).ratesFromStudent}"),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              children: [
                                                Text(
                                                  courseDetail.averagePoint,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6,
                                                ),
                                                Text(
                                                  "(${courseDetail.ratedNumber} ${S.of(context).rates})",
                                                  maxLines: 1,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "${courseDetail.contentPoint.toStringAsFixed(1)} ${S.of(context).contentPoint}",
                                                  maxLines: 1,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption,
                                                ),
                                                Text(
                                                  "${courseDetail.formalityPoint.toStringAsFixed(1)} ${S.of(context).formalityPoint}",
                                                  maxLines: 1,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption,
                                                ),
                                                Text(
                                                  "${courseDetail.presentationPoint.toStringAsFixed(1)} ${S.of(context).presentationPoint}",
                                                  maxLines: 1,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                                children: [4, 3, 2, 1, 0]
                                                    .map((index) {
                                              return HorizontalRatingStatisticItem(
                                                  index,
                                                  courseDetail
                                                      .ratings.stars[index]);
                                            }).toList()),
                                          )
                                        ],
                                      ),
                                    ],
                                  )),
                              ExpansionPanelList(
                                elevation: 0,
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
                                          title: Text(S.of(context).rates),
                                        );
                                      },
                                      canTapOnHeader: true,
                                      body: Column(
                                        children: courseDetail
                                            .ratings.ratingList
                                            .map((rating) {
                                          return RatingListItem(rating);
                                        }).toList(),
                                      ),
                                      isExpanded: isRatingExpanded)
                                ],
                              ),
                              Card(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 10),
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
                              HorizontalCoursesList(
                                  courseDetail.coursesLikeCategory)
                            ],
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}
