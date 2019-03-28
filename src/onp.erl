%%%-------------------------------------------------------------------
%%% @author kariok
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. Mar 2019 12:18
%%%-------------------------------------------------------------------
-module(onp).
-author("kariok").

%% API
-export([onp/1]).

to_numeric(N) ->
  case string:to_float(N) of
    {error, _} -> list_to_integer(N);
    {F, _} -> F
  end.

is_numeric(N) ->
  try
  _ = to_numeric(N),
  true
  catch error:badarg ->
  false
  end.

onp(Expression) ->
  onpRecursive(string:tokens(Expression, " "), []).

onpRecursive([], []) ->
  0;

onpRecursive([], [Result]) ->
  Result;

onpRecursive([], _) ->
throw("Illegal RPN expression, too many numbers");

onpRecursive([H | T], Numbers) ->
case is_numeric(H) of
true -> onpRecursive(T, [to_numeric(H) | Numbers]);
false ->
  case is_unary(H) of
    true -> case Numbers of
                     [Num | Nums] -> onpRecursive(T, [calculate(Num, H) | Nums]);
                     _ -> throw("Too few numbers in the expression")
                   end;
    false ->   case Numbers of
             [SecondNum, FirstNum | Nums] ->
               onpRecursive(T, [calculate(FirstNum, SecondNum, H) | Nums]);
             _ -> throw("Too few numbers in the expression")
           end
  end
end.

is_unary(Operator) ->
  lists:member(Operator, ["sqrt", "sin", "cos", "ctg", "tg"]).

calculate(A, Operator) ->
  if
    Operator == "sqrt" -> math:sqrt(A);
    Operator == "sin" -> math:sin(A);
    Operator == "cos" -> math:cos(A);
    Operator == "tg" -> math:tan(A);
    Operator == "ctg" -> 1 / math:tan(A);
    true -> error("Illegal operator" ++ Operator)
  end.

calculate(A, B, Operator) ->
  if
    Operator == "+" -> A + B;
    Operator == "-" -> A - B;
    Operator == "*" -> A * B;
    Operator == "/" -> A / B;
    Operator == "pow" -> math:pow(A, B);
    true -> error("Illegal operator " ++ Operator)
  end.

