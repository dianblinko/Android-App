import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
  // runApp(
  //   Text(
  //     'Helen',
  //     textDirection:  TextDirection.ltr,
  //     textAlign: TextAlign.center,
  //   ),
  // );
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

  void _decrementCounter(){
    setState(() {
      _counter--;
    });
  }

  void _incrementCounter() {
    setState(() {
      // Этот вызов setState сообщает фреймворку Flutter, что в этом состоянии что-то
      // изменилось, что заставляет его повторно запускать метод сборки ниже
      // чтобы на дисплее отображались обновленные значения. Если бы мы изменили
      // _counter без вызова setState(), тогда метод сборки не будет
      // вызываться снова, и поэтому, похоже, ничего не произойдет.
      _counter++;
    });


  }

  @override
  Widget build(BuildContext context) {
    // Этот метод запускается повторно при каждом вызове setState, например, как сделано
    // с помощью метода _incrementCounter, описанного выше.
    //
    // // Фреймворк Flutter был оптимизирован для повторного запуска методов сборки
    // быстро, так что вы можете просто перестроить все, что нуждается в обновлении, а
    // чем необходимость индивидуально изменять экземпляры виджетов.
    return Scaffold(
      appBar: AppBar(
        // Здесь мы берем значение из объекта MyHomePage, созданного методомppp
        // App.build, и используем его для установки заголовка панели приложений.
        title: Text(widget.title),
      ),
      body: Center(
        // Центр - это виджет макета. Он берет одного ребенка и позиционирует его
        // в середине родителя.
        child: Column(
          // Столбец также является виджетом макета. Он берет список дочерних элементов и
          // упорядочивает их по вертикали. По умолчанию он настраивается в соответствии со своими
          // дети горизонтально, и старается быть таким же высоким, как его родитель.
          //
          // // Вызовите "отладку рисования" (нажмите "p" в консоли, выберите действие
          // "Переключить отладку рисования" в инспекторе Flutter в Android
          // Studio или команда "Переключить отладочную краску" в коде Visual Studio)
          // чтобы увидеть каркас для каждого виджета.
          //
          // Столбец имеет различные свойства, позволяющие управлять его размерами и
          // расположением дочерних элементов. Здесь мы используем mainAxisAlignment для
          // центрирования дочерних элементов по вертикали; основная ось здесь - вертикальная
          // ось, потому что столбцы вертикальные (поперечная ось будет
          // горизонтальной).
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
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
              onPressed: _incrementCounter,
              heroTag: null,
            )
          ]
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );
  }
}
