## Description
The idea behind this project is to create a competition environment as simple as possible. One command to start the competition.

## How to use the environment
Make sure that Docker is running before you execute the commands.

to initialize the environment: ```./init.sh```

to stop the environment: ```./stop.sh```

to start it again: ```./start.sh```

and to clean the whole system: ```./clean.sh```

## How to access the environment
To access the git server use the subdomain git of your configured domain, e.g. http://git.local.skill17.com

To access the competitors work use the configured competitor subdomain and the module name, e.g. http://qwer-module_a.local.skill17.com

## How to configure the environment
The configuration of your competition is done in the config/main configuration file.

First line is the domain which the competition is using, e.g. local.skill17.com

Second line is the usage of https, e.g. false 

Third and fourth lines are the root username and password.

Fifth line is a whitespace separated list of the module name you want to use, e.g. module_a module_b

Starting from the sixth line are the credentials for the competitors and a random subdomain string, e.g. comp01 test123 qwer

## Naming of Repos
This has to be the same name specified in the main config file. If the modules are named e.g. module_a then the repo has to be named module_a as well.

## Createing a Repo
Open the right framework and click "Use this template"

Check the first item - .... Content

Add these two secrets to the repo: USER and PASS

These should be your username and passwort, e.g. comp01 and test123

## Updating
When updating this repo, make sure that the containers are not running.