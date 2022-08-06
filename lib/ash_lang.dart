import 'dart:io';

class Token {
  String type;
  dynamic value;
  Token({
    required this.type,
    required this.value,
  });

  @override
  String toString() {
    return {"type": type, "value": value}.toString();
  }
}

class AshLang {
  static const List<String> primitives = ["int", "double", "string", "bool"];
  static const List<String> keywords = [
    "print",
    "let",
    "True",
    "False",
    ...primitives
  ];
  static const List<String> operators = ["+", "-", "*", "/", "^", "="];
  static const List<String> numbers = [
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "."
  ];

  final String code;
  Map<String, dynamic> vars = {};

  AshLang({
    this.code = "",
  });

  String parseExp(String exp) {
    List<dynamic> out = [];
    int pos = 0;
    String token = "";
    exp = exp.replaceAll(" ", "");
    while (pos < exp.length) {
      if (operators.contains(exp[pos])) {
        //Operator
        out.add(exp[pos++]);
      } else if (numbers.contains(exp[pos])) {
        //Number
        while (pos < exp.length && !operators.contains(exp[pos])) {
          token += exp[pos++];
        }
        if (token.isNotEmpty) {
          out.add(token);
          token = "";
        }
      } else {
        //Variable
        while (pos < exp.length &&
            !operators.contains(exp[pos]) &&
            !numbers.contains(exp[pos])) {
          token += exp[pos++];
        }
        if (token.isNotEmpty) {
          out.add(vars[token]);
          token = "";
        }
      }
    }
    return out.join("");
  }

  bool interpret(String line) {
    try {
      final List<Token> tokens = [];

      String token = "";
      int pos = 0;
      while (pos < line.length) {
        // print(token);
        if (line[pos].contains(RegExp(r'[A-Za-z+\-*/=]'))) {
          token += line[pos];
        } else if (line[pos] == '"') {
          //String
          pos++;
          while (line[pos] != '"' && pos < line.length) {
            token += line[pos];
            pos++;
          }
          if (token.isNotEmpty) {
            tokens.add(Token(type: 'string', value: token));
            token = "";
          }
        } else if (numbers.contains(line[pos])) {
          //Numbers
          while (line[pos] != ';' && pos < line.length) {
            token += line[pos];
            pos++;
          }
          if (token.isNotEmpty) {
            if (token.contains('.')) {
              //Double
              tokens.add(Token(type: 'double', value: double.parse(token)));
            } else {
              //Integer
              tokens.add(Token(type: 'int', value: int.parse(token)));
            }
            token = "";
          }
        } else if (line[pos] == '(') {
          //Expression
          pos++;
          while (line[pos] != ')' && pos < line.length) {
            token += line[pos];
            pos++;
          }
          if (token.isNotEmpty) {
            tokens.add(Token(type: 'exp', value: token));
            token = "";
          }
        } else if (line[pos] == " " || line[pos] == ';') {
          //EndLine
          if (token.isNotEmpty) {
            if (keywords.contains(token)) {
              if (token == "True" || token == "False") {
                tokens.add(Token(type: 'bool', value: token == "True"));
              } else {
                tokens.add(Token(type: 'keyword', value: token));
              }
            } else if (operators.contains(token)) {
              tokens.add(Token(type: 'op', value: token));
            } else {
              tokens.add(Token(type: 'var', value: token));
            }
            token = "";
          }
        }
        pos++;
      }
      // print(tokens);

      switch (tokens[0].type) {
        case 'keyword':
          switch (tokens[0].value) {
            case 'print':
              if (primitives.contains(tokens[1].type)) {
                print(tokens[1].value);
              } else if (tokens[1].type == "var") {
                print(vars[tokens[1].value]);
              } else if (tokens[1].type == "exp") {
                print(parseExp(tokens[1].value));
              }
              break;
            case 'let':
              vars[tokens[1].value] = tokens[3].value;
              break;
            default:
              return false;
          }
          break;
        case 'var':
          vars[tokens[0].value] = tokens[2].value;
          break;
        default:
          return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  void run() {
    final List<String> lines = code
        .split(';')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .map((e) => "$e;")
        .toList();
    // print(lines);
    for (String line in lines) {
      if (!interpret(line)) {
        print("Invalid Syntax: $line");
      }
    }
  }

  static void runFile(String path) {
    AshLang(code: File.fromUri(Uri.file(path)).readAsStringSync()).run();
  }

  void repl() {
    print("AshLang Repl");
    while (true) {
      stdout.write("> ");
      String line = (stdin.readLineSync() ?? "").trim();
      if (line.isNotEmpty) {
        if (line == "exit") break;
        if (!line.endsWith(";")) line += ";";
        if (!interpret(line)) {
          print("Invalid Syntax: $line");
        }
      }
    }
  }
}
