term
  = call_term

call_term
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
