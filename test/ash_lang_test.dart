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
      test("Operators (+-*/^)", () {
        Tokenizer tokenizer = Tokenizer(code: "+-*/^");
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
                type: TokenType.eof,
                pos: PositionRange(
                  from: Position(line: 1, column: 6),
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
      test("Simicolon ';'", () {
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
                  value: 1.0,
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
                  value: 123.0,
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
      expect(parser.parse().toString(), "[(((1.0+2.0)*3.0)/(4.0^6.0));");
    });
    test("Comparison", () {
      Tokenizer tokenizer = Tokenizer(code: "(1*2+3)<=(4/2)");
      Parser parser = Parser(tokens: tokenizer.tokenize());
      expect(parser.parse().toString(), "(((1.0*2.0)+3.0)<=(4.0/2.0))");
    });
    test("Comparison (Equality)", () {
      Tokenizer tokenizer =
          Tokenizer(code: "(1/2^3)<=(24/4)==((1/2)^3)<=(22/4)");
      Parser parser = Parser(tokens: tokenizer.tokenize());
      expect(parser.parse().toString(),
          "(((1.0/(2.0^3.0))<=(24.0/4.0))==(((1.0/2.0)^3.0)<=(22.0/4.0)))");
    });
    test("Logical And Or", () {
      Tokenizer tokenizer = Tokenizer(code: "(1==2 & (2==2 | 4==5) & 3<3)");
      Parser parser = Parser(tokens: tokenizer.tokenize());
      expect(parser.parse().toString(),
          "(((1.0==2.0)&((2.0==2.0)|(4.0==5.0)))&(3.0<3.0))");
    });
  });
}
