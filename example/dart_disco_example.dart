import 'package:dart_disco/dart_disco.dart';

void main() {
  runScoped(
    ExampleModule('ExampleModule'),
    () {
      final service = currentScope.get<ExampleService>();
      service.doSomething();
    },
  );
}

class ExampleModule implements DiscoModule {
  const ExampleModule(this.name);

  @override
  final String name;

  @override
  void configure(DiscoRegistrar registrar, DiscoRetriever retriever) {
    registrar.addLazySingleton<ExampleService>(
      () => ExampleServiceImpl(),
    );
  }
}

abstract class ExampleService {
  void doSomething();
}

class ExampleServiceImpl implements ExampleService {
  @override
  void doSomething() {
    print('Doing something...');
  }
}