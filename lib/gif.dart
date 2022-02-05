import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mvc_pattern/mvc_pattern.dart';

class Gif{
  final int _id;
  final String _description;
  final String _gifURL;

  int get id => _id;
  String get description => _description;
  String get gifURL => _gifURL;

  Gif.fromJson(Map<String, dynamic> json) :
    _id = json["id"],
    _description = json["description"],
    _gifURL = json["gifURL"];
}

// представление будет получать объекты
// этого класса и определять конкретный его подтип
abstract class GetResult {}

// указывает на успешный запрос
class GetResultSuccess extends GetResult {
  final Gif gif;
  GetResultSuccess(this.gif);
}

// произошла ошибка
class GetResultFailure extends GetResult {
  final String error;
  GetResultFailure(this.error);
}

// загрузка данных
class GetResultLoading extends GetResult {
  GetResultLoading();
}

const String stringUrl = "https://developerslife.ru/random?json=true";

class GifList{
  final List<Gif> gifList= [];
  int iter = -1;

  bool isEmpty(){
    return gifList.isEmpty;
  }

  bool isFirstGif(){
    return (iter == 0);
  }

  bool isLastGif(){
    return (iter == (gifList.length-1) );
  }

  void addGif(Gif gif){
    iter++;
    gifList.add(gif);
  }

  Gif getPrev(){
    iter--;
    return gifList[iter];
  }

  Gif getNext(){
    iter++;
    return gifList[iter];
  }

  Gif getCurrent(){
    return gifList[iter];
  }


}

// class Iterator{
//   late GifList giflist;
//   int iterationState;
//   Iterator(GifList gifList){
//     this.giflist = gifList;
//     iterationState = 0;
//   }
//
//   Gif getNext(){
//
//   }
// }

class Repository {
  // обработку ошибок мы сделаем в контроллере
  // мы возвращаем Future объект, потому что
  // fetchPhotos асинхронная функция
  // асинхронные функции не блокируют UI
//   Future<PostList> fetchPosts() async {
//     // сначала создаем URL, по которому
//     // мы будем делать запрос
//     final url = Uri.parse("$SERVER/posts");
//     // делаем GET запрос
//     final response = await http.get(url);
// // проверяем статус ответа
//     if (response.statusCode == 200) {
//       // если все ок то возвращаем посты
//       // json.decode парсит ответ
//       return PostList.fromJson(json.decode(response.body));
//     } else {
//       // в противном случае говорим об ошибке
//       throw Exception("failed request");
//     }
//   }
  //асинхронная функция
  Future<Gif> fetchGif() async {
    final url = Uri.parse(stringUrl);
    // делаем GET запрос
    final response = await http.get(url);
    if (response.statusCode == 200) {
      // если все ок то возвращаем посты
      // json.decode парсит ответ
      return Gif.fromJson(json.decode(response.body));
    } else {
      // в противном случае говорим об ошибке
      throw Exception("failed request");
    }
  }

}



class PostController extends ControllerMVC{
  // создаем наш репозиторий
  final Repository repo = Repository(); //new?

  GifList gifList= GifList(); //new?

  // конструктор нашего контроллера
  PostController();
  //final url = 'https://i.gifer.com/VAyR.gif';
  // первоначальное состояние - загрузка данных
  GetResult currentState = GetResultLoading();
  void init() async {
    if (gifList.isLastGif()) {
      setState(() => currentState = GetResultLoading());
      try {
        // получаем данные из репозитория
        final gif = await repo.fetchGif();
        // если все ок то обновляем состояние на успешное
        // currentState = GetResultSuccess(gif);
        setState(() => currentState = GetResultSuccess(gif));
        gifList.addGif(gif);
      } catch (error) {
        // в противном случае произошла ошибка
        // currentState = GetResultFailure("Нет интернета");
        setState(() =>
        currentState = GetResultFailure("Произошла ошибка при "
            "загрузке данных. Проверьте подключение к сети."));
      }
    }
    else
      {
        final gif = gifList.getNext();
        setState(() => currentState = GetResultSuccess(gif));
      }
  }

  void getPrevGif() async{
    if (!gifList.isFirstGif()){
      final gif = gifList.getPrev();
      setState(() => currentState = GetResultSuccess(gif));
    }
  }


}