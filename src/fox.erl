%%%-------------------------------------------------------------------
%%% @author alex
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. Nov 2018 11:49
%%%-------------------------------------------------------------------
-module(fox).
-author("alex").

%% API
-export([fox_initializer/2, fox/2, fox_controller/2]).
-import(common_behavior, [die/2, sleep/0]).
-import(messaging, [pass_field_info/1]).

fox_initializer(N, Fields) ->
  %% spawn N of foxes in the fields Fields
  % [spawn(?MODULE, fox, [Index, {ready, 0, 0}]) || (Index) <- SpawningPlaces]


  io:format("species-controller~n",[]).

fox_controller(N, Fields)->

  % initialize rabbits with initmethod
  %% spawn N of rabbits in the fields Fields
  % [spawn(?MODULE, rabbit, [Index, {ready, 0, 0}]) || (Index) <- SpawningPlaces]

  io:format("species-controller~n",[]).


%% own grid number, tuple of current state (eating, mating...), Rabbit size, current Age
fox(MyIndex, {State, Size, Age}) ->
  %% decide what behavior to do
  Rand = rand:uniform(10),
  %% too old, die of age
  if Age > 50 -> die(MyIndex, {State, Size, Age});
  %% 0.2 chance to sleep
    Rand > 7 -> sleep();
  %% do other behavior
    true -> ok
  end,

  %% not dead, find food on neighbouring fields
  Size = 1 + find_rabbit(neighbours),

  io:format("Rabbit~n").

%% TODO rethink this, now intended to ask all neighbour fields what they are. maybe register all empty-fields with their index
find_rabbit(Neighbours) ->
  [Pid ! what_are_you || Pid <- Neighbours],
  receive
    {{HisIndex, HisPid}, grass} -> eat(HisPid)
  after 20 -> ok
  end.


eat(Pid) ->
  Pid ! eaten,
  1.