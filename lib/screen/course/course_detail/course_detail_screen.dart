import 'dart:convert';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:world_wisdom/model/authentication_model/authentication_model.dart';
import 'package:world_wisdom/model/course_model/course_detail.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:world_wisdom/model/course_model/course_detail_model.dart';
import 'package:world_wisdom/screen/constants/constants.dart';
import 'package:world_wisdom/screen/key/key.dart';

class CourseDetailScreen extends StatefulWidget {
  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  VideoPlayerController videoPlayerController;
  Future<void> _initializeVideoPlayerFuture;
  bool isLoading = true;
  CourseDetail courseDetail;
  FlickManager flickManager;

  Future<CourseDetail> fetchCourseData(String courseId, String userId) async {
    var response = await http
        .get("${Constants.apiUrl}/course/get-course-detail/$courseId/$userId");
    print(response.body);
    if (response.statusCode == 200) {
      return CourseDetailModel.fromJson(jsonDecode(response.body)).payload;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String courseId = ModalRoute.of(context).settings.arguments;
    String userId =
        context.select((AuthenticationModel model) => model.user.id);
    if (isLoading) {
      fetchCourseData(courseId, userId).then((value) {
        setState(() {
          courseDetail = value;
          videoPlayerController =
              VideoPlayerController.network(courseDetail.promoVidUrl);
          flickManager =
              FlickManager(videoPlayerController: videoPlayerController);
        });
        flickManager.flickControlManager.addListener(() {
          if (flickManager.flickControlManager.isFullscreen) {
            // Keys.appNavigationKey.currentState
            //     .pushNamed("/watching", arguments: videoPlayerController);
            // flickManager.flickControlManager.exitFullscreen();
            BottomNavigationBar bottomNavigationBar =
                Keys.bottomNavigationBarKey.currentWidget;
          }
        });
        isLoading = false;
      });
    }
    return Scaffold(
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Container(
                  child: FlickVideoPlayer(flickManager: flickManager),
                ),
              ],
            ),
    );
  }
}
