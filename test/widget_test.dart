
import 'package:http/http.dart' as http;

void main() async {
  Uri url = Uri.parse("https://api.rajaongkir.com/starter/province");
  final response = await http.get(
    url, 
    headers: {
      "key": "798d3f72a1cd6bce4b684aeed186f58a", 
    }
  );

  print(response.body);

}