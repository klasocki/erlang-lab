%%%-------------------------------------------------------------------
%%% @author kariok
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. Mar 2019 15:39
%%%-------------------------------------------------------------------
-module('pollution').
-author("kariok").

%% API
-export([createMonitor/0, addStation/3, addValue/5, removeValue/4, getOneValue/4, getStationMean/3, getDailyMean/3]).
-record(station, {coords, name}).
-record(reading, {station, date, type, value}).
-record(monitor, {stations, readings}).

createMonitor() -> #monitor{stations=#{}, readings=[]}.

addStation(Coords, Name, #monitor{stations = Stations, readings = Readings}) ->
  case maps:is_key(Name, Stations) orelse maps:is_key(Coords, Stations) of
    true -> throw("Station already exists");
    false -> S = #station{coords = Coords, name = Name},
      #monitor{stations = Stations#{Coords => S, Name => S}, readings = Readings}
  end.

addValue(Station, Date, Type, Value, #monitor{stations = Stations, readings = Readings}) ->
  case maps:is_key(Station, Stations) of
    false -> throw("Station does not exists");
    true -> #monitor{stations = Stations, readings =
    [#reading{station = maps:get(Station, Stations), date = Date, type = Type, value = Value} | Readings]}
  end.

removeValue(Station, Date, Type, #monitor{stations = Stations, readings = Readings}) ->
  #monitor{stations = Stations, readings =
  [R || R <- Readings, R /= R#reading{station = maps:get(Station,Stations), date = Date, type = Type}]}.

getOneValue(Station, Date, Type, #monitor{stations = Stations, readings = Readings}) ->
  [R] = [R#reading.value
    || R <- Readings, R == R#reading{station = maps:get(Station, Stations), date = Date, type = Type}],
  R.

getStationMean(Station, Type, #monitor{stations = Stations, readings = Readings}) ->
  R = [R#reading.value || R <- Readings, R == R#reading{station = maps:get(Station, Stations), type = Type}],
  lists:sum(R) / length(R).

getDailyMean(Date, Type, #monitor{readings = Readings}) ->
  R = [R#reading.value || R <- Readings, R == R#reading{date = Date, type = Type}],
  lists:sum(R) / length(R).





