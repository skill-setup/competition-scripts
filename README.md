# Welcome 

## Description
The idea behind this project is to create a competition environment as simple as possible. One command to start the competition.

## How to use the environment
It is as simple as that

```init.sh```

to stop the environment use

```stop.sh```

to start it again use

```start.sh```

and to clean the whole system use

```clean.sh```

## How to access the environment
To access the git server use the subdomain git of your configured domain, e.g. git.skill17.localhost

To access the competitors work use the configured competitor subdomain and the module name, e.g. qwer-module_a.skill17.localhost

## How to configure the environment
The configuration of your competition is done in the config/main configuration file.

First line is the domain which the competition is using, e.g. skill17.localhost

Second and third lines are the root username and password.

Fourth line is a whitespace separated list of the module name you want to use, e.g. module_a module_b module_c

Starting from the fifth line are the credentials for the competitors and a random subdomain string, e.g. comp01 password subdomain