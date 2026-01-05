import 'package:flutter/material.dart';

class PlaylistMusic extends StatelessWidget {
  var arrnm=['Saiyaara','Aavan javan ','tera yar hu main','fear song','vande mataram','har kisi ko','swag se karege','jai jai shiv shankar'];

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
      body:  Expanded(
        child: ListView.separated(
          itemCount: arrnm.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Container(
                height: 50,
                width: 50,
                color: Colors.redAccent,
              ),
              title: Text(arrnm[index],style:TextStyle(color: Colors.white,fontSize: 17),),
              subtitle: Text('Number',style:TextStyle(color: Colors.white),),
              trailing: Icon(Icons.play_arrow,color: Colors.white,size: 40,),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              thickness: 2,
              color: Colors.white,
            );
          },
        ),
      ),


    );
  }
}