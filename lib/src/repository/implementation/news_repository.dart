import 'package:newsproject/src/data_provider/news_provider.dart';
import 'package:newsproject/src/model/article.dart';
import 'package:newsproject/src/repository/news_repository.dart';

class NewsRepository extends NewsRepositoryBase {
  final NewsProvider _provider;

  NewsRepository(this._provider);

  @override
  Future<List<Article>> topHeadlines(String country) => _provider.topHeadlines(country);
}
