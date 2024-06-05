import 'package:rc/utils.dart';
import 'package:test/test.dart';

void main() {
  test('dotiable', () {
    expect(dotiable(1), equals(1));

    final map = {
      1: 1,
      "a": {
        1: {"a": 1},
        "a": 1,
      }
    };
    final flatMap = {"1": 1, "a.1.a": 1, "a.a": 1};
    expect(dotiable(map), equals(flatMap));

    final data = [
      1,
      {1: 2},
      {
        "a": {1: 2, "b": 2},
        "b.c": {"1.2": 1},
      }
    ];
    final flatData = {
      "0": 1,
      "1.1": 2,
      "2.a.1": 2,
      "2.a.b": 2,
      "2.b.c.1.2": 1,
    };

    expect(dotiable(data), equals(flatData));
  });

  test('dotOperator throw error', () {
    final data = {
      "a.b": [1],
    };
    final data2 = {
      "a": {"a": 1},
    };

    expect(() => dotOperator(data, 'a'), throwsArgumentError);
    expect(() => dotOperator(data2, 'a'), throwsArgumentError);
  });

  test('dotOperator', () {
    final data = {
      'a.b.c': 1,
    };

    expect(dotOperator(data, 'a.b.c'), equals(1));
    expect(dotOperator(data, 'a.b'), equals({"c": 1}));
    expect(
        dotOperator(data, 'a'),
        equals({
          'b': {'c': 1}
        }));
  });
}
