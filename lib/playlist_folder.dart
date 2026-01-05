import 'package:flutter/material.dart';
import 'playlist_music.dart';
class PlaylistFolder extends StatelessWidget {
  var playlist=['playlist 1', 'playlist 2' ,'playlist 3'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar similar to CupertinoNavigationBar
      appBar: PreferredSize(
        preferredSize:  Size.fromHeight(85.0), // custom height
        child: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white, // ✅ back arrow color
          ),// centers the title automatically
          title: Text(
            "Music",
            style: TextStyle(
              color: Colors.white,
              fontSize: 40, // large text
            ),
          ),

        ),
      ),




      // Body with background image and centered text
      body: Column(
          
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child:Container(
                height: 100,
                width: double.infinity,
                alignment: Alignment.center, // ✅ This centers the child
                child: Text(
                  "Playlist",
                  style: TextStyle(
                    fontSize: 60,
                    color: Colors.purpleAccent,
                    decoration: TextDecoration.underline, // ✅ underline
                    decorationColor: Colors.purpleAccent,      // optional: underline color
                    decorationThickness: 1,
                  ),
                ),
              ),
        
            ),
            SizedBox(
              height: 15,
            ),

            Expanded(
              child: ListView.separated(
                itemCount: playlist.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Container(
                      height: 180,
                        width: 100,
                        color: Colors.blueGrey,
                        child: Icon(Icons.folder_copy_rounded,color: Colors.white60,size: 50,)),
                    title:Row(
                      children: [
                        SizedBox(
                          width: 75,
                        ),
                        Text(playlist[index],style: TextStyle(fontSize: 25,color: Colors.white60),),
                      ],
                    ),
                    onTap: () {
                      // Navigate to PlaylistMusic page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlaylistMusic(),
                        ),
                      );
                    },


                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    thickness: 2,
                    color: Colors.black,
                  );
                },
              ),
            ),
          ],
        ),




    );
  }
}