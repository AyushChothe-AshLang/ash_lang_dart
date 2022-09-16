import 'dart:io';

import 'package:ash_lang/ash_lang.dart';

void main(List<String> args) {
  if (args.isNotEmpty) {
    if (!args.last.endsWith('.ash')) {
      print("The last argument should be a '.ash' file");
      return;
    }
    if (args.contains("run")) {
      AshLang.execute(
        File(args.last),
        printTokens: args.contains('--tkn'),
        printAst: args.contains('--ast'),
      );
    } else if (args.contains("fmt")) {
      print(AshLang.format(File(args.last)));
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
