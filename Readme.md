# Project 1
**Group Members:**
1. Vaishnavi Chilakamarthi, UFID: 99936597, vchilakamarthi@ufl.edu 
2. Vanshika Mehrotra, UFID: 77239277 , vmehrotra@ufl.edu

**Description**

The goal of this project is to use Erlang and the actor model to build a good solution to the bitcoin mining problem that runs well on multi-core machines. Concurrency in Erlang is fundamental to its success. Rather than providing threads that share memory, each Erlang process executes in its own memory space and owns its own heap and stack. Processes can’t interfere with each other inadvertently, as is all too easy in threading models, leading to deadlocks and other horrors The ACTOR model will work as distributed system to find a hashed value (basically a string) that will have a smaller or equal value to the target hash and will contain some leading zeros that will be given by the user. The target hash algorithm we are using is SHA-256. We will also implement a basic client-server model to distribute work to multiple machines.

## Execution steps
1. cd the project1 folder
2. Start erl shell and compile both miningserver and miningclient using 'c(miningserver).' and 'c(miningclient).'
3. Run miningserver.erl with k as an argument where k is the no of leading zeros and N as the number of trials
4. Run miningclient.erl to start the connection between, the client will start mining and will provide the final string to the server which will be printed.
5. Ignore the warning and follow the inputs generated by code to start mining.



## Implementation Details

**System 1: miningserver.erl**
The Server on startup takes the number of leading zeros from the user as K and N as the number of trials and starts mining until clients are available.
When a client node is available for mining, the Server receives a connect request, processes it and sends the K value required for the client to start mining.
The Server consists of the logic to accept client requests, and print the coins mined by the clients as well as itself.



**System 2: miningclient.erl**


When a client node is created, it first needs to send a connection request to the server using the name of the node on which the server is running.
Once the connection is established, the client receives the number of zeros to mine, and spawns the Worker units on its own machine and generates as many bitcoins as possible. 
Wherever a bitcoin is mined, the data is sent to the Server and the server prints it.


In our project, we are using the get_random_string function to generate random strings based on the length of the string to be generated and the allowed characters for the random string, which is further hashed with SHA256. This generates a fixed length string of 32 digits. The total number of permutations for an alphanumeric string of 32 characters is (32)^36. This approach makes sures that no two worker nodes mine using the same string.



**1. Work Unit:**
The application follows a Client-Server architecture.
The work unit for the project refers to the number of calls the process will make to the method which does the work of generating random strings of length N, calculating the hash of each string and checking if the leading zeros are correct as per the requirement. We have executed the program in a 10th Gen Intel Quad-Core i5 system.

**2. Result for 4 leading zeros**

![Fig-1](https://github.com/vanshika2809/dosp_project1/blob/main/image-1.jpeg)

*Fig.1 Output for mining the coins with 4 leading zeros*


**3. Ratio of CPU time to Real Time**

The ratio of the cpu and real time is calculated to prove the parallel usage of the cores present in the machine and it illustrates the number of cores which are effectively used in computation.

Ratio= 3.46

![Fig-2](https://github.com/vanshika2809/dosp_project1/blob/main/ratio.jpeg)

*Fig.2 Output for the computation of ratio of the CPU time to the Real time*


**4. Largest coin found with highest leading zeros**

We found the largest coin to have seven zeros.

![Fig-3](https://github.com/vanshika2809/dosp_project1/blob/main/image.jpeg)

*Fig.3 Output for the coin found with 7 leading zeros*

 
**5. Largest number of working machines on which the code was run**

The size of the work unit refers to the number of subproblems that a worker gets in a single request from the boss. The code was simultaneously run on 6 nodes with one functioning as server and the other 5 as workers.
