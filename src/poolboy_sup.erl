-module(poolboy_sup).
-export([start_link/3, init/1]).
-behavior(supervisor).


start_link(Name, Limit, MFA) ->
  supervisor:start_link(?MODULE, {Name, Limit, MFA}).


init({Name, Limit, MFA}) ->
  MaxRestart = 1,
  MaxTime = 3600,
  {ok, {{one_for_all, MaxRestart, MaxTime},
        [
         {serv, { poolboy_serv, start_link, [Name, Limit, self(), MFA]},
          permanent,
          5000,
          worker,
          [poolboy_serv]}]}}.
