import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app225/model/news_channel_headlines_model.dart';
import 'package:news_app225/view_model/news_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  final format = DateFormat('MMMM dd, yyyy');

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width * 1;
    var height = MediaQuery.sizeOf(context).height * 1;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset("images/category_icon.png", height: 33),
          onPressed: () {},
        ),
        title: Center(
          child: Text(
            "News",
            style:
                GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      body: ListView(
        children: [
          // Headline for the news section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                "Top Headlines",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.55,
            width: width,
            child: Stack(
              children: [
                FutureBuilder<NewsChannelHeadLinesModel>(
                  future: newsViewModel.fetchNewsChannelHeadlinesApi(),
                  builder: (BuildContext context,
                      AsyncSnapshot<NewsChannelHeadLinesModel> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: SpinKitCircle(
                          color: Colors.blue,
                          size: 50,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (snapshot.hasData &&
                        snapshot.data!.articles!.isNotEmpty) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.articles!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: SizedBox(
                              height: height * 0.9,
                              width: width * 0.999,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot.data!
                                                .articles![index].urlToImage ??
                                            '',
                                        fit: BoxFit.cover,
                                        width: width,
                                        height: height,
                                        placeholder: (context, url) =>
                                            Container(
                                          alignment: Alignment.center,
                                          child: spinkit2,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 20, // Position the card 20 pixels from the bottom
                                    left: 20,   // Optional: add padding to the left
                                    right: 20,  // Optional: add padding to the right
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      color: Colors.white.withOpacity(0.8), // Slightly transparent background
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0), // Padding inside the card
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              snapshot.data!.articles![index].title.toString(), // Article title
                                              maxLines: 2, // Limit to 2 lines
                                              overflow: TextOverflow.ellipsis, // Add ellipsis for overflowing text
                                              textAlign: TextAlign.center, // Center-align the text
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black, // Text color
                                              ),
                                            ),
                                            const SizedBox(height: 8), // Spacing between title and source/date
                                            Text(
                                              snapshot.data!.articles![index].source!.name.toString(), // Article source
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey[800], // Lighter text color for source
                                              ),
                                            ),
                                            Text(
                                              format.format(DateTime.parse(snapshot.data!.articles![index].publishedAt.toString())), // Article date
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300,
                                                color: Colors.blue[800], // Even lighter text color for date
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text('No data available'),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const spinkit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);
