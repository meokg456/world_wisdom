
import 'package:flutter/material.dart';

class BrowseTab extends StatefulWidget {
  @override
  _BrowseTabState createState() => _BrowseTabState();
}

class _BrowseTabState extends State<BrowseTab> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 20, left: 20),
      children: [
        Container(
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 3),
                child: Text("Sign in to skill up today",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Text("Keep your skills up-to-date with access to thousands of courses by industry experts",
                style: TextStyle(
                  fontSize: 20
                ),),
              ),
              ElevatedButton(onPressed: () {}, child: Text(
                "SIGN IN TO START WATCHING",
                style: TextStyle(
                  fontSize: 17.5
                ),
              )),
            ],
          ),
        ),

        Container(
          margin: EdgeInsets.only(top: 10, right: 15),
          child: Stack(
            alignment: AlignmentDirectional.center,
            fit: StackFit.passthrough,
            children: [
              Image.network("https://blog.prezi.com/wp-content/uploads/2019/03/jason-leung-479251-unsplash.jpg",
              height: 100,
              fit: BoxFit.fill,),
              Text("NEW\nRELEASES",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24
                ),
              ),
            ]
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10, right: 15),
          child: Stack(
              alignment: AlignmentDirectional.center,
              fit: StackFit.passthrough,
              children: [
                Image.network("https://blog.prezi.com/wp-content/uploads/2019/03/jason-leung-479251-unsplash.jpg",
                  height: 100,
                  fit: BoxFit.fill,),
                Text("RECOMMENDED\nFOR YOU",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 24
                  ),
                ),
              ]
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          height: 150,
          child: GridView.count(crossAxisCount: 2,
          scrollDirection: Axis.horizontal,
          childAspectRatio: 0.5,
          children: [
            Container(
              margin: EdgeInsets.only(right: 5, top: 5, bottom: 5),
              child: Stack(
                  alignment: AlignmentDirectional.center,
                  fit: StackFit.passthrough,
                  children: [
                    Image.network("https://blog.prezi.com/wp-content/uploads/2019/03/jason-leung-479251-unsplash.jpg",
                      height: 100,
                      fit: BoxFit.fill,),
                    Text("RECOMMENDED\nFOR YOU",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12
                      ),
                    ),
                  ]
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 5, top: 5, bottom: 5),
              child: Stack(
                  alignment: AlignmentDirectional.center,
                  fit: StackFit.passthrough,
                  children: [
                    Image.network("https://blog.prezi.com/wp-content/uploads/2019/03/jason-leung-479251-unsplash.jpg",
                      height: 100,
                      fit: BoxFit.fill,),
                    Text("RECOMMENDED\nFOR YOU",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12
                      ),
                    ),
                  ]
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 5, top: 5, bottom: 5),
              child: Stack(
                  alignment: AlignmentDirectional.center,
                  fit: StackFit.passthrough,
                  children: [
                    Image.network("https://blog.prezi.com/wp-content/uploads/2019/03/jason-leung-479251-unsplash.jpg",
                      height: 100,
                      fit: BoxFit.fill,),
                    Text("RECOMMENDED\nFOR YOU",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12
                      ),
                    ),
                  ]
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 5, top: 5, bottom: 5),
              child: Stack(
                  alignment: AlignmentDirectional.center,
                  fit: StackFit.passthrough,
                  children: [
                    Image.network("https://blog.prezi.com/wp-content/uploads/2019/03/jason-leung-479251-unsplash.jpg",
                      height: 100,
                      fit: BoxFit.fill,),
                    Text("RECOMMENDED\nFOR YOU",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12
                      ),
                    ),
                  ]
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 5, top: 5, bottom: 5),
              child: Stack(
                  alignment: AlignmentDirectional.center,
                  fit: StackFit.passthrough,
                  children: [
                    Image.network("https://blog.prezi.com/wp-content/uploads/2019/03/jason-leung-479251-unsplash.jpg",
                      height: 100,
                      fit: BoxFit.fill,),
                    Text("RECOMMENDED\nFOR YOU",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12
                      ),
                    ),
                  ]
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 5, top: 5, bottom: 5),
              child: Stack(
                  alignment: AlignmentDirectional.center,
                  fit: StackFit.passthrough,
                  children: [
                    Image.network("https://blog.prezi.com/wp-content/uploads/2019/03/jason-leung-479251-unsplash.jpg",
                      height: 100,
                      fit: BoxFit.fill,),
                    Text("RECOMMENDED\nFOR YOU",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12
                      ),
                    ),
                  ]
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 5, top: 5, bottom: 5),
              child: Stack(
                  alignment: AlignmentDirectional.center,
                  fit: StackFit.passthrough,
                  children: [
                    Image.network("https://blog.prezi.com/wp-content/uploads/2019/03/jason-leung-479251-unsplash.jpg",
                      height: 100,
                      fit: BoxFit.fill,),
                    Text("RECOMMENDED\nFOR YOU",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12
                      ),
                    ),
                  ]
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 5, top: 5, bottom: 5),
              child: Stack(
                  alignment: AlignmentDirectional.center,
                  fit: StackFit.passthrough,
                  children: [
                    Image.network("https://blog.prezi.com/wp-content/uploads/2019/03/jason-leung-479251-unsplash.jpg",
                      height: 100,
                      fit: BoxFit.fill,),
                    Text("RECOMMENDED\nFOR YOU",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12
                      ),
                    ),
                  ]
              ),
            ),
          ],
          ),
        )
      ],
      );
  }
}