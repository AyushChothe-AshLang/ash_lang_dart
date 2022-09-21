import 'package:ash_lang/parser/models/nodes.dart';
import 'package:ash_lang/parser/parser.dart';
import 'package:ash_lang/tokenizer/model/position.dart';
import 'package:ash_lang/tokenizer/model/token.dart';
import 'package:ash_lang/tokenizer/tokenizer.dart';
import 'package:test/test.dart';

void main() {
  group(
    "Tokenizer",
    () {
      test("Empty Program", () {
        Tokenizer tokenizer = Tokenizer(code: "");
        expect(
            tokenizer.tokenize().toString(),
            [
              Token(
                type: TokenType.eof,
                pos: PositionRange(
                  from: Position(line: 1, column: 1),
                ),
              )
            ].toString());
      });
      test("Operators (+-*/^%)", () {
        Tokenizer tokenizer = Tokenizer(code: "+-*/^%");
        expect(
            tokenizer.tokenize().toString(),
            [
              Token(
                type: TokenType.plus,
                value: '+',
                pos: PositionRange(
                  from: Position(line: 1, column: 1),
                ),
              ),
              Token(
                type: TokenType.minus,
                value: '-',
                pos: PositionRange(
                  from: Position(line: 1, column: 2),
                ),
              ),
              Token(
                type: TokenType.multiply,
                value: '*',
                pos: PositionRange(
                  from: Position(line: 1, column: 3),
                ),
              ),
              Token(
                type: TokenType.divide,
                value: '/',
                pos: PositionRange(
                  from: Position(line: 1, column: 4),
                ),
              ),
              Token(
                type: TokenType.power,
                value: '^',
                pos: PositionRange(
                  from: Position(line: 1, column: 5),
                ),
              ),
              Token(
                type: TokenType.modulus,
                value: '%',
                pos: PositionRange(
                  from: Position(line: 1, column: 6),
                ),
              ),
              Token(
                type: TokenType.eof,
                pos: PositionRange(
                  from: Position(line: 1, column: 7),
                ),
              ),
            ].toString());
      });
      test("Params '()'", () {
        Tokenizer tokenizer = Tokenizer(code: "()");
        expect(
            tokenizer.tokenize().toString(),
            [
              Token(
                type: TokenType.lParan,
                value: '(',
                pos: PositionRange(
                  from: Position(line: 1, column: 1),
                ),
              ),
              Token(
                type: TokenType.rParan,
                value: ')',
                pos: PositionRange(
                  from: Position(line: 1, column: 2),
                ),
              ),
              Token(
                type: TokenType.eof,
                pos: PositionRange(
                  from: Position(line: 1, column: 3),
                ),
              ),
            ].toString());
      });
      test("Braces '{}'", () {
        Tokenizer tokenizer = Tokenizer(code: "{}");
        expect(
            tokenizer.tokenize().toString(),
            [
              Token(
                type: TokenType.lBrace,
                value: '{',
                pos: PositionRange(
                  from: Position(line: 1, column: 1),
                ),
              ),
              Token(
                type: TokenType.rBrace,
                value: '}',
                pos: PositionRange(
                  from: Position(line: 1, column: 2),
                ),
              ),
              Token(
                type: TokenType.eof,
                pos: PositionRange(
                  from: Position(line: 1, column: 3),
                ),
              ),
            ].toString());
      });
      test("Comma ','", () {
        Tokenizer tokenizer = Tokenizer(code: ",");
        expect(
            tokenizer.tokenize().toString(),
            [
              Token(
                type: TokenType.comma,
                value: ',',
                pos: PositionRange(
                  from: Position(line: 1, column: 1),
                ),
              ),
              Token(
                type: TokenType.eof,
                pos: PositionRange(
                  from: Position(line: 1, column: 2),
                ),
              ),
            ].toString());
      });
      test("Not '!'", () {
        Tokenizer tokenizer = Tokenizer(code: "!");
        expect(
            tokenizer.tokenize().toString(),
            [
              Token(
                type: TokenType.not,
                value: '!',
                pos: PositionRange(
                  from: Position(line: 1, column: 1),
                ),
              ),
              Token(
                type: TokenType.eof,
                pos: PositionRange(
                  from: Position(line: 1, column: 2),
                ),
              ),
            ].toString());
      });
      test("Colon ':'", () {
        Tokenizer tokenizer = Tokenizer(code: ":");
        expect(
            tokenizer.tokenize().toString(),
            [
              Token(
                type: TokenType.colon,
                value: ':',
                pos: PositionRange(
                  from: Position(line: 1, column: 1),
                ),
              ),
              Token(
                type: TokenType.eof,
                pos: PositionRange(
                  from: Position(line: 1, column: 2),
                ),
              ),
            ].toString());
      });
      test("Semicolon ';'", () {
        Tokenizer tokenizer = Tokenizer(code: ";");
        expect(
            tokenizer.tokenize().toString(),
            [
              Token(
                type: TokenType.semicolon,
                value: ';',
                pos: PositionRange(
                  from: Position(line: 1, column: 1),
                ),
              ),
              Token(
                type: TokenType.eof,
                pos: PositionRange(
                  from: Position(line: 1, column: 2),
                ),
              ),
            ].toString());
      });

      test("Asiignment '= += -= *= /= %= ^= ~/= ^/='", () {
        Tokenizer tokenizer = Tokenizer(code: "= += -= *= /= %= ^= ~/= ^/=");
        expect(
            tokenizer.tokenize().toString(),
            [
              Token(
                type: TokenType.eq,
                value: '=',
                pos: PositionRange(
                  from: Position(line: 1, column: 1),
                ),
              ),
              Token(
                type: TokenType.plusEq,
                value: '+=',
                pos: PositionRange(
                  from: Position(line: 1, column: 3),
                  to: Position(line: 1, column: 4),
                ),
              ),
              Token(
                type: TokenType.minusEq,
                value: '-=',
                pos: PositionRange(
                  from: Position(line: 1, column: 6),
                  to: Position(line: 1, column: 7),
                ),
              ),
              Token(
                type: TokenType.multiplyEq,
                value: '*=',
                pos: PositionRange(
                  from: Position(line: 1, column: 9),
                  to: Position(line: 1, column: 10),
                ),
              ),
              Token(
                type: TokenType.divideEq,
                value: '/=',
                pos: PositionRange(
                  from: Position(line: 1, column: 12),
                  to: Position(line: 1, column: 13),
                ),
              ),
              Token(
                type: TokenType.modulusEq,
                value: '%=',
                pos: PositionRange(
                  from: Position(line: 1, column: 15),
                  to: Position(line: 1, column: 16),
                ),
              ),
              Token(
                type: TokenType.powerEq,
                value: '^=',
                pos: PositionRange(
                  from: Position(line: 1, column: 18),
                  to: Position(line: 1, column: 19),
                ),
              ),
              Token(
                type: TokenType.tildeDivideEq,
                value: '~/=',
                pos: PositionRange(
                  from: Position(line: 1, column: 21),
                  to: Position(line: 1, column: 23),
                ),
              ),
              Token(
                type: TokenType.powerDivideEq,
                value: '^/=',
                pos: PositionRange(
                  from: Position(line: 1, column: 25),
                  to: Position(line: 1, column: 27),
                ),
              ),
              Token(
                type: TokenType.eof,
                pos: PositionRange(
                  from: Position(line: 1, column: 28),
                ),
              ),
            ].toString());
      });
      test("Comparison '!= == < > <= >='", () {
        Tokenizer tokenizer = Tokenizer(code: "!= == < > <= >=");
        expect(
            tokenizer.tokenize().toString(),
            [
              Token(
                type: TokenType.neq,
                value: '!=',
                pos: PositionRange(
                  from: Position(line: 1, column: 1),
                  to: Position(line: 1, column: 2),
                ),
              ),
              Token(
                type: TokenType.deq,
                value: '==',
                pos: PositionRange(
                  from: Position(line: 1, column: 4),
                  to: Position(line: 1, column: 5),
                ),
              ),
              Token(
                type: TokenType.lt,
                value: '<',
                pos: PositionRange(
                  from: Position(line: 1, column: 7),
                ),
              ),
              Token(
                type: TokenType.gt,
                value: '>',
                pos: PositionRange(
                  from: Position(line: 1, column: 9),
                ),
              ),
              Token(
                type: TokenType.lte,
                value: '<=',
                pos: PositionRange(
                  from: Position(line: 1, column: 11),
                  to: Position(line: 1, column: 12),
                ),
              ),
              Token(
                type: TokenType.gte,
                value: '>=',
                pos: PositionRange(
                  from: Position(line: 1, column: 14),
                  to: Position(line: 1, column: 15),
                ),
              ),
              Token(
                type: TokenType.eof,
                pos: PositionRange(
                  from: Position(line: 1, column: 16),
                ),
              ),
            ].toString());
      });

      test("If Statements 'if elif else'", () {
        Tokenizer tokenizer = Tokenizer(code: "if elif else");
        expect(
            tokenizer.tokenize().toString(),
            [
              Token(
                type: TokenType.ifK,
                value: 'if',
                pos: PositionRange(
                  from: Position(line: 1, column: 1),
                  to: Position(line: 1, column: 3),
                ),
              ),
              Token(
                type: TokenType.elifK,
                value: 'elif',
                pos: PositionRange(
                  from: Position(line: 1, column: 4),
                  to: Position(line: 1, column: 8),
                ),
              ),
              Token(
                type: TokenType.elseK,
                value: 'else',
                pos: PositionRange(
                  from: Position(line: 1, column: 9),
                  to: Position(line: 1, column: 13),
                ),
              ),
              Token(
                type: TokenType.eof,
                pos: PositionRange(
                  from: Position(line: 1, column: 13),
                ),
              ),
            ].toString());
      });

      test("While Statements 'while break continue'", () {
        Tokenizer tokenizer = Tokenizer(code: "while break continue");
        expect(
            tokenizer.tokenize().toString(),
            [
              Token(
                type: TokenType.whileK,
                value: 'while',
                pos: PositionRange(
                  from: Position(line: 1, column: 1),
                  to: Position(line: 1, column: 6),
                ),
              ),
              Token(
                type: TokenType.breakK,
                value: 'break',
                pos: PositionRange(
                  from: Position(line: 1, column: 7),
                  to: Position(line: 1, column: 12),
                ),
              ),
              Token(
                type: TokenType.continueK,
                value: 'continue',
                pos: PositionRange(
                  from: Position(line: 1, column: 13),
                  to: Position(line: 1, column: 21),
                ),
              ),
              Token(
                type: TokenType.eof,
                pos: PositionRange(
                  from: Position(line: 1, column: 21),
                ),
              ),
            ].toString());
      });
      test("Function 'fn return'", () {
        Tokenizer tokenizer = Tokenizer(code: "fn return");
        expect(
            tokenizer.tokenize().toString(),
            [
              Token(
                type: TokenType.fnK,
                value: 'fn',
                pos: PositionRange(
                  from: Position(line: 1, column: 1),
                  to: Position(line: 1, column: 3),
                ),
              ),
              Token(
                type: TokenType.returnK,
                value: 'return',
                pos: PositionRange(
                  from: Position(line: 1, column: 4),
                  to: Position(line: 1, column: 10),
                ),
              ),
              Token(
                type: TokenType.eof,
                pos: PositionRange(
                  from: Position(line: 1, column: 10),
                ),
              ),
            ].toString());
      });

      group("Identifier", () {
        test("Identifier (x)", () {
          Tokenizer tokenizer = Tokenizer(code: "x");
          expect(
              tokenizer.tokenize().toString(),
              [
                Token(
                  type: TokenType.identifier,
                  value: 'x',
                  pos: PositionRange(
                    from: Position(line: 1, column: 1),
                    to: Position(line: 1, column: 2),
                  ),
                ),
                Token(
                  type: TokenType.eof,
                  pos: PositionRange(
                    from: Position(line: 1, column: 2),
                  ),
                ),
              ].toString());
        });
        test("Identifier (num)", () {
          Tokenizer tokenizer = Tokenizer(code: "num");
          expect(
              tokenizer.tokenize().toString(),
              [
                Token(
                  type: TokenType.identifier,
                  value: 'num',
                  pos: PositionRange(
                    from: Position(line: 1, column: 1),
                    to: Position(line: 1, column: 4),
                  ),
                ),
                Token(
                  type: TokenType.eof,
                  pos: PositionRange(
                    from: Position(line: 1, column: 4),
                  ),
                ),
              ].toString());
        });
        test("Identifier (num1)", () {
          Tokenizer tokenizer = Tokenizer(code: "num1");
          expect(
              tokenizer.tokenize().toString(),
              [
                Token(
                  type: TokenType.identifier,
                  value: 'num1',
                  pos: PositionRange(
                    from: Position(line: 1, column: 1),
                    to: Position(line: 1, column: 5),
                  ),
                ),
                Token(
                  type: TokenType.eof,
                  pos: PositionRange(
                    from: Position(line: 1, column: 5),
                  ),
                ),
              ].toString());
        });
      });
      group("Numbers", () {
        test("Number (1)", () {
          Tokenizer tokenizer = Tokenizer(code: "1");
          expect(
              tokenizer.tokenize().toString(),
              [
                Token(
                  type: TokenType.int,
                  value: 1,
                  pos: PositionRange(
                    from: Position(line: 1, column: 1),
                    to: Position(line: 1, column: 2),
                  ),
                ),
                Token(
                  type: TokenType.eof,
                  pos: PositionRange(
                    from: Position(line: 1, column: 2),
                  ),
                ),
              ].toString());
        });
        test("Number (123)", () {
          Tokenizer tokenizer = Tokenizer(code: "123");
          expect(
              tokenizer.tokenize().toString(),
              [
                Token(
                  type: TokenType.int,
                  value: 123,
                  pos: PositionRange(
                    from: Position(line: 1, column: 1),
                    to: Position(line: 1, column: 4),
                  ),
                ),
                Token(
                  type: TokenType.eof,
                  pos: PositionRange(
                    from: Position(line: 1, column: 4),
                  ),
                ),
              ].toString());
        });
        test("Number (3.14)", () {
          Tokenizer tokenizer = Tokenizer(code: "3.14");
          expect(
              tokenizer.tokenize().toString(),
              [
                Token(
                  type: TokenType.double,
                  value: 3.14,
                  pos: PositionRange(
                    from: Position(line: 1, column: 1),
                    to: Position(line: 1, column: 5),
                  ),
                ),
                Token(
                  type: TokenType.eof,
                  pos: PositionRange(
                    from: Position(line: 1, column: 5),
                  ),
                ),
              ].toString());
        });
        test("Number (.25)", () {
          Tokenizer tokenizer = Tokenizer(code: ".25");
          expect(
              tokenizer.tokenize().toString(),
              [
                Token(
                  type: TokenType.double,
                  value: 0.25,
                  pos: PositionRange(
                    from: Position(line: 1, column: 1),
                    to: Position(line: 1, column: 4),
                  ),
                ),
                Token(
                  type: TokenType.eof,
                  pos: PositionRange(
                    from: Position(line: 1, column: 4),
                  ),
                ),
              ].toString());
        });
        test("Number (5.)", () {
          Tokenizer tokenizer = Tokenizer(code: "5.");
          expect(
              tokenizer.tokenize().toString(),
              [
                Token(
                  type: TokenType.double,
                  value: 5.0,
                  pos: PositionRange(
                    from: Position(line: 1, column: 1),
                    to: Position(line: 1, column: 3),
                  ),
                ),
                Token(
                  type: TokenType.eof,
                  pos: PositionRange(
                    from: Position(line: 1, column: 3),
                  ),
                ),
              ].toString());
        });
      });
      group("StringLiteral", () {
        test("Empty String (" ")", () {
          Tokenizer tokenizer = Tokenizer(code: '""');
          expect(
              tokenizer.tokenize().toString(),
              [
                Token(
                  type: TokenType.stringLiteral,
                  value: "",
                  pos: PositionRange(
                    from: Position(line: 1, column: 1),
                    to: Position(line: 1, column: 3),
                  ),
                ),
                Token(
                  type: TokenType.eof,
                  pos: PositionRange(
                    from: Position(line: 1, column: 3),
                  ),
                ),
              ].toString());
        });
        test("Empty String ('')", () {
          Tokenizer tokenizer = Tokenizer(code: "''");
          expect(
              tokenizer.tokenize().toString(),
              [
                Token(
                  type: TokenType.stringLiteral,
                  value: "",
                  pos: PositionRange(
                    from: Position(line: 1, column: 1),
                    to: Position(line: 1, column: 3),
                  ),
                ),
                Token(
                  type: TokenType.eof,
                  pos: PositionRange(
                    from: Position(line: 1, column: 3),
                  ),
                ),
              ].toString());
        });
        test('String ("AshLang is Awesome")', () {
          Tokenizer tokenizer = Tokenizer(code: '"AshLang is Awesome"');
          expect(
              tokenizer.tokenize().toString(),
              [
                Token(
                  type: TokenType.stringLiteral,
                  value: "AshLang is Awesome",
                  pos: PositionRange(
                    from: Position(line: 1, column: 1),
                    to: Position(line: 1, column: 21),
                  ),
                ),
                Token(
                  type: TokenType.eof,
                  pos: PositionRange(
                    from: Position(line: 1, column: 21),
                  ),
                ),
              ].toString());
        });
        test("String ('AshLang is Awesome')", () {
          Tokenizer tokenizer = Tokenizer(code: "'AshLang is Awesome'");
          expect(
              tokenizer.tokenize().toString(),
              [
                Token(
                  type: TokenType.stringLiteral,
                  value: "AshLang is Awesome",
                  pos: PositionRange(
                    from: Position(line: 1, column: 1),
                    to: Position(line: 1, column: 21),
                  ),
                ),
                Token(
                  type: TokenType.eof,
                  pos: PositionRange(
                    from: Position(line: 1, column: 21),
                  ),
                ),
              ].toString());
        });
      });
    },
  );
  group("Parser", () {
    test("Empty Program", () {
      Tokenizer tokenizer = Tokenizer(code: "");
      Parser parser = Parser(tokens: tokenizer.tokenize());
      expect(parser.parse().toString(),
          BlockStatementNode(statements: [EOFNode()]).toString());
    });
    test("Arithmatic Expression", () {
      Tokenizer tokenizer = Tokenizer(code: "(1+2)*3/(4^6);");
      Parser parser = Parser(tokens: tokenizer.tokenize());
      expect(parser.logicalAndOr().toString(), "(((1+2)*3)/(4^6))");
    });
    test("Comparison", () {
      Tokenizer tokenizer = Tokenizer(code: "(1*2+3)<=(4/2)");
      Parser parser = Parser(tokens: tokenizer.tokenize());
      expect(parser.logicalAndOr().toString(), "(((1*2)+3)<=(4/2))");
    });
    test("Comparison (Equality)", () {
      Tokenizer tokenizer =
          Tokenizer(code: "(1/2^3)<=(24/4)==((1/2)^3)<=(22/4)");
      Parser parser = Parser(tokens: tokenizer.tokenize());
      expect(parser.logicalAndOr().toString(),
          "(((1/(2^3))<=(24/4))==(((1/2)^3)<=(22/4)))");
    });
    test("Logical And Or", () {
      Tokenizer tokenizer = Tokenizer(code: "(1==2 & (2==2 | 4==5) & 3<3)");
      Parser parser = Parser(tokens: tokenizer.tokenize());
      expect(
          parser.logicalAndOr().toString(), "(((1==2)&((2==2)|(4==5)))&(3<3))");
    });
  });
}
