%%%-------------------------------------------------------------------
%%% @author kariok
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. Mar 2019 11:55
%%%-------------------------------------------------------------------
-module(myLists).
-author("kariok").

%% API
-export([contains/2, duplicateElements/1, sumFloats/1]).

contains([], _) -> false;

contains([H | T], Value) ->
  H == Value orelse contains(T, Value).


duplicateElements([]) ->
  [];
duplicateElements([H | T]) ->
  [H | [H | duplicateElements(T)]].



sumFloats([]) ->
  0.0;
sumFloats([H | T]) when is_float(H) ->
  H + sumFloats(T);
sumFloats(_) ->
  error("invalid argument, must be list of floats").

