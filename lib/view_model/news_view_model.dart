import 'package:news_app225/model/news_channel_headlines_model.dart';

import '../model/categories_news_model.dart';
import '../repository/news_repository.dart';


class NewsViewModel {
  final _rep = NewsRepository();

  // Update this method to accept and pass the source parameter to the repository
  Future<NewsChannelHeadLinesModel> fetchNewsChannelHeadlinesApi({required String source}) async {
    final response = await _rep.fetchNewsChannelHeadlinesApi(source); // Pass the source parameter here
    return response;
  }
  Future<CategoriesNewsModel> fetchCategoriesNewsApi( {required String category}) async {
    final response = await _rep.fetchCategoriesNewsApi(category); // Pass the source parameter here
    return response;
  }


}
