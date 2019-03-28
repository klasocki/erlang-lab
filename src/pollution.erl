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

createMonitor() -> #monitor{stations=[], readings=[]}.

addStation(Coords, Name, #monitor{stations = Stations, readings = Readings}) ->
  #monitor{stations = [#station{coords = Coords, name = Name} | Stations], readings = Readings}.

addValue(Station, Date, Type, Value, #monitor{stations = Stations, readings = Readings}) ->
  #monitor{stations = Stations, readings =
  [ #reading{station = Station, date = Date, type = Type, value = Value} | Readings]}.

removeValue(Station, Date, Type, #monitor{stations = Stations, readings = Readings}) ->
  #monitor{stations = Stations, readings =
  [R || R <- Readings, R /= R#reading{station = Station, date = Date, type = Type}]}.

getOneValue(Station, Date, Type, #monitor{readings = Readings}) ->
  [R] = [R#reading.value || R <- Readings, R == R#reading{station = Station, date = Date, type = Type}],
  R.

getStationMean(Station, Type, #monitor{readings = Readings}) ->
  R = [R#reading.value || R <- Readings, R == R#reading{station = Station, type = Type}],
  lists:sum(R) / length(R).

getDailyMean(Date, Type, #monitor{readings = Readings}) ->
  R = [R#reading.value || R <- Readings, R == R#reading{date = Date, type = Type}],
  lists:sum(R) / length(R).





