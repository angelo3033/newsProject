import 'package:newsproject/src/model/article.dart';

abstract class NewsRepositoryBase {
  Future<List<Article>> topHeadlines(String country);
}
