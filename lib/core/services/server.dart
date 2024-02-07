import 'package:dio/dio.dart';

class Server {
  
  final Map<String, String> localisationHeaders = {"x-rapidapi-key": "d7e1513897msh454c691b4518598p17ef41jsn690463ad96a8", "x-rapidapi-host": "referential.p.rapidapi.com"};
  var dio = Dio();

  Future<Map<String, dynamic>> getStates(String isoCode) async {
    Map<String, dynamic> query = {'iso_a2': isoCode, 'lang': 'fr'};
    final response = await dio.get('https://referential.p.rapidapi.com/v1/state', options: Options(headers: localisationHeaders), queryParameters: query);
    if (response.statusCode != 200){
      print(response.toString());
      return {"result": Future.error(response.statusMessage.toString()), "code": response.statusCode};
    }
    else {
      print(response.data.toString());
      return {"result": response.data, "code": response.statusCode};
    }
  }

  Future<Map<String, dynamic>> getCities(String stateCode) async {
    Map<String, dynamic> query = {'state_code': stateCode, 'lang': 'fr'};
    final response = await dio.get('https://referential.p.rapidapi.com/v1/city', options: Options(headers: localisationHeaders), queryParameters: query);
    if (response.statusCode != 200){
      print(response.toString());
      return {"result": Future.error(response.statusMessage.toString()), "code": response.statusCode};
    }
    else {
      print(response.data.toString());
      return {"result": response.data, "code": response.statusCode};
    }
  }
}