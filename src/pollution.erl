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
-export([createMonitor/0, addStation/3, addValue/5, removeValue/4, getOneValue/4, getStationMean/3,
  getDailyMean/3, getPredictedIndex/4]).
-record(station, {coords, name}).
-record(reading, {station, date, type}).
-record(monitor, {stations, readings}).

createMonitor() -> #monitor{stations = #{}, readings = #{}}.

addStation(Coords, Name, #monitor{stations = Stations, readings = Readings}) ->
  case maps:is_key(Name, Stations) orelse maps:is_key(Coords, Stations) of
    true -> throw("Station already exists");
    false -> addStation(Coords, Name, Stations, Readings)
  end.

addStation(Coords, Name, Stations, Readings) ->
  S = #station{coords = Coords, name = Name},
  #monitor{stations = Stations#{Coords => S, Name => S}, readings = Readings}.

addValue(Station, Date, Type, Value, #monitor{stations = Stations, readings = Readings}) ->
  case maps:is_key(Station, Stations) of
    false -> throw("Station does not exists");
    true -> addValue(Stations, maps:get(Station, Stations), Date, Type, Value, Readings)
  end.

addValue(Stations, Station, Date, Type, Value, Readings) ->
  case maps:is_key(#reading{station = Station, date = Date, type = Type}, Readings) of
    true -> throw("You cannot add multiple readings of same type, date and station");
    false -> #monitor{stations = Stations, readings =
    Readings#{#reading{station = Station, type = Type, date = Date} => Value}}
  end.

removeValue(Station, Date, Type, #monitor{stations = Stations, readings = Readings}) ->
  case maps:is_key(Station, Stations) of
    false -> throw("Station does not exists");
    true -> removeValue(Stations, Readings, maps:get(Station, Stations), Date, Type)
  end.

removeValue(Stations, Readings, Station, Date, Type) ->
  #monitor{stations = Stations, readings = maps:remove(
    #reading{station = Station, date = Date, type = Type}, Readings
  )}.

getOneValue(Station, Date, Type, #monitor{stations = Stations, readings = Readings}) ->
  case maps:is_key(Station, Stations) of
    false -> throw("Station does not exists");
    true -> getOneValueValid(Readings, maps:get(Station, Stations), Date, Type)
  end.

getOneValueValid(Readings, Station, Date, Type) ->
  R = #reading{station = Station, date = Date, type = Type},
  case maps:is_key(R, Readings) of
    false -> throw("Reading does not exist");
    true -> maps:get(R, Readings)
  end.

getStationMean(Station, Type, #monitor{stations = Stations, readings = Readings}) ->
  case maps:is_key(Station, Stations) of
    false -> throw("Station does not exists");
    true -> getStationMeanValid(Readings, maps:get(Station, Stations), Type)
  end.

getStationMeanValid(Readings, Station, Type) ->
  Pred = fun(K, _) -> K#reading.station == Station andalso K#reading.type == Type end,
  R = maps:filter(Pred, Readings),
  mean(maps:values(R)).

getDailyMean(Date, Type, #monitor{readings = Readings}) ->
  case calendar:valid_date(Date) of
    true -> getDailyMeanValid(Readings, Date, Type);
    _ -> throw("Invalid date")
  end.

getDailyMeanValid(Readings, Date, Type) ->
  Pred = fun(K, _) -> element(1, K#reading.date) == Date andalso K#reading.type == Type end,
  R = maps:filter(Pred, Readings),
  mean(maps:values(R)).

getPredictedIndex(Station, Date, Type, #monitor{stations = Stations, readings = Readings}) ->
  case maps:is_key(Station, Stations) of
    false -> throw("Station does not exists");
    true -> getPredictedIndexValid(maps:get(Station, Stations), Date, Type, Readings)
  end.

toSeconds(Date) -> calendar:datetime_to_gregorian_seconds(Date).
subtractDay(Date) -> calendar:gregorian_days_to_date(calendar:date_to_gregorian_days(element(1, Date)) - 1).
isBetween(Date, Start, End) -> Date >= Start andalso Date =< End.

getPredictedIndexValid(Station, Date, Type, Readings) ->
  StartDate = toSeconds({subtractDay(Date), element(2, Date)}),
  EndDate = toSeconds(Date),
  Pred = fun(K, _) -> isBetween(toSeconds(K#reading.date), StartDate, EndDate)
    andalso K#reading.type == Type andalso K#reading.station == Station end,
  Interval = 24 * 60 * 60,
  MapToWeights = fun(K, V) -> {V, (toSeconds(K#reading.date) - StartDate) * V / Interval}  end,
  R = maps:values(maps:map(MapToWeights, maps:filter(Pred, Readings))),
  weightedAvg(lists:map(fun({X, _}) -> X end, R), lists:map(fun({_,Y}) -> Y end, R)).

weightedAvg(Values, Weights) ->
  lists:sum(lists:zipwith(fun(X, Y) -> X*Y end, Values, Weights))/lists:sum(Weights).

mean([]) -> throw("No readings for given arguments ");
mean(L) -> lists:sum(L) / length(L).

