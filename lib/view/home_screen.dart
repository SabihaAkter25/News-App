import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app225/model/news_channel_headlines_model.dart';
import 'package:news_app225/view_model/news_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset("images/category_icon.png", height: 33),
          onPressed: () {},
        ),
        title: Center(
          child: Text(
            "News",
            style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: media.height * 0.5,

            child: FutureBuilder<NewsChannelHeadLinesModel>(
              future: newsViewModel.fetchNewsChannelHeadlinesApi(),
              builder: (BuildContext context, AsyncSnapshot<NewsChannelHeadLinesModel> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitCircle(
                      size: 50,
                      color: Colors.blue,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.articles != null && snapshot.data!.articles!.isNotEmpty) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      final article = snapshot.data!.articles![index];

                      return Container(

                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Background image
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl: article.urlToImage ?? '',
                                  fit: BoxFit.cover,
                                  width: media.width,  // Ensure it takes full width
                                  height: media.height * 0.9,
                                  // Adjust height
                                  placeholder: (context, url) => const SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: spinkit2,
                                  ),
                                  errorWidget: (context, url, error) => const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            // Overlaying text or content (optional)
                            Positioned(
                              bottom: 1,
                              left: 5,
                              child: Container(
                                margin: EdgeInsets.all(8),
                                height: media.height*0.03,
                                color: Colors.red, // Add a background to make text readable
                                child: Text(
                                  article.title ?? 'No Title',
                                  style: const TextStyle(fontSize:20,color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
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
