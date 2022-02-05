import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mvc_pattern/mvc_pattern.dart';

class Gif{
  // все поля являются private
  // это сделано для инкапсуляции данных
  final int _id;
  final String _description;
  final String _gifURL;

  // создаем getters для наших полей
  // дабы только мы могли читать их
  int get id => _id;
  String get description => _description;
  String get gifURL => _gifURL;

  // Dart позволяет создавать конструкторы с разными именами
  // В данном случае Post.fromJson(json) - это конструктор
  // здесь мы принимаем JSON объект поста и извлекаем его поля
  // обратите внимание, что dynamic переменная
  // может иметь разные типы: String, int, double и т.д.
  Gif.fromJson(Map<String, dynamic> json) :
    this._id = json["id"],
    this._description = json["description"],
    this._gifURL = json["gifURL"];
}
// PostList являются оберткой для массива постов
// class Get {
//   final List<Gif> posts = [];
//   Get.fromJson(Map<String, dynamic> jsonItems) {
//     for (var jsonItem in jsonItems) {
//       posts.add(Post.fromJson(jsonItem));
//     }
//   }
// }


// наше представление будет получать объекты
// этого класса и определять конкретный его
// подтип
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

const String SERVER = "https://developerslife.ru/random?json=true";

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
    print("Вызвали Rep.fetchGif");
    final url = Uri.parse("$SERVER");
    print("Rep. запарсили url " + url.toString());
    // делаем GET запрос
    final response = await http.get(url);
    print("сделали get запрос");
    if (response.statusCode == 200) {
      // если все ок то возвращаем посты
      // json.decode парсит ответ
      print("Статус гет запроса = 200");
      return Gif.fromJson(json.decode(response.body));
    } else {
      print("Статус гет запроса не равен 200");
      // в противном случае говорим об ошибке
      throw Exception("failed request");
    }
  }

}



class PostController extends ControllerMVC{
  // создаем наш репозиторий
  final Repository repo = new Repository();

  // конструктор нашего контроллера
  PostController();
  //final url = 'https://i.gifer.com/VAyR.gif';
  // первоначальное состояние - загрузка данных
  GetResult currentState = GetResultLoading();
  void init() async {
    setState(() => currentState = GetResultLoading());
    try {
      // получаем данные из репозитория
      final gif = await repo.fetchGif();
      // если все ок то обновляем состояние на успешное
      // currentState = GetResultSuccess(gif);
      setState(() => currentState = GetResultSuccess(gif));
    } catch (error) {
      // в противном случае произошла ошибка
      // currentState = GetResultFailure("Нет интернета");
      setState(() => currentState = GetResultFailure("Нет интернета"));
    }
  }

  void nextGif() async{

  }


}