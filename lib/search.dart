import 'package:flutter/material.dart';
import 'youtube.dart';
import 'homepage.dart';

class SearchPage extends StatelessWidget {
  @override
  var serch;
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // 👈 Page background color

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120.0), // 👈 Adjust AppBar height
        child: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true, // 👈 Center the title
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Music",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),


      // Body with background image and centered text
      body:Column(
        children: [
          Container(
            margin:  EdgeInsets.only(top: 23),
            // 👈 Top margin
            child: TextField(
              controller: serch,
              style:  TextStyle(color: Colors.white), // 👈 Text color white
              decoration: InputDecoration(
                hintText: "Search Music here",
                hintStyle:TextStyle(color: Colors.white70), // 👈 Hint text also light white
                prefixIcon: IconButton(
                  icon:Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    print("Search button pressed");
                  },
                ),
                suffixIcon: IconButton(
                  icon:Icon(Icons.mic_sharp, color: Colors.white),
                  onPressed: () {
                    print("Mic button pressed");
                  },
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.purple, width: 3),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:BorderSide(color: Colors.blueAccent ,width: 2),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "love",
            style: TextStyle(
              color: Colors.white60, // 👈 use inside TextStyle
              fontSize: 18,          // optional
              fontWeight: FontWeight.bold, // optional
            ),
          ),

        ],
      ),



        floatingActionButton: SafeArea(
        child: Container(
          margin:  EdgeInsets.only(bottom: 12, left: 16, right: 16),
          padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
                color: Color(0xFF2356D8),

                // outline color
                width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset:  Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:  [
              InkWell(

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.library_music, color: Colors.white),
                    SizedBox(height: 4),
                    Text("My Music", style: TextStyle(color: Colors.white)),
                  ],
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  HomePage(),
                    ),
                  );
                },
              ),
              // Search
              InkWell(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search, color: Colors.white),
                    SizedBox(height: 4),
                    Text("Search", style: TextStyle(color: Colors.white)),
                  ],
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  SearchPage(),
                    ),
                  );
                },
              ),
              // YouTube
              InkWell(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.video_collection_rounded, color: Colors.white),
                    SizedBox(height: 4),
                    Text("YouTube", style: TextStyle(color: Colors.white)),
                  ],
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  YouTubePage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );
  }
}
