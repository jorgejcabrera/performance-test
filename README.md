# Performance Test
It's a project that takes advantage of docker and makes the load test easier. Also, it collects metrics from each running container. 

[Locust](https://locust.io/) were used to create http traffic. It has been used in a distributed mode with one master and one or more workers. Master node controls the behavior of the slaves, collects the results and slaves do the job of generating the load. 
The Locust traffic will be targeted at a Spring Boot service which makes http calls towards a [Wiremock](http://wiremock.org/) server. Wiremock was set up with a delayDistribution to simulate the network behaviour in a better way.
### Requirements
You only need Docker

### Installation
To clone and run this project, you'll need [Git](https://git-scm.com) and [Docker](https://www.docker.com/get-started) installed on your computer. From your command line:
 ```shell script
$ docker-compose build 
 ```
### How to use it
 ```shell script
$ docker-compose up
 ```
or if you prefer, you can run more than one locust worker with the following command:
```shell script
$ docker-compose up --scale locustworker=2
```
Once the containers deploy were done, you will be able to visit localhost:8089 and start a load test.

### Customizing
First of all, you need to indicate which host you are going to test against. Thus, we must set ${ATTACKED_HOST} in the docker-compose.yml file. Also, you can modify the endpoint targeted in the _locust/locustfile.py_. For more information about locustfile click [here](https://docs.locust.io/en/latest/writing-a-locustfile.html).

If you want to modify your mappings at any point then you have to update the `wiremock/mappings/mock_responses.json` file even with the delay function.