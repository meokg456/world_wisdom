import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:world_wisdom/screen/key/key.dart';
import 'package:world_wisdom/screen/main_screen/main_app_bar/main_app_bar.dart';

class BrowseTab extends StatefulWidget {
  @override
  _BrowseTabState createState() => _BrowseTabState();
}

class _BrowseTabState extends State<BrowseTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainTabAppBar("Browse"),
      body: ListView(
        padding: EdgeInsets.only(top: 20, left: 20),
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 3),
                  child: Text(
                    "Sign in to skill up today",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Keep your skills up-to-date with access to thousands of courses by industry experts",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(right: 20),
                  child: ElevatedButton(
                      onPressed: () {
                        Keys.appNavigationKey.currentState
                            .pushNamed("/authentication/login");
                      },
                      child: Text(
                        "SIGN IN TO START WATCHING",
                        style: TextStyle(fontSize: 17.5),
                      )),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, right: 15),
            child: Stack(
                alignment: AlignmentDirectional.center,
                fit: StackFit.passthrough,
                children: [
                  Image.asset(
                    "resources/images/new-release.jpeg",
                    height: 100,
                    fit: BoxFit.fill,
                    colorBlendMode: BlendMode.darken,
                    color: Color(0xA0000000),
                  ),
                  Text(
                    "NEW\nRELEASES",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                  ),
                ]),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, right: 15),
            child: Stack(
                alignment: AlignmentDirectional.center,
                fit: StackFit.passthrough,
                children: [
                  Image.asset(
                    "resources/images/recommended.jpg",
                    height: 100,
                    fit: BoxFit.fill,
                    colorBlendMode: BlendMode.darken,
                    color: Color(0xA0000000),
                  ),
                  Text(
                    "RECOMMENDED\nFOR YOU",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                  ),
                ]),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            height: 150,
            child: GridView.count(
              crossAxisCount: 2,
              scrollDirection: Axis.horizontal,
              childAspectRatio: 0.5,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 5, top: 5),
                  child: Stack(
                      alignment: AlignmentDirectional.center,
                      fit: StackFit.passthrough,
                      children: [
                        Image.asset(
                          "resources/images/conferences.jpg",
                          height: 100,
                          fit: BoxFit.fill,
                          colorBlendMode: BlendMode.darken,
                          color: Color(0xA0000000),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text("CONFERENCES",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.bebasNeue(
                                  fontSize: 32, fontWeight: FontWeight.w100)),
                        ),
                      ]),
                ),
                Container(
                  margin: EdgeInsets.only(right: 5, top: 5),
                  child: Stack(
                      alignment: AlignmentDirectional.center,
                      fit: StackFit.passthrough,
                      children: [
                        Image.asset(
                          "resources/images/generic.jpg",
                          height: 100,
                          fit: BoxFit.fill,
                          colorBlendMode: BlendMode.darken,
                          color: Color(0xA0000000),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text("CERTIFICATIONS",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.bitter(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                        ),
                      ]),
                ),
                Container(
                  margin: EdgeInsets.only(right: 5, top: 5),
                  child: Stack(
                      alignment: AlignmentDirectional.center,
                      fit: StackFit.passthrough,
                      children: [
                        Image.asset(
                          "resources/images/software-development.jpg",
                          height: 100,
                          fit: BoxFit.fill,
                          colorBlendMode: BlendMode.darken,
                          color: Color(0xA0000000),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "<Software>",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 24),
                            ),
                            Text(
                              "DEVELOPMENT",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ]),
                ),
                Container(
                  margin: EdgeInsets.only(right: 5, top: 5),
                  child: Stack(fit: StackFit.passthrough, children: [
                    Image.asset(
                      "resources/images/it-ops.jpg",
                      height: 100,
                      fit: BoxFit.fill,
                      colorBlendMode: BlendMode.darken,
                      color: Color(0xA0000000),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("IT",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSerif(
                                fontWeight: FontWeight.bold, fontSize: 40)),
                        Text(
                          "OPS",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ]),
                ),
                Container(
                  margin: EdgeInsets.only(right: 5, top: 5),
                  child: Stack(fit: StackFit.passthrough, children: [
                    Image.asset(
                      "resources/images/information-cybersecurity.jpg",
                      height: 100,
                      fit: BoxFit.fill,
                      colorBlendMode: BlendMode.darken,
                      color: Color(0xA0000000),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Information",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSerif(
                                fontWeight: FontWeight.w300, fontSize: 16)),
                        Text(
                          "AND",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w300),
                        ),
                        Text(
                          "CYBER SECURITY",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ]),
                ),
                Container(
                  margin: EdgeInsets.only(right: 5, top: 5),
                  child: Stack(fit: StackFit.passthrough, children: [
                    Image.asset(
                      "resources/images/data-professional.jpg",
                      height: 100,
                      fit: BoxFit.fill,
                      colorBlendMode: BlendMode.darken,
                      color: Color(0xA0000000),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("DATA",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.ralewayDots(
                                fontWeight: FontWeight.w500, fontSize: 44)),
                        Text(
                          "PROFESSIONAL",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ]),
                ),
                Container(
                  margin: EdgeInsets.only(right: 5, top: 5),
                  child: Stack(fit: StackFit.passthrough, children: [
                    Image.asset(
                      "resources/images/business-professional.jpg",
                      height: 100,
                      fit: BoxFit.fill,
                      colorBlendMode: BlendMode.darken,
                      color: Color(0xA0000000),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("BUSINESS",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSerif(
                                fontWeight: FontWeight.bold, fontSize: 24)),
                        Text(
                          "PROFESSIONAL",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ]),
                ),
                Container(
                  margin: EdgeInsets.only(right: 5, top: 5),
                  child: Stack(fit: StackFit.passthrough, children: [
                    Image.asset(
                      "resources/images/creative-professional.jpg",
                      height: 100,
                      fit: BoxFit.fill,
                      colorBlendMode: BlendMode.darken,
                      color: Color(0xA0000000),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Creative",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cherrySwash(
                              fontWeight: FontWeight.normal,
                              fontSize: 32,
                              fontStyle: FontStyle.italic),
                        ),
                        Text(
                          "PROFESSIONAL",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ]),
                ),
                Container(
                  margin: EdgeInsets.only(right: 5, top: 5),
                  child: Stack(fit: StackFit.passthrough, children: [
                    Image.asset(
                      "resources/images/manufacturing-design.jpg",
                      height: 100,
                      fit: BoxFit.fill,
                      colorBlendMode: BlendMode.darken,
                      color: Color(0xA0000000),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("MANUFACTURING",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSerif(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        Text(
                          "AND",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w300),
                        ),
                        Text(
                          "DESIGN",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ]),
                ),
                Container(
                  margin: EdgeInsets.only(right: 5, top: 5),
                  child: Stack(fit: StackFit.passthrough, children: [
                    Image.asset(
                      "resources/images/architecture-construction.jpg",
                      height: 100,
                      fit: BoxFit.fill,
                      colorBlendMode: BlendMode.darken,
                      color: Color(0xA0000000),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("ARCHITECTURE",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSerif(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(
                          "AND",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w300),
                        ),
                        Text(
                          "CONSTRUCTION",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ]),
                ),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                "Popular Skills",
                style: TextStyle(fontSize: 18),
              )),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            height: 32,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text("Angular"),
                ),
                SizedBox(
                  width: 5,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text("JavaScript"),
                ),
                SizedBox(
                  width: 5,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text("C#"),
                ),
                SizedBox(
                  width: 5,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text("Java"),
                ),
                SizedBox(
                  width: 5,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text("Data Analysis"),
                ),
                SizedBox(
                  width: 5,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text("ASP.NET"),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Paths",
                  style: TextStyle(fontSize: 18),
                ),
                InkWell(
                  child: Text("See all >"),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset("resources/images/security.png"),
                          Text("Red Team Tools"),
                          Text("36 courses"),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset("resources/images/security.png"),
                          Text("Red Team Tools"),
                          Text("36 courses"),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset("resources/images/security.png"),
                          Text("Red Team Tools"),
                          Text("36 courses"),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset("resources/images/security.png"),
                          Text("Red Team Tools"),
                          Text("36 courses"),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                "Top authors",
                style: TextStyle(fontSize: 18),
              )),
          Container(
            margin: EdgeInsets.only(top: 20),
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            AssetImage("resources/images/conferences.jpg"),
                        radius: 50,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Deborah Kurata",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            AssetImage("resources/images/conferences.jpg"),
                        radius: 50,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Deborah Kurata",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            AssetImage("resources/images/conferences.jpg"),
                        radius: 50,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Deborah Kurata",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            AssetImage("resources/images/conferences.jpg"),
                        radius: 50,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Deborah Kurata",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            AssetImage("resources/images/conferences.jpg"),
                        radius: 50,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Deborah Kurata",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
