class ScopeSymbol {
  String id;
  dynamic value;
  bool isParentScope = false;
  ScopeSymbol({
    required this.id,
    required this.isParentScope,
    this.value,
  });
}
