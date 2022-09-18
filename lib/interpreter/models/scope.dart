import 'package:ash_lang/interpreter/models/symbol.dart';

class Scope {
  final Scope? parent;

  Map<String, ScopeSymbol> symbolTable = {};

  Scope({
    this.parent,
  });

  void setSymbol(String key, dynamic value) {
    if (symbolTable.containsKey(key)) {
      symbolTable[key]!.value = value;
    } else if (parent != null) {
      return parent!.setSymbol(key, value);
    } else {
      throw Exception("Runtime Exception: Identifier '$key' Not Found!");
    }
  }

  dynamic getSymbol(String key) {
    if (symbolTable.containsKey(key)) {
      return symbolTable[key]!.value;
    } else if (parent != null) {
      return parent!.getSymbol(key);
    }
    throw Exception("Runtime Exception: Identifier '$key' Not Found!");
  }

  void declareSymbol(String key, dynamic value) {
    symbolTable[key] = ScopeSymbol(id: key, value: value);
  }
}
