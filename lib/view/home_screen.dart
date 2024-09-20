import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app225/model/news_channel_headlines_model.dart';
import 'package:news_app225/view_model/news_view_model.dart';

import '../model/categories_news_model.dart';
import 'categories_screen.dart';
import 'news_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList { bbcNews, aryNews, ABCNews, reuters, cnn, aljazeera }

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  FilterList? selectedMenu;
  final format = DateFormat('MMMM dd, yyyy');
  String name = 'bbc-news'; // Default to BBC News

  // Store the current Future to update when the source is changed
  late Future<NewsChannelHeadLinesModel> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = newsViewModel.fetchNewsChannelHeadlinesApi(source: name); // Fetch initial news
  }

  // Method to fetch news by selected source
  void _fetchNewsBySource(String source) {
    setState(() {
      name = source;
      _newsFuture = newsViewModel.fetchNewsChannelHeadlinesApi(source: name);
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width * 1;
    var height = MediaQuery.sizeOf(context).height * 1;

    return Scaffold(
      backgroundColor: Colors.cyan.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        actions: [
          PopupMenuButton<FilterList>(
            initialValue: selectedMenu,
            icon: const Icon(Icons.more_vert_outlined, color: Colors.black),
            onSelected: (FilterList item) {
              String selectedSource = name;
              if (item == FilterList.bbcNews) {
                selectedSource = 'bbc-news';
              } else if (item == FilterList.aryNews) {
                selectedSource = 'ary-news';
              } else if (item == FilterList.ABCNews) {
                selectedSource = 'abc-news';
              } else if (item == FilterList.reuters) {
                selectedSource = 'reuters';
              } else if (item == FilterList.cnn) {
                selectedSource = 'cnn';
              } else if (item == FilterList.aljazeera) {
                selectedSource = 'al-jazeera-english';
              }

              _fetchNewsBySource(selectedSource); // Fetch news for the selected source
              setState(() {
                selectedMenu = item;
              });
            },
            itemBuilder: (BuildContext context) =>
            <PopupMenuEntry<FilterList>>[
              const PopupMenuItem(
                value: FilterList.bbcNews,
                child: Text("BBC News"),
              ),
              const PopupMenuItem(
                value: FilterList.aryNews,
                child: Text("Ary News"),
              ),
              const PopupMenuItem(
                value: FilterList.ABCNews,
                child: Text("ABC News"),
              ),
              const PopupMenuItem(
                value: FilterList.reuters,
                child: Text("Reuters News"),
              ),
              const PopupMenuItem(
                value: FilterList.cnn,
                child: Text("CNN News"),
              ),
              const PopupMenuItem(
                value: FilterList.aljazeera,
                child: Text("Aljazeera News"),
              ),
            ],
          ),
        ],
        leading: IconButton(
          icon: Image.asset("images/category_icon.png", height: 33),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoriesScreen()));
          },
        ),
        title: Center(
          child: Text(
            "News",
            style: GoogleFonts.poppins(
                fontSize: 28, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      body: Column(
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
            height: height * 0.55,  // Give this a fixed height so it fits within the column
            width: width,
            child: FutureBuilder<NewsChannelHeadLinesModel>(
              future: _newsFuture, // Use updated future
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
                } else if (snapshot.hasData && snapshot.data!.articles!.isNotEmpty) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: InkWell(
                          onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsDetailScreen(
                                newsImage: snapshot.data!.articles![index].urlToImage.toString(),
                                newsTitle: snapshot.data!.articles![index].title.toString(),
                                newsDate: snapshot.data!.articles![index].publishedAt.toString(),
                                author: snapshot.data!.articles![index].author.toString(),
                                description: snapshot.data!.articles![index].description.toString(),
                                content: snapshot.data!.articles![index].description.toString(),
                                source: snapshot.data!.articles![index].source!.name.toString(),
                              )
                              )
                              );
                          },
                          child: SizedBox(
                            height: height * 0.9,
                            width: width * 0.999,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data!.articles![index].urlToImage ?? '',
                                    fit: BoxFit.cover,
                                    width: width,
                                    height: height,
                                    placeholder: (context, url) => Container(
                                      alignment: Alignment.center,
                                      child: spinkit2,
                                    ),
                                    errorWidget: (context, url, error) => const Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  left: 20,
                                  right: 20,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    color: Colors.white.withOpacity(0.8),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            snapshot.data!.articles![index].title.toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            snapshot.data!.articles![index].source!.name.toString(),
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          Text(
                                            format.format(DateTime.parse(snapshot.data!.articles![index].publishedAt.toString())),
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.grey[500],
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
          ),

          SizedBox(height: 10,),
          // The expanded part for vertical scrolling news
          Expanded(
            child: FutureBuilder<CategoriesNewsModel>(
              future: newsViewModel.fetchCategoriesNewsApi(category: 'General'), // Use updated future
              builder: (BuildContext context,
                  AsyncSnapshot<CategoriesNewsModel> snapshot) {
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
                } else if (snapshot.hasData && snapshot.data!.articles!.isNotEmpty) {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());

                      return Padding(
                        padding: const EdgeInsets.all( 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data!.articles![index].urlToImage ?? '',
                                fit: BoxFit.cover,
                                width: width * 0.3,
                                height: height * 0.18,
                                placeholder: (context, url) => Container(
                                  alignment: Alignment.center,
                                  child: spinkit2,
                                ),
                                errorWidget: (context, url, error) => const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            SizedBox(width: 7),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  height: height * 0.18,
                                  child: Column(
                                    children: [
                                      Text(
                                        snapshot.data!.articles![index].title.toString(),
                                        maxLines: 3,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Spacer(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            snapshot.data!.articles![index].source!.name.toString(),
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            format.format(dateTime),
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
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
