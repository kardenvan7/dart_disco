import 'package:dart_disco/dart_disco.dart';
import 'package:test/test.dart';

import '../example/dart_disco_example.dart';

void main() {
  test(
    'Example test',
    () {
      runScoped(
        ExampleModule(),
        () {
          final service = currentScope.get<ExampleService>();
          service.doSomething();
        },
      );
    },
  );
}
