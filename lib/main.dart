import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:finteh/gif.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // Основной видже приложения.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HomePage',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // Этот виджет является домашней страницей вашего приложения. Это зависит от состояния, что означает
  // что у него есть объект состояния (определенный ниже), который содержит поля, влияющие
  // как это выглядит.

  // Этот класс является конфигурацией для состояния. Он содержит значения (в этом
  // регистр заголовка), предоставленный родителем (в данном случае виджетом приложения) и
  // используется методом построения состояния. Поля в подклассе виджетов являются
  // всегда помечается как "окончательный".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  // String URL = 'https://media1.giphy.com/media/CBKzbqaQxS7K331lil/giphy.gif?cid=ecf05e4790357d3e67ea05ad66715167ddc4f346b34f7dc4&rid=giphy.gif&ct=g';
  PostController _controller = new PostController();

  void initState(){
    super.initState();
    _controller.init();
  }


  void _getNextPage(){
    initState();


  }

  void _decrementCounter(){
    setState(() {
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Этот метод запускается повторно при каждом вызове setState, например, как сделано
    // с помощью метода _incrementCounter, описанного выше.
    return Scaffold(
      appBar: AppBar(
        // Здесь мы берем значение из объекта MyHomePage, созданного методомppp
        // App.build, и используем его для установки заголовка панели приложений.
        title: Text(widget.title),
      ),
      // body: Center(
      //   // Центр - это виджет макета. Он берет одного ребенка и позиционирует его
      //   // в середине родителя.
      //   child: Column(
      //     // Столбец также является виджетом макета. Он берет список дочерних элементов и
      //     // упорядочивает их по вертикали. По умолчанию он настраивается в соответствии со своими
      //     // дети горизонтально, и старается быть таким же высоким, как его родитель.
      //     //
      //     // // Вызовите "отладку рисования" (нажмите "p" в консоли, выберите действие
      //     // "Переключить отладку рисования" в инспекторе Flutter в Android
      //     // Studio или команда "Переключить отладочную краску" в коде Visual Studio)
      //     // чтобы увидеть каркас для каждого виджета.
      //     //
      //     // Столбец имеет различные свойства, позволяющие управлять его размерами и
      //     // расположением дочерних элементов. Здесь мы используем mainAxisAlignment для
      //     // центрирования дочерних элементов по вертикали; основная ось здесь - вертикальная
      //     // ось, потому что столбцы вертикальные (поперечная ось будет
      //     // горизонтальной).
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     mainAxisSize: MainAxisSize.max,
      //     children: <Widget>[
      //       Image.network(
      //             URL,
      //             // "http://static.devli.ru/public/images/gifs/201404/ee0e90eb-29d9-45a5-b748-865fa865c82d.gif",
      //       ),
      //       const Text(
      //         'You have pushed the button this many times:',
      //       ),
      //       Text(
      //         '$_counter',
      //         style: Theme.of(context).textTheme.headline4,
      //       ),
      //     ],
      //   ),
      // ),
      body: _buildContent(),
      floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.max,
          children: [
            FloatingActionButton(
              child: Icon(
                  Icons.replay
              ),
              onPressed: _decrementCounter,
              heroTag: null,
            ),
            SizedBox(
              height: 0,
              width: 80,
            ),
            FloatingActionButton(
              child: Icon(
                  Icons.arrow_forward_outlined,
              ),
              // onPressed: _incrementCounter,
              onPressed: _getNextPage,
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
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is GetResultFailure) {
      // ошибка
      return Center(
        child: Text(
            state.error,
            textAlign: TextAlign.center,
            //style: Theme.of(context).textTheme.headline4.copyWith(color: Colors.red)
        ),
      );
    } else {
      // отображаем список постов
      final posts = (state as GetResultSuccess).gif.gifURL;
      return Image.network(posts);
      // return Padding(
      //   padding: EdgeInsets.all(10),
      //   // ListView.builder создает элемент списка
      //   // только когда он видим на экране
      //   child: ListView.builder(
      //     itemCount: posts.length,
      //     itemBuilder: (context, index) {
      //       return _buildPostItem(posts[index]);
      //     },
      //   ),
      // );
    }
  }

}
