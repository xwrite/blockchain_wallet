import 'package:blockchain_wallet/common/utils/command.dart';
import 'package:blockchain_wallet/common/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../testing/utils/result.dart';

void main() {
  group('Command0 tester', () {
    test('should complete void command', () async {
      final command0 = Command0<void>(() => Future.value(Result.ok(null)));
      await command0.execute();
      expect(command0.completed, true);
    });

    test('should complete bool command', () async {
      final command0 = Command0<bool>(() => Future.value(Result.ok(true)));
      await command0.execute();
      expect(command0.completed, true);
      expect(command0.result?.asOk.value, true);
    });

    test('running should be true', () async {
      final command0 = Command0<bool>(() => Future.value(Result.ok(true)));
      final future = command0.execute();
      expect(command0.running, true);
      await future;
      expect(command0.running, false);
    });

    test('should only run once', () async {
      var count = 0;
      final command0 = Command0<int>(() => Future.value(Result.ok(count++)));
      final future = command0.execute();
      command0.execute();
      command0.execute();
      command0.execute();
      await future;
      expect(count, 1);
    });

    test('should handle error', () async {
      final command0 = Command0(
        () => Future.value(Result.error(Exception('error!'))),
      );
      await command0.execute();
      expect(command0.error, true);
      expect(command0.result, isA<Error>());
    });
  });

  group('Command1 tester', () {
    test('should complete void command, bool arguments', () async {
      final command = Command1<void, bool>((args) {
        expect(args, true);
        return Future.value(Result.ok(null));
      });
      await command.execute(true);
      expect(command.completed, true);
    });
    test('should complete bool command, bool arguments', () async {
      final command = Command1<bool, bool>((args) {
        expect(args, true);
        return Future.value(Result.ok(true));
      });
      await command.execute(true);
      expect(command.completed, true);
      expect(command.result?.asOk.value, true);
    });

  });
}
