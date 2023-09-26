-module(miningclient).
-import(string,[substr/3, right/3, concat/2]).
-export([get_random_string/2, client/3, startMiningClient/1]).

get_random_string(Length, AllowedChars) ->
    lists:foldl(fun(_, Acc) ->
                        [lists:nth(rand:uniform(length(AllowedChars)),
                                   AllowedChars)]
                            ++ Acc
                end, [], lists:seq(1, Length)).

client(K, 300000000, ServerNode) ->
    {server, ServerNode} ! finished,
    io:fwrite("Client is finished for K:~w\n",[K]);

client(K, N, ServerNode) ->
    {server, ServerNode} ! {message, self()},
    RandomString = get_random_string(5, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*"),
    FinalString = concat("99936590",RandomString),
    HashString = io_lib:format("~64.16.0b", [binary:decode_unsigned(crypto:hash(sha256, FinalString))]),
    receive
        message -> io:fwrite("Mining for ~w zeros, String ~p and nounce ~w\n. HashString is ~p",[K, FinalString, N, HashString]),
        %message -> io:fwrite(""),
        Zerostring = right("", K, $0),
        Substring = substr(HashString, 1, K),
        SendString = concat(FinalString," "),
        if
            Zerostring == Substring ->
                {server, ServerNode} ! {concat(SendString, HashString), self()};
            true -> ok
        end
    end,
    client(K, N+1, ServerNode).

startMiningClient(ServerNode) ->
    {server, ServerNode} ! {connect, self()},
    receive
        K -> io:fwrite("Received mining request from server for K = ~w", [K]),
        spawn(miningclient, client, [K, 0, ServerNode])
    end.