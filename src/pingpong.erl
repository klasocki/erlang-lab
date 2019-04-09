%%%-------------------------------------------------------------------
%%% @author kariok
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. Apr 2019 11:30
%%%-------------------------------------------------------------------
-module(pingpong).
-author("kariok").

%% API
-export([start/0, stop/0, play/1]).

ping(Sum)->
  receive
    stop -> ok;
    {start, N} -> pong ! {msg, N},
                ping(0);
    {msg, 0} -> pong ! {msg, 0},
              ping(Sum);
    {msg,N} -> pong ! {msg, N-1},
              timer:sleep(1),
              io:format("Ping ~w~n", [Sum]),
              ping(N + Sum)
  after 20000 ->
    ok
  end.

pong(Sum) ->
  receive
    stop -> ok;
    {msg, 0} -> pong(0);
    {msg, N} -> ping ! {msg, N},
          timer:sleep(1),
          io:format("Pong ~w~n", [Sum]),
          pong(Sum + N)
  after 20000 ->
    ok
  end.

start() ->
  register(ping, spawn(fun() -> ping(0) end)),
  register(pong, spawn(fun() -> pong(0) end)).

stop() ->
  ping ! stop,
  pong ! stop.

play(N) ->
  ping ! {start, N}.


