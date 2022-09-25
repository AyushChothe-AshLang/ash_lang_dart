import 'package:ash_lang/parser/models/nodes.dart';
import 'package:ash_lang/tokenizer/model/token.dart';

const numbers = "0123456789.";
const whitespace = " \n\t\r";
final chars = RegExp(r"\w");

const assignments = [
  TokenType.eq,
  TokenType.plusEq,
  TokenType.minusEq,
  TokenType.multiplyEq,
  TokenType.divideEq,
  TokenType.modulusEq,
  TokenType.powerEq,
  TokenType.tildeDivideEq,
  TokenType.powerDivideEq,
];

const keywords = {
  "while": TokenType.whileK,
  "if": TokenType.ifK,
  "else": TokenType.elseK,
  "elif": TokenType.elifK,
  "fn": TokenType.fnK,
  "let": TokenType.letK,
  "break": TokenType.breakK,
  "continue": TokenType.continueK,
  "return": TokenType.returnK,
};

const precedence = {
  SubtractNode: 1,
  AddNode: 1,
  MultiplyNode: 2,
  DivideNode: 3,
  ModulusNode: 4,
  PowerNode: 5,
};

TokenType getTokenTypeFromId(String id) {
  if (keywords.containsKey(id)) {
    return keywords[id]!;
  }
  return TokenType.identifier;
}
