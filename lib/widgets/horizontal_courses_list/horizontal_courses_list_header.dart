import 'package:flutter/material.dart';
import 'package:world_wisdom/generated/l10n.dart';

class HorizontalCoursesListHeader extends StatelessWidget {
  final String title;
  final Function onPressed;

  HorizontalCoursesListHeader(this.title, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline6,
        ),
        TextButton(
            onPressed: onPressed, child: Text("${S.of(context).seeAll} >"))
      ],
    );
  }
}
