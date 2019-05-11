%%%-------------------------------------------------------------------
%%% @author kariok
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. Apr 2019 11:56
%%%-------------------------------------------------------------------
-module(pollution_gen_server).
-author("kariok").

-behaviour(gen_server).

%% API
-export([start_link/0, start/0, stop/0, addStation/2, addValue/4, getOneValue/3, crash/0,
  getStationMean/2, getPredictedIndex/3, getDailyMean/2, removeValue/3]).

%% gen_server callbacks
-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2]).

-define(SERVER, ?MODULE).

-spec(start_link() ->
  {ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).


init([]) ->
  {ok, pollution:createMonitor()}.

handle_call({getOneValue, Station, Date, Type}, _From, State) ->
  {reply, pollution:getOneValue(Station, Date, Type, State), State};

handle_call({getDailyMean, Date, Type}, _From, State) ->
  {reply, pollution:getDailyMean(Date, Type, State), State};

handle_call({getStationMean, Station, Type}, _From, State) ->
  {reply, pollution:getStationMean(Station, Type, State), State};

handle_call({getPredictedIndex, Station, Date, Type}, _From, State) ->
  {reply, pollution:getPredictedIndex(Station, Date, Type, State), State};

handle_call(_Request, _From, State) ->
  {reply, ok, State}.



handle_cast({addStation, Coords, Name}, State) ->
  {noreply, pollution:addStation(Coords, Name, State)};

handle_cast({addValue, Station, Date, Type, Value}, State) ->
  {noreply, pollution:addValue(Station, Date, Type, Value, State)};

handle_cast({removeValue, Station, Date, Type}, State) ->
  {noreply, pollution:removeValue(Station, Date, Type, State)};

handle_cast({stop}, State) ->
  terminate(normal, State);

handle_cast({crash}, _State) ->
  {noreply, 1/0};

handle_cast(_Request, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  {_Reason, ok}.


start() ->
  start_link().

stop() ->
  gen_server:cast(?MODULE, {stop}).

addStation(Coords, Name) ->
  gen_server:cast(?MODULE, {addStation, Coords, Name}).

addValue(Station, Date, Type, Value) ->
  gen_server:cast(?MODULE, {addValue, Station, Date, Type, Value}).

getOneValue(Station, Date, Type) ->
  gen_server:call(?MODULE, {getOneValue, Station, Date, Type}).

removeValue(Station, Date, Type) ->
  gen_server:cast(?MODULE, {removeValue, Station, Date, Type}).

getDailyMean(Date, Type) ->
  gen_server:call(?MODULE, {getDailyMean, Date, Type}).

getStationMean(Station, Type) ->
  gen_server:call(?MODULE, {getStationMean, Station, Type}).

getPredictedIndex(Station, Date, Type) ->
  gen_server:call(?MODULE, {getPredictedIndex, Station, Date, Type}).

crash() ->
  gen_server:cast(?MODULE, {crash}).