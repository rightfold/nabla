term
  = add_term

add_term
  = head:mul_term tail:(op:[+-] x:mul_term { return {op: op, x: x}; })*
      {
        return tail.reduce(function(a, b) {
          return ctors.app(ctors.var({'+': 'Add', '-': 'Sub'}[b.op]))([a, b.x]);
        }, head);
      }

mul_term
  = head:app_term tail:(op:[*/]? x:app_term { return {op: op, x: x}; })*
      {
        return tail.reduce(function(a, b) {
          return ctors.app(ctors.var({null: 'Mul', '*': 'Mul', '/': 'Div'}[b.op]))([a, b.x]);
        }, head);
      }

app_term
  = function_:primary_term
    argumentLists:(LEFT_BRACKET init:(x:term ',' { return x; })* last:term? RIGHT_BRACKET
                     { return init.concat(last === null ? [] : [last]) })*
      {
        return argumentLists.reduce(function(function_, argumentList) {
          return ctors.app(function_)(argumentList);
        }, function_);
      }

primary_term
  = name:LOWERCASE_IDENTIFIER { return ctors.var(name); }
  / name:UPPERCASE_IDENTIFIER { return ctors.var(name); }

LEFT_BRACKET = _ '[' _
RIGHT_BRACKET = _ ']' _
LOWERCASE_IDENTIFIER = _ name:$([a-z][A-Za-z]*) _ { return name; }
UPPERCASE_IDENTIFIER = _ name:$([A-Z][A-Za-z]*) _ { return name; }

_ = [ \t\r\n]*
