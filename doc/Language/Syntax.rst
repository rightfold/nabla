Syntax
======

Declarations
------------

Expressions
-----------

Literals
~~~~~~~~

- Numeric literals: `0`, `1`, `42`.

Function application
~~~~~~~~~~~~~~~~~~~~

- No arguments: `Sin[]`.
- One argument: `Sin[X]`.
- Many arguments: `Log[E, N, ...]`.

Arithmetic
~~~~~~~~~~

- `a + b` is equivalent to `Add[a, b]`.
- `a - b` is equivalent to `Sub[a, b]`.
- `a * b` is equivalent to `Mul[a, b]`.
- `a b` is equivalent to `Mul[a, b]`.
- `a / b` is equivalent to `Div[a, b]`.
- `a ^ b` is equivalent to `Pow[a, b]`.
- `+x` is equivalent to `x`.
- `-x` is equivalent to `Neg[x]`.

Parentheses
~~~~~~~~~~~

Parentheses can be used to work around the precedence of operators. For
example, `a * (b + c)` is equivalent to `Mul[Add[b, c]]`.
