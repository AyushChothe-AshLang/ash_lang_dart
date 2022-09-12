import 'package:ash_lang/interpreter/models/value.dart';

class NumberValue implements Value {
  double value;

  NumberValue({
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

class NullValue implements Value {}
