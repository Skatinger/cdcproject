%%%-------------------------------------------------------------------
%%% @author alex
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. Nov 2018 13:45
%%%-------------------------------------------------------------------
-module(rabbit).
-author("alex").

%% API
-export([rabbit_initializer/2, rabbit/2, rabbit_controller/2]).
-import(common_behavior, [die/2, sleep/0]).
-import(messaging, [pass_field_info/1]).

rabbit_initializer(N, Fields) ->
  %% spawn N of rabbits in the fields Fields
  % [spawn(?MODULE, rabbit, [Index, {ready, 0, 0}]) || (Index) <- SpawningPlaces]


  io:format("species-controller~n",[]).

rabbit_controller(N, Fields)->

  % initialize rabbits with initmethod
  %% spawn N of rabbits in the fields Fields
  % [spawn(?MODULE, rabbit, [Index, {ready, 0, 0}]) || (Index) <- SpawningPlaces]

  io:format("species-controller~n",[]).


%% own grid number, tuple of current state (eating, mating...), Rabbit size, current Age
rabbit(MyIndex, {State, Size, Age}) ->
  %% check if got eaten
  receive
    {eaten} -> die(MyIndex, {State, Size, Age})
  after 5 -> ok
  end,
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
  Size = 1 + find_grass(neighbours),

  io:format("Rabbit~n").

find_grass(Neighbours) ->
  [Pid ! what_are_you || Pid <- Neighbours],
  receive
    {{HisIndex, HisPid}, grass} -> eat(HisPid)
  after 20 -> ok
  end.


eat(Pid) ->
  Pid ! eaten,
  1.