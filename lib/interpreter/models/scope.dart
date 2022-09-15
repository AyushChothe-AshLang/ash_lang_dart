import 'package:ash_lang/interpreter/models/symbol.dart';

class Scope {
  final Scope? parent;

  Map<String, ScopeSymbol> symbolTable = {};

  Scope({
    this.parent,
  });

  void setSymbol(String key, dynamic value) {
    if (symbolTable.containsKey(key) &&
        parent != null &&
        symbolTable[key]!.isParentScope) {
      parent!.setSymbol(key, value);
    } else {
      symbolTable[key] =
          ScopeSymbol(id: key, value: value, isParentScope: false);
    }
  }

  dynamic getSymbol(String key) {
    if (symbolTable.containsKey(key)) {
      if (symbolTable[key]!.isParentScope) {
        return parent!.getSymbol(key);
      } else {
        return symbolTable[key]!.value;
      }
    } else if (parent != null) {
      symbolTable[key] = ScopeSymbol(id: key, isParentScope: true);
      return parent!.getSymbol(key);
    }
    throw Exception("Runtime Exception: Identifier '$key' Not Found!");
  }
}
