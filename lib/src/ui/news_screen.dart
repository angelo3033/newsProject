import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsproject/src/bloc/news_cubit.dart';
import 'package:newsproject/src/model/article.dart';
import 'package:newsproject/src/navigation/routes.dart';
import 'package:newsproject/src/repository/news_repository.dart';

import 'news_detail_screen.dart';

class NewsScreen extends StatelessWidget {
  static Widget create(BuildContext context) {
    /// Inyectamos el Cubit al Widget NewsScreen
    return BlocProvider<NewsCubit>(
      /// Inicializamos el cubit y cargamos las noticias
      create: (_) => NewsCubit(context.read<NewsRepositoryBase>())..loadTopNews(),
      child: NewsScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1565C0),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        centerTitle: true,
        title: Image.asset('./images/news.png', fit: BoxFit.cover, height: 70, width: 70),
      ),
      body: BlocBuilder<NewsCubit, NewsState>(
        builder: (context, state) {
          if (state is NewsLoadCompleteState) {
            /// Cuando las noticias cargaron exitosamente
            return ListView.builder(
              itemCount: state.news.length,
              itemBuilder: (_, int index) => _ListItem(article: state.news[index]),
              
            );
          } else if (state is NewsErrorState) {
            /// Cuando hubo un error al cargas las noticias
            return Text(state.message);
          } else {
            /// Cuando estamos cargando las noticias
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  final Article article;

  const _ListItem({
    Key? key,
    required this.article,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        margin: EdgeInsets.all(20),
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Column(
          children: [
            /// Si existe imagen cargamos la imagen con CachedNetworkImage de lo contrario
            /// mostramos un contenedor con fondo rojo
            article.urlToImage == null
                ? Container(color: Colors.red, height: 250)
                : CachedNetworkImage(
                    imageUrl: article.urlToImage!,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Text(
                '${article.title}',
                maxLines: 1,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Text(
                '${article.description}',
                maxLines: 3,
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
            FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(seconds: 2),
                      transitionsBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secAnimation,
                      Widget child) {
                        animation = CurvedAnimation(
                          parent: animation, curve: Curves.elasticInOut);
                          
                        return ScaleTransition(
                          alignment: Alignment.center,
                          scale: animation,
                          child: child,
                        );
                      },
                      pageBuilder: (BuildContext context, Animation<double> animation,
                        Animation<double> secAnimation) {
                        return NewsDetailScreen(article: article);
                      }
                    )
                  );
                },
                color: Colors.white,
                padding: EdgeInsets.all(10.0),
                child: Column( // Replace with a Row for horizontal icon + text
                  children: <Widget>[
                    Icon(Icons.arrow_forward),
                    Text("Informate")
                  ],
                ),
            ),
            SizedBox(height: 16),
          ],
          
        ),
      ),
    );
  }
}
