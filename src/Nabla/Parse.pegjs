term
  = add_term

add_term
  = head:mul_term tail:(op:(PLUS / MINUS) x:mul_term { return {op: op, x: x}; })*
      {
        return tail.reduce(function(a, b) {
          return ctors.app(ctors.var({'+': 'Add', '-': 'Sub'}[b.op]))([a, b.x]);
        }, head);
      }

mul_term
  = head:add_prefix_term tail:( op:(ASTERISK / SLASH) x:add_prefix_term { return {op: op, x: x}; }
                              / x:app_term { return {op: '*', x: x}; }
                              )*
      {
        return tail.reduce(function(a, b) {
          return ctors.app(ctors.var({'*': 'Mul', '/': 'Div'}[b.op]))([a, b.x]);
        }, head);
      }

add_prefix_term
  = ops:(PLUS / MINUS)* x:app_term
      {
        return ops.reduce(function(x, op) {
          return op === '+' ? x : ctors.app(ctors.var('Neg'))([x]);
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
  = name:LOWERCASE_IDENTIFIER { return ctors.var(name); }
  / name:UPPERCASE_IDENTIFIER { return ctors.var(name); }
  / LEFT_PAREN term:term RIGHT_PAREN { return term; }

PLUS = _ '+' _ { return '+'; }
MINUS = _ '-' _ { return '-'; }
ASTERISK = _ '*' _ { return '*'; }
SLASH = _ '/' _ { return '/'; }
COMMA = _ ',' _
LEFT_BRACKET = _ '[' _
RIGHT_BRACKET = _ ']' _
LEFT_PAREN = _ '(' _
RIGHT_PAREN = _ ')' _
LOWERCASE_IDENTIFIER = _ name:$([a-z][A-Za-z]*) _ { return name; }
UPPERCASE_IDENTIFIER = _ name:$([A-Z][A-Za-z]*) _ { return name; }

_ = [ \t\r\n]*
