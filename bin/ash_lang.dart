import 'dart:io';

import 'package:ash_lang/interpreter/interpreter.dart';
import 'package:ash_lang/parser/models/node.dart';
import 'package:ash_lang/parser/parser.dart';
import 'package:ash_lang/tokenizer/model/token.dart';
import 'package:ash_lang/tokenizer/tokenizer.dart';

void main(List<String> args) {
  List<Token> tokens =
      (Tokenizer(code: File("./bin/code.ash").readAsStringSync()).tokenize());
  // print(tokens);
  Node ast = (Parser(tokens: tokens).parse());
  // print(ast);
  Interpreter(ast: ast).run();
}
