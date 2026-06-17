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
      backgroundColor: const Color(0xfff5f8fa),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "NEWS",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
            color: Colors.black87,
          ),
        ),
        leading: const Icon(Icons.menu_rounded, color: Colors.black87, size: 28),
        actions: [
          PopupMenuButton<FilterList>(
            initialValue: selectedMenu,
            icon: const Icon(Icons.more_vert_rounded, color: Colors.black87),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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

              _fetchNewsBySource(selectedSource);
              setState(() {
                selectedMenu = item;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterList>>[
              const PopupMenuItem(value: FilterList.bbcNews, child: Text("BBC News")),
              const PopupMenuItem(value: FilterList.aryNews, child: Text("Ary News")),
              const PopupMenuItem(value: FilterList.ABCNews, child: Text("ABC News")),
              const PopupMenuItem(value: FilterList.reuters, child: Text("Reuters News")),
              const PopupMenuItem(value: FilterList.cnn, child: Text("CNN News")),
              const PopupMenuItem(value: FilterList.aljazeera, child: Text("Aljazeera News")),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Top Headlines",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "View All",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder<NewsChannelHeadLinesModel>(
              future: _newsFuture,
              builder: (BuildContext context, AsyncSnapshot<NewsChannelHeadLinesModel> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: height * 0.45,
                    child: const Center(
                      child: SpinKitFadingCircle(color: Colors.blueAccent, size: 50),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.articles!.isNotEmpty) {
                  return SizedBox(
                    height: height * 0.45,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context, index) {
                        var article = snapshot.data!.articles![index];
                        return Padding(
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailScreen(
                                newsImage: article.urlToImage.toString(),
                                newsTitle: article.title.toString(),
                                newsDate: article.publishedAt.toString(),
                                author: article.author.toString(),
                                description: article.description.toString(),
                                content: article.description.toString(),
                                source: article.source!.name.toString(),
                              )));
                            },
                            child: Container(
                              width: width * 0.85,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: CachedNetworkImage(
                                      imageUrl: article.urlToImage ?? '',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                      placeholder: (context, url) => Container(color: Colors.grey[200]),
                                      errorWidget: (context, url, error) => const Icon(Icons.error_outline),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.8),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 20,
                                    left: 20,
                                    right: 20,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          article.source!.name.toString(),
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          article.title.toString(),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              format.format(DateTime.parse(article.publishedAt.toString())),
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Recently Updated",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ),
            FutureBuilder<CategoriesNewsModel>(
              future: newsViewModel.fetchCategoriesNewsApi(category: 'General'),
              builder: (BuildContext context, AsyncSnapshot<CategoriesNewsModel> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitCircle(color: Colors.blueAccent, size: 50),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.articles!.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      var article = snapshot.data!.articles![index];
                      DateTime dateTime = DateTime.parse(article.publishedAt.toString());

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: InkWell(
                          onTap: () {
                             Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailScreen(
                                newsImage: article.urlToImage.toString(),
                                newsTitle: article.title.toString(),
                                newsDate: article.publishedAt.toString(),
                                author: article.author.toString(),
                                description: article.description.toString(),
                                content: article.description.toString(),
                                source: article.source!.name.toString(),
                              )));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
                                  child: CachedNetworkImage(
                                    imageUrl: article.urlToImage ?? '',
                                    fit: BoxFit.cover,
                                    width: width * 0.3,
                                    height: height * 0.16,
                                    placeholder: (context, url) => Container(color: Colors.grey[100]),
                                    errorWidget: (context, url, error) => const Icon(Icons.error_outline),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          article.title.toString(),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              article.source!.name.toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                            Text(
                                              format.format(dateTime),
                                              style: GoogleFonts.poppins(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
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
                  return const Center(child: Text('No data available'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

const spinkit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);
