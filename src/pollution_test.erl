%%%-------------------------------------------------------------------
%%% @author kariok
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Apr 2019 15:02
%%%-------------------------------------------------------------------
-module(pollution_test).
-author("kariok").
-include_lib("eunit/include/eunit.hrl").

prep_monitor() ->
  pollution:addValue("Aleja Slowackiego", {{2019, 4, 10}, {14, 9, 19}}, "PM2.5", 55,
    pollution:addValue("Krasinskiego", {{2019, 4, 10}, {12, 9, 19}}, "PM2.5", 45,
      pollution:addValue("Krasinskiego", {{2019, 4, 11}, {1, 9, 19}}, "PM10", 95,
        pollution:addValue({23.5, 50}, {{2019, 4, 10}, {15, 9, 19}}, "PM10", 105,
          pollution:addStation({23.5, 50}, "Krasinskiego",
            pollution:addStation({25, 55.5}, "Aleja Slowackiego", pollution:createMonitor())))))).

get_one_value_test() ->
  ?assertEqual(pollution:getOneValue({25, 55.5}, {{2019, 4, 10}, {14, 9, 19}}, "PM2.5", prep_monitor()), 55).

get_daily_mean_test() ->
  ?assertEqual(pollution:getDailyMean({2019, 4, 10}, "PM2.5", prep_monitor()), 50.0).

remove_value_test() ->
  ?assertEqual(pollution:getDailyMean({2019, 4, 10}, "PM2.5",
    pollution:removeValue({23.5, 50}, {{2019, 4, 10}, {12, 9, 19}}, "PM2.5", prep_monitor())),
    55.0).

get_station_mean_test() ->
  ?assertEqual(pollution:getStationMean("Krasinskiego", "PM10", prep_monitor()), 100.0).

get_predicted_index_test() ->
  ?assertEqual(pollution:getPredictedIndex
  ("Krasinskiego", {{2019, 4, 10}, {15, 9, 19}} ,"PM10", prep_monitor()), 105.0).

