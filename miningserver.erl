-module(miningserver).
-import(string,[substr/3, right/3, concat/2]).
-export([server/1, startMiningServer/2, serverMining/2]).

get_random_string(Length, AllowedChars) ->
    lists:foldl(fun(_, Acc) ->
                        [lists:nth(rand:uniform(length(AllowedChars)),
                                   AllowedChars)]
                            ++ Acc
                end, [], lists:seq(1, Length)).

server(K) ->
    receive
        {connect, ClientNode} ->
            io:fwrite("Connection request received from node - ~p, sending value of K as ~w",[ClientNode, K]),
            ClientNode ! K,
            server(K);
        {message, ClientNode} ->
            ClientNode ! message,
            server(K);
        {Bitcoin, ClientNode} -> 
            io:fwrite("Boitcoin mined - ~p at node - ~p\n", [Bitcoin, ClientNode]),
            {_,Cpu} = statistics(runtime),
            {_,Real} = statistics(wall_clock),
            io:format("CPU : ~p, Real : ~p, Ratio : ~p ",[Cpu,Real,Cpu/Real]),
            server(K)
    end.

serverMining(K, 0) ->
    io:fwrite("Server Mining is finished for K = ~w", [K]);

serverMining(K, N) ->
    RandomString = get_random_string(5, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*"),
    FinalString = concat("99936590",RandomString),
    %io:fwrite("Mining for ~w zeros, String ~p and nounce ~w\n",[K, FinalString, N]),
    HashString = io_lib:format("~64.16.0b", [binary:decode_unsigned(crypto:hash(sha256, FinalString))]),
    Zerostring = right("", K, $0),
        Substring = substr(HashString, 1, K),
        if
            Zerostring == Substring ->
                io:fwrite("Boitcoin mined - ~p ~p at server\n", [FinalString, HashString]),
            {_,Cpu} = statistics(runtime),
            {_,Real} = statistics(wall_clock),
            io:format("CPU : ~p, Real : ~p, Ratio : ~p ",[Cpu,Real,Cpu/Real]);
            true -> ok
        end,
        serverMining(K, N-1).

startMiningServer(K, N) ->
    register(server, spawn(miningserver, server, [K])),
    serverMining(K, N),
    {_,_} = statistics(runtime),
    {_,_} = statistics(wall_clock).
    