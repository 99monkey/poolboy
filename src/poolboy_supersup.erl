-module(poolboy_supersup).
-behavior(supervisor).
-export([start_link/0, stop/0, start_pool/3, stop_pool/1]).
-export([init/1]).


start_link() ->
  supervisor:start_link({local, poolboy}, ?MODULE, []).


stop() ->
  case whereis(poolboy) of
    P when is_pid(P) -> 
      exit(P, kill);
    _ -> ok
  end.


init([]) -> 
  MaxRestart = 6,
  MaxTime = 3600,
  {ok, {{one_for_one, MaxRestart, MaxTime}, []}}.

start_pool(Name, Limit, MFA) ->
  ChildSpec = {Name, 
                   {poolboy_sup, start_link, [Name, Limit, MFA]},
                   permanent, 10500, supervisor, [poolboy_sup]},
  supervisor:start_child(poolboy, ChildSpec).

stop_pool(Name) ->
  supervisor:terminate_child(poolboy, Name),
  supervisor:delete_child(poolboy, Name).

