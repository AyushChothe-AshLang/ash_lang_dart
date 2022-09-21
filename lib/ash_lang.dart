import 'dart:io';

import 'package:ash_lang/formatter/formatter.dart';

import './interpreter/interpreter.dart';
import './parser/models/node.dart';
import './parser/parser.dart';
import './tokenizer/model/token.dart';
import './tokenizer/tokenizer.dart';

class AshLang {
  static void execute(File file,
      {bool printTokens = false, bool printAst = false}) {
    List<Token> tokens = (Tokenizer(code: file.readAsStringSync()).tokenize());
    if (printTokens) {
      print(tokens);
    }
    Node ast = (Parser(tokens: tokens).parse());
    if (printAst) {
      print(ast);
    }
    if (!(printTokens || printAst)) {
      Interpreter(ast: ast).run();
    }
  }

  static String format(File file) {
    List<Token> tokens = (Tokenizer(code: file.readAsStringSync()).tokenize());
    Node ast = Parser(tokens: tokens).parse();
    String formattedCode = Formatter(ast: ast).format();
    return formattedCode;
  }
}
