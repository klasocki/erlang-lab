%%%-------------------------------------------------------------------
%%% @author kariok
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. Apr 2019 11:40
%%%-------------------------------------------------------------------
-module(pollution_server_sup).
-author("kariok").

%% API
-export([start/0]).

start() ->
  process_flag(trap_exit, true),
  spawn_link(pollution_server, start, []),
  loop().

loop() ->
  receive
    {'EXIT', _, _} -> spawn_link(pollution_server, start, []), loop()
  end.
