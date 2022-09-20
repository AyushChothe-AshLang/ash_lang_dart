import 'package:ash_lang/interpreter/models/value.dart';

abstract class NumberValue<T extends num> implements Value<T> {}

class IntNumberValue implements NumberValue<int> {
  @override
  int value;

  IntNumberValue({
    required this.value,
  });

  @override
  String toString() => "$value";
}

class DoubleNumberValue implements NumberValue<double> {
  @override
  double value;

  DoubleNumberValue({
    required this.value,
  });

  @override
  String toString() => "$value";
}

class StringValue implements Value<String> {
  @override
  String value;

  StringValue({
    required this.value,
  });

  @override
  String toString() => value;
}

class BooleanValue implements Value<bool> {
  @override
  bool value;

  BooleanValue({
    required this.value,
  });
  @override
  String toString() => "$value";
}

class ReturnValue implements Value {
  @override
  dynamic value;
  ReturnValue({
    required this.value,
  });
}

class NullValue implements Value {
  @override
  dynamic value;
}

class BreakValue implements Value {
  @override
  dynamic value;
}

class ContinueValue implements Value {
  @override
  dynamic value;
}
