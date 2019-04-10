%%%-------------------------------------------------------------------
%%% @author kariok
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Apr 2019 15:42
%%%-------------------------------------------------------------------
-module(pollution_server_test).
-author("kariok").

-include_lib("eunit/include/eunit.hrl").

prep_monitor() ->
  pollution_server:start(),
  pollution_server:addStation({25, 55.5}, "Aleja Slowackiego"),
  pollution_server:addStation({23.5, 50}, "Krasinskiego"),
  pollution_server:addValue({23.5, 50}, {{2019, 4, 10}, {15, 9, 19}}, "PM10", 105),
  pollution_server:addValue("Krasinskiego", {{2019, 4, 11}, {1, 9, 19}}, "PM10", 95),
  pollution_server:addValue("Krasinskiego", {{2019, 4, 10}, {12, 9, 19}}, "PM2.5", 45),
  pollution_server:addValue("Aleja Slowackiego", {{2019, 4, 10}, {14, 9, 19}}, "PM2.5", 55).

get_one_value_test() ->
  prep_monitor(),
  ?assertEqual(pollution_server:getOneValue({25, 55.5}, {{2019, 4, 10}, {14, 9, 19}}, "PM2.5"), 55),
  pollution_server:stop().

get_daily_mean_test() ->
  prep_monitor(),
  ?assertEqual(pollution_server:getDailyMean({2019, 4, 10}, "PM2.5"), 50.0),
  pollution_server:stop().

remove_value_test() ->
  prep_monitor(),
  pollution_server:removeValue({23.5, 50}, {{2019, 4, 10}, {12, 9, 19}}, "PM2.5"),
  ?assertEqual(pollution_server:getDailyMean({2019, 4, 10}, "PM2.5"), 55.0),
  pollution_server:stop().

get_station_mean_test() ->
  prep_monitor(),
  ?assertEqual(pollution_server:getStationMean("Krasinskiego", "PM10"), 100.0),
  pollution_server:stop().

get_predicted_index_test() ->
  prep_monitor(),
  ?assertEqual(pollution_server:getPredictedIndex("Krasinskiego", {{2019, 4, 10}, {15, 9, 19}} ,"PM10"), 105.0),
  pollution_server:stop().


