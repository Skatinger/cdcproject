%%%-------------------------------------------------------------------
%%% @author alex
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. Nov 2018 10:27
%%%-------------------------------------------------------------------
-module(visual).
-author("alex").

%% API
-export([painter/1]).

%% ========== visual methods ===============
%% TODO
%% - register all controllers
%% - define grid representation
%% - pass gridsize dynamically
%% - define species count-representation, make fit in messaging module (someting like {"species", Count}

%% puts species counts and calls the grid-painter
painter(Grid) ->
  SpeciesCounts = get_species_counts(),
  io:format("======= INFO ========~n", []),
  io:format("== Current Species Counts: ==~n ] ~p~n", [SpeciesCounts]),
  %% TODO pass gridsize instead of 5
  GridState = get_grid_state(Grid),
  paint_grid(GridState, 5),
  timer:sleep(2000),
  painter(Grid).

%% takes a grid with all states and a gridsize and paints it to the console
%% N is the dimension of the grid, used to make linebreaks
paint_grid([],_) -> ok;
paint_grid([{State, Index}|T], N) ->
  if
  %% linebreak if end of line
    Index rem  N == 0 -> io:format("| ~p |~n", [State]);
    true -> io:format("| ~p |", [State])
  end,
  paint_grid(T, N).

%% gets all counts of species from controllers
get_species_counts() ->
  grasscontroller ! collect_info,
  rabbitcontroller ! collect_info,
  foxcontroller ! collect_info,
  SpeciesCounts = [receive {Species, Count} -> [{Species, Count}] end || _ <- lists:seq(1, 3)],
  SpeciesCounts.

%% sends message to first process and waits for the list to pass through grid and come back
get_grid_state([{_, First}, _]) ->
  First ! {collect_info, []},
  GridState = receive {collect_info, Result} -> ok end,
  GridState.

%% =================================================
