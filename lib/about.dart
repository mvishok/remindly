///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  const About({super.key});

  void openUrl(String social) async {
    var url = Uri.parse("https://vishok.me/");
    if (social == "insta") {
      url = Uri.parse("https://instagram.com/vishokmanikantan");
    } else if (social == "github") {
      url = Uri.parse("https://github.com/mvishok");
    } else if (social == "linkedin") {
      url = Uri.parse("https://linkedin.com/in/vishokmanikantan");
    }
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset('assets/images/logo.png', height: 30),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: const Color(0xffffffff),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 50, 16, 0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Text(
                "An app developed by",
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                child: Container(
                  height: 120,
                  width: 120,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset("assets/images/profile.png",
                      fit: BoxFit.cover),
                ),
              ),
              const Text(
                "Vishok Manikantan",
                textAlign: TextAlign.start,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  fontSize: 28,
                  color: Color(0xff000000),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: Text(
                  "Developer",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 18,
                    color: Color(0xff000000),
                  ),
                ),
              ),
              const Text(
                "hello@vishok.me",
                textAlign: TextAlign.start,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 18,
                  color: Color(0xff000000),
                ),
              ),
              InkWell(
                child: const Text(
                  "https://vishok.me/",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  openUrl("profile");
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Card(
                      margin: const EdgeInsets.all(4),
                      color: const Color(0xffffffff),
                      shadowColor: const Color(0xffbdb9b9),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        side: const BorderSide(
                            color: Color(0x4d9e9e9e), width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: IconButton(
                          icon: Image.asset(
                            "assets/images/insta.png",
                            width: 48,
                            height: 48,
                          ),
                          onPressed: () {
                            openUrl("insta");
                          },
                        ),
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.all(4),
                      color: const Color(0xffffffff),
                      shadowColor: const Color(0xffbdb9b9),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        side: const BorderSide(
                            color: Color(0x4d9e9e9e), width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: IconButton(
                          icon: Image.asset(
                            "assets/images/github.png",
                            width: 50,
                            height: 50,
                          ),
                          onPressed: () {
                            openUrl("github");
                          },
                        ),
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.all(4),
                      color: const Color(0xffffffff),
                      shadowColor: const Color(0xffbdb9b9),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        side: const BorderSide(
                            color: Color(0x4d9e9e9e), width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: IconButton(
                          icon: Image.asset(
                            "assets/images/linkedin.png",
                            width: 50,
                            height: 50,
                          ),
                          onPressed: () {
                            openUrl("linkedin");
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
