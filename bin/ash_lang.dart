import 'package:ash_lang/ash_lang.dart';

void main(List<String> args) {
  if (args.isNotEmpty) {
    AshLang.runFile(args[0]);
  } else {
    AshLang().repl();
  }
}
