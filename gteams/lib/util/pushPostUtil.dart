import 'package:http/http.dart';

Future<Response> pushPost(myType, target) async{
  Map<String, String> body = {"type" : myType, "target" : target};
  Response response = await post('http://45.119.145.96/api/push/', body: body);
  print(response);
  return response;
}