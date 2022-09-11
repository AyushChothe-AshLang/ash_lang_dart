import 'package:ash_lang/tokenizer/tokenizer.dart';

void main(List<String> args) {
  print(Tokenizer(code: "((1 + 2) * 3)").tokenize());
}
