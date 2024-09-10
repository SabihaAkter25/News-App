import 'package:news_app225/model/news_channel_headlines_model.dart';

import '../repository/news_repository.dart';

class NewsViewModel{
final _rep = NewsRepository();

Future<NewsChannelHeadLinesModel> fetchNewsChannelHeadlinesApi()async {
  final response = await _rep.fetchNewsChannelHeadlinesApi();
  return response;
}

}