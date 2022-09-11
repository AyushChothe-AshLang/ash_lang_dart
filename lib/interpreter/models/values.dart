import 'package:ash_lang/interpreter/models/value.dart';

class NumberValue implements Value {
  @override
  double value;

  NumberValue({
    required this.value,
  });
  @override
  String toString() => "$value";
}

class BooleanValue implements Value {
  @override
  bool value;
  BooleanValue({
    required this.value,
  });
  @override
  String toString() => "$value";
}

class NullValue implements Value {}
