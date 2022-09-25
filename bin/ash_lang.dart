import 'dart:io';

import 'package:ash_lang/ash_lang.dart';

void main(List<String> args) {
  // args = ["run", "--tkn", "./bin/code.ash"];
  if (args.isNotEmpty) {
    if (args.contains("run")) {
      AshLang.execute(
        File(args.last),
        printTokens: args.contains('--tkn'),
        printAst: args.contains('--ast'),
      );
    } else if (args.contains("analyze")) {
      print(AshLang.analyze(File(args.last)));
    } else if (args.contains("fmt")) {
      stdout.write(AshLang.format(File(args.last)));
    }
  } else {
    print(
        """
ashlang [command] [options] [file]

[command]
    run: Execute a File (if no options are specified)
          [options]
            --tkn: Print Tokens of the File
            --ast: Prints generated Abstract Synatx Tree for the File
    fmt: Format a File (options are no)

[file]: Path of a '.ash' File
    """);
  }
}
