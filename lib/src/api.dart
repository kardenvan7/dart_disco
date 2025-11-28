import 'dart:async';

import 'package:disco_core/disco_core.dart' as core;

core.DiscoRetriever get currentScope {
  final scope = currentScopeOrNull;
  if (scope == null) throw StateError('No DiScope found in the current zone.');

  return scope;
}

core.DiscoRetriever? get currentScopeOrNull {
  return Zone.current[#scope] as core.DiscoRetriever?;
}

T runScoped<T>(
  core.DiscoModule module,
  T Function() body, {
  core.DiscoInteritanceType? inheritanceType,
}) {
  final parentScope = currentScopeOrNull;
  final scope = core.DiscoScopeSync(
    module.name,
    parent: parentScope as core.DiscoScope?,
    inheritanceType: inheritanceType,
  );

  module.configure(scope, scope);
  scope.initialize();

  final zone = Zone.current.fork(zoneValues: {#scope: scope});
  final value = zone.run(body);

  if (value is Future) {
    return value..whenComplete(() => scope.dispose());
  } else {
    scope.dispose();
    return value;
  }
}

Future<T> runScopedAsync<T>(
  core.DiscoModuleAsync module,
  FutureOr<T> Function() body, {
  core.DiscoInteritanceType? inheritanceType,
}) async {
  final parentScope = currentScopeOrNull;
  final scope = core.DiscoScopeAsync(
    module.name,
    parent: parentScope as core.DiscoScope?,
    inheritanceType: inheritanceType,
  );

  module.configure(scope, scope);
  await scope.initialize();

  final zone = Zone.current.fork(zoneValues: {#scope: scope});
  final value = await zone.run(body);

  scope.dispose();
  return value;
}