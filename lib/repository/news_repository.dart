import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app225/model/categories_news_model.dart';
import 'package:news_app225/model/news_channel_headlines_model.dart';

class NewsRepository {
  // Modified to accept a source parameter
  Future<NewsChannelHeadLinesModel> fetchNewsChannelHeadlinesApi(String source) async {
    String url = "https://newsapi.org/v2/top-headlines?sources=$source&apiKey=4f92a27b662a4da49d35bcf044549228";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChannelHeadLinesModel.fromJson(body);
    }
    throw Exception("Error fetching data from $source");
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async {
    String url = "https://newsapi.org/v2/everything?q=${category}&apiKey=4f92a27b662a4da49d35bcf044549228";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    }
    throw Exception("Error fetching data from $category");
  }

}
