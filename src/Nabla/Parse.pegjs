decls_top = decl*
term_top = term

decl
  = import_decl
  / let_decl
  / abstract_decl

import_decl
  = IMPORT ms:(m:UPPER_IDENTIFIER DOUBLE_COLON { return m; }) x:UPPER_IDENTIFIER SEMICOLON
      { return ctors.importDecl(ms)(x); }

let_decl
  = LET x:UPPER_IDENTIFIER EQUALS t:term SEMICOLON
      { return ctors.letDecl(x)(t); }

abstract_decl
  = ABSTRACT x:UPPER_IDENTIFIER SEMICOLON
      { return ctors.abstractDecl(x); }

term
  = fun_term

fun_term
  = FUN LEFT_BRACKET pInit:(x:UPPER_IDENTIFIER COMMA { return x; })* pLast:UPPER_IDENTIFIER? RIGHT_BRACKET b:fun_term
      { return ctors.lam(pInit.concat(pLast === null ? [] : [pLast]))(b); }
  / add_term

add_term
  = head:mul_term tail:(op:(PLUS / MINUS) x:mul_term { return {op: op, x: x}; })*
      {
        return tail.reduce(function(a, b) {
          return ctors.app(ctors.var({'+': 'Add', '-': 'Subtract'}[b.op]))([a, b.x]);
        }, head);
      }

mul_term
  = head:add_prefix_term tail:( op:(ASTERISK / SLASH) x:add_prefix_term { return {op: op, x: x}; }
                              / x:app_term { return {op: '*', x: x}; }
                              )*
      {
        return tail.reduce(function(a, b) {
          return ctors.app(ctors.var({'*': 'Multiply', '/': 'Divide'}[b.op]))([a, b.x]);
        }, head);
      }

add_prefix_term
  = ops:(PLUS / MINUS)* x:app_term
      {
        return ops.reduce(function(x, op) {
          return op === '+' ? x : ctors.app(ctors.var('Multiply'))([ctors.num(bigInt('-1')), x]);
        }, x);
      }

app_term
  = function_:primary_term
    argumentLists:(LEFT_BRACKET init:(x:term COMMA { return x; })* last:term? RIGHT_BRACKET
                     { return init.concat(last === null ? [] : [last]) })*
      {
        return argumentLists.reduce(function(function_, argumentList) {
          return ctors.app(function_)(argumentList);
        }, function_);
      }

primary_term
  = name:IDENTIFIER { return ctors.var(name); }
  / int:INTEGER { return ctors.num(int); }
  / LEFT_PAREN term:term RIGHT_PAREN { return term; }

PLUS = _ '+' _ { return '+'; }
MINUS = _ '-' _ { return '-'; }
ASTERISK = _ '*' _ { return '*'; }
SLASH = _ '/' _ { return '/'; }
COMMA = _ ',' _
INTEGER = _ s:$([0-9]+) _ { return bigInt(s); }
LEFT_BRACKET = _ '[' _
RIGHT_BRACKET = _ ']' _
LEFT_PAREN = _ '(' _
RIGHT_PAREN = _ ')' _
DOUBLE_COLON = _ '::' _
EQUALS = _ '=' _
SEMICOLON = _ ';' _
IDENTIFIER = _ !'fun' !'import' !'abstract' !'let' name:$([A-Za-z]+) _ { return name; }
UPPER_IDENTIFIER = _ name:$([A-Z][A-Za-z]*) _ { return name; }
FUN = _ 'fun' _
IMPORT = _ 'import' _
ABSTRACT = _ 'abstract' _
LET = _ 'let' _

_ = [ \t\r\n]*
