class Position {
  int line, column;
  Position({
    required this.line,
    required this.column,
  });
  @override
  String toString() => "[$line:$column]";
}

class PositionRange {
  Position from;
  Position? to;
  PositionRange({
    required this.from,
    this.to,
  });
  @override
  String toString() => "($from${to != null ? ':$to' : ''})";
}
