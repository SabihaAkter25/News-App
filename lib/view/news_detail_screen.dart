import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NewsDetailScreen extends StatefulWidget {
final String newsImage, newsTitle, newsDate, author, description,content, source;

  const NewsDetailScreen({super.key,
    required this.newsImage,
    required this.newsTitle,
    required this.newsDate,
    required this.author,
    required this.description,
    required this.content,
    required this.source
  });

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {

 final format = DateFormat('MMM dd yyyy');

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width * 1;
    var height = MediaQuery.sizeOf(context).height * 1;
    DateTime dateTime = DateTime.parse(widget.newsDate);
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            height: height * .45,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(40),
              ),
              child: CachedNetworkImage(
                  imageUrl: widget.newsImage,
                fit: BoxFit.cover,
                placeholder: (context,url)=>Center(child: CircularProgressIndicator()),

              ),
            ),
          ),
          Container(
            height: height*0.6,
            margin: EdgeInsets.only(top: height*.4),
            padding: EdgeInsets.only(top: 20,right: 20,left: 20),
            decoration: BoxDecoration(
              color: Colors.white
            ),
            child: ListView(
              children: [
                Text(widget.newsTitle,style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight:FontWeight.w700,
                  color: Colors.black87,
                ),),
                SizedBox(height: height*.02,),
                Row(
                  children: [
                    Expanded(
                      child: Text(widget.source,style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight:FontWeight.w600,
                        color: Colors.blue,
                      ),),
                    ),
                    Text(format.format(dateTime),style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight:FontWeight.w600,
                      color: Colors.blue,
                    ),)
                  ],
                ),
                SizedBox(height: height*.03,),

                Text(widget.description,style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight:FontWeight.w600,
                  color: Colors.black87,
                ),),
              ],
            ),
          )
        ],

      ),
    );
  }
}
