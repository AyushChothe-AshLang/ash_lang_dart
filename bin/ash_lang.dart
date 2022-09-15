import 'dart:io';

import 'package:ash_lang/ash_lang.dart';

void main(List<String> args) {
  List<Token> tokens =
      (Tokenizer(code: File("./bin/code.ash").readAsStringSync()).tokenize());
  // print(tokens);
  Node ast = (Parser(tokens: tokens).parse());
  // print(ast);
  Interpreter(ast: ast).run();
}
