import 'package:samgyup_serve/app/app.dart';
import 'package:samgyup_serve/bootstrap.dart';

Future<void> main() async {
  await bootstrap(App.new);
}
