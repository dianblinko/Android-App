import 'package:flutter/material.dart';
import 'package:finteh/gif.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Финтех',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const PostListPage(title: "Финтех",),
    );
  }
}

class PostListPage extends StatefulWidget {
  const PostListPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _PostListPageState createState() => _PostListPageState();
}

class _PostListPageState extends StateMVC {
  late PostController _controller;

  // передаем наш контроллер StateMVC конструктору и
  // получаем на него ссылку
  _PostListPageState() : super(PostController()) {
    _controller = controller as PostController;
  }
  // после инициализации состояния
  // мы запрашивает данные у сервера
  @override
  void initState() {
    super.initState();
    _controller.init();
  }

  void _getNextGif(){
      _controller.init();
    }

  void _getPrevGif() {
    _controller.getPrevGif();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Финтех"),
        ),

        body: _buildContent(),

        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              child: const Icon(
                  Icons.replay
              ),
              onPressed: _getPrevGif,
              heroTag: null,
            ),

            const SizedBox(
              height: 0,
              width: 80,
            ),

            FloatingActionButton(
              child: const Icon(
                  Icons.arrow_forward_outlined,
              ),
              onPressed: _getNextGif,
              heroTag: null,
            )
          ]
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildContent() {
    // первым делом получаем текущее состояние
    final state = _controller.currentState;
    if (state is GetResultLoading) {
      // загрузка
      return const Align(
        alignment: Alignment.topCenter,
        child: CircularProgressIndicator(),
      );
    } else
      if (state is GetResultFailure) {
        // ошибка
        return Align(
          alignment: Alignment.topCenter,
          child: Text(
              state.error,
              textAlign: TextAlign.center,
              // style: Theme.of(context).textTheme.headline4.copyWith(color: Colors.red)
          ),
        );
      } else {
        final gif = (state as GetResultSuccess).gif;
        final gifURL = gif.gifURL;
        final description = gif.description;
        return (
          Container(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                CachedNetworkImage(
                    imageUrl: gifURL,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(description, textAlign: TextAlign.center,),
              ],
            ),
          )
      );
    }
  }


}