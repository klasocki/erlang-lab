%%%-------------------------------------------------------------------
%%% @author kariok
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. Apr 2019 20:18
%%%-------------------------------------------------------------------
-module(pollution_server).
-author("kariok").

%% API
-export([start/0, stop/0, removeValue/3, addStation/2, addValue/4, getDailyMean/2, getOneValue/3,
  getStationMean/2, getPredictedIndex/3]).
-import(pollution, [removeValue/4, addStation/3, addValue/5, createMonitor/0, getDailyMean/3,
getOneValue/4, getStationMean/3, getPredictedIndex/4]).

loop(M) ->
  receive
    {PID, {addStation, Coords, Name}} -> PID ! ok, loop(addStation(Coords, Name, M));
    {PID, {addValue, Station, Date, Type, Value}} -> PID ! ok, loop(addValue(Station, Date, Type, Value, M));
    {PID, {removeValue, Station, Date, Type}} -> PID ! ok, loop(removeValue(Station, Date, Type, M));
    {PID, {getDailyMean, Date, Type}} -> PID ! getDailyMean(Date, Type, M), loop(M);
    {PID, {getOneValue, Station, Date, Type}} -> PID ! getOneValue(Station, Date, Type, M), loop(M);
    {PID, {getStationMean, Station, Type}} -> PID ! getStationMean(Station, Type, M), loop(M);
    {PID, {getPredictedIndex, Station, Date, Type}} -> PID ! getPredictedIndex(Station, Date, Type, M), loop(M);
    stop -> ok
  end.

call(Message) ->
  server ! {self(), Message},
  receive
    Reply -> Reply
  end.

init() ->
  loop(createMonitor()).

start() ->
  register(server, spawn(fun() -> init() end)).

stop() ->
  server ! stop.

addStation(Coords, Name) -> call({addStation, Coords, Name}).
addValue(Station, Date, Type, Value) -> call({addValue, Station, Date, Type, Value}).
removeValue(Station, Date, Type) -> call({removeValue, Station, Date, Type}).
getDailyMean(Date, Type) -> call({getDailyMean, Date, Type}).
getOneValue(Station, Date, Type) -> call({getOneValue, Station, Date, Type}).
getStationMean(Station, Type) -> call({getStationMean, Station, Type}).
getPredictedIndex(Station, Date, Type) -> call({getPredictedIndex, Station, Date, Type}).