import 'package:dio/dio.dart';
import 'package:lista_de_contatos/models/contact.dart';

String baseUrl = "https://parseapi.back4app.com/classes/MyCustomClassName";

class ContatoService {
  String url = "$baseUrl/contact";
  late Dio dio;

  ContatoService() {
    dio = Dio();
  }

  Future<ContactList> getContatos() async {
    var response = await dio.get(url);

    var contatoList = ContactList.fromJson(response.data);
    return contatoList;
  }

  Future<void> updateContato(Contact contact, String id) async {
    await dio.put(url, data: contact.toJson());
  }

  Future<void> deleteContato(String id) async {
    await dio.delete(url, data: {"id": id});
  }

  Future<void> addContato(Contact contact) async {
    await dio.post(url, data: contact.toJson());
  }
}
