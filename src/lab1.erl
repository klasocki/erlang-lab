%%%-------------------------------------------------------------------
%%% @author kariok
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. Mar 2019 11:45
%%%-------------------------------------------------------------------
-module(lab1).
-author("kariok").

%% API
-export([power/2]).


power(Base, Exponent) ->
  math:pow(Base, Exponent).