import 'package:ash_lang/interpreter/models/value.dart';

abstract class NumberValue implements Value {}

class IntNumberValue implements NumberValue {
  int value;

  IntNumberValue({
    required this.value,
  });

  @override
  String toString() => "$value";
}

class DoubleNumberValue implements NumberValue {
  double value;

  DoubleNumberValue({
    required this.value,
  });

  @override
  String toString() => "$value";
}

class StringValue implements Value {
  String value;

  StringValue({
    required this.value,
  });

  @override
  String toString() => value;
}

class BooleanValue implements Value {
  bool value;

  BooleanValue({
    required this.value,
  });
  @override
  String toString() => "$value";
}

class ReturnValue implements Value {
  dynamic value;
  ReturnValue({
    required this.value,
  });
}

class NullValue implements Value {
  final dynamic value = null;
}

class BreakValue implements Value {}

class ContinueValue implements Value {}
