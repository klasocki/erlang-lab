%%%-------------------------------------------------------------------
%%% @author kariok
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Mar 2019 11:53
%%%-------------------------------------------------------------------
-module(qsort).
-author("kariok").

%% API
-export([qs/1, randomElems/3]).

lessThan(List, Arg) ->
  lists:filter(fun(X) -> X < Arg end, List).

grtEqThan(List, Arg) ->
  lists:filter(fun(X) -> X >= Arg end, List).

qs([Pivot | Tail]) ->
  qs(lessThan(Tail, Pivot)) ++ [Pivot] ++ qs(grtEqThan(Tail, Pivot));

qs([]) -> [].

randomElems(N, Min, Max) ->
  [rand:uniform(Max - Min + 1) + Min - 1 || _ <- lists:seq(1, N)].

%%compareSpeed(List, Fun1, Fun2) ->
%%  F1 = fun() -> Fun1(List) end,
%%  F2 = fun() -> Fun2(List) end,
%%  {timer:tc(F1), timer:tc(F2)}.
