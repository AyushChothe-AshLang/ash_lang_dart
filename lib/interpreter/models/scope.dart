class Scope {
  final Scope? parent;

  Map<String, dynamic> symbolTable = {};

  Scope({
    this.parent,
  });

  void setSymbol(String key, dynamic value) {
    symbolTable[key] = value;
  }

  dynamic getSymbol(String key) {
    if (symbolTable.containsKey(key)) {
      return symbolTable[key];
    } else if (parent != null) {
      return parent!.getSymbol(key);
    }
    throw Exception("Runtime Exception: Identifier '$key' Not Found!");
  }
}
