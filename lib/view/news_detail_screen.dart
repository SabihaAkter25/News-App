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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SizedBox(
            height: height * 0.45,
            width: width,
            child: ClipRRect(
              child: CachedNetworkImage(
                imageUrl: widget.newsImage,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
                ),
              ),
            ),
          ),
          Container(
            height: height * 0.6,
            margin: EdgeInsets.only(top: height * 0.4),
            padding: const EdgeInsets.only(top: 30, right: 20, left: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Text(
                  widget.newsTitle,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.source,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    Text(
                      format.format(dateTime),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
                SizedBox(height: height * 0.03),
                Text(
                  widget.description,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: height * 0.03),
                // Adding a placeholder for content if it's different from description
                if (widget.content.isNotEmpty && widget.content != widget.description)
                  Text(
                    widget.content,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 50),
              ],
            ),
          )
        ],
      ),
    );
  }
}
