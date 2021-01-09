import 'package:flutter/material.dart';
import 'package:world_wisdom/model/search_v2_model/search_v2_response.dart';

class VerticalInstructorsListItem extends StatelessWidget {
  final InstructorData instructor;

  VerticalInstructorsListItem(this.instructor);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(instructor.avatar),
        ),
        title: Text(instructor.name),
        subtitle: Text("${instructor.numCourses} Courses"));
  }
}
