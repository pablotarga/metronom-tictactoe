# TIC TAC TOE 2.0
We want to bring the pen-and-paper game Tic-tac-toe to the digital age, but with a little twist: the size of the playfield should be configurable between 3x3 and 10x10. And we also want the symbols (usually O and X) to be configurable. Also it should be for 3 players instead of just 2. A player can win the game by filling in a whole row, column or diagonal. If the playfiled is 5x5 - then the player must fill all the 5 cells in a row, column or diagonal to win.

**General Rules**: https://en.wikipedia.org/wiki/Tic-tac-toe

The three players play all together against each other. One of the players is an AI. Who is starting is random. In and output should be on the console. Input of the AI is automatic, no user action should be required. After each move, the new state of the playfield is displayed and the player can enter the next position of their character one after another. The next position should be provided in a format like 3,2. Invalid inputs are expected to be handled appropriately.

## Requirements:
- Do not use external frameworks and libraries, i.e. Spring, Django, React
JS, Vue JS, Angular JS, etc.
- You can use libraries only for testing or building purposes: e.g. JUnit,
Gradle, Rspec, Rake, GulpJS, etc.
- Software design is more important than a highly developed AI
- Use the programming language you feel most comfortable with.
- Configuration:
  - Size of the playground - always a square. Valid values are between 3 and 10.
  - Play character 1, 2 and 3: A single character for the first human player, A single character for the second human player - A single character for the computer.
  - These configurations should come from a file
- Rules:
  - Please provide an explanation how to run your code
  - Please explain your design decisions and assumptions
  - Don't include executables* in your submission.
  - Please write your solution in a way, that you would feel comfortable handing this over to a colleague and deploy it into production.
  - We especially look at design aspects (e.g. OOP) and if the code is well tested and understandable.

* this includes: asp, bat, class, cmd, com, cpl, dll, exe, fon, hta, ini,
ins, iw, jar, jsp, js, jse, pif, scr, shs, sh, vb, vbe, vbs, ws, wsc, wsf,
wsh & msi

# Config

The config is set to open the ```config.yml``` file. Here is how it looks for the proposed challenge:

```yaml
size: 3
players:
  X: keyboard
  O: keyboard
  A: ai
```

You can config the size and the players.

The size accepts numbers from 3 to 10 and will convert into integer if a string is informed.

The players config is set on ```key: value``` notation where the key is the symbol for the player and the value is the interface the player should use. Accepted values for the Interface are ```keyboard```, ```ai```, ```random```.

**Important notice!!** You need to re-build the docker image to include changes or you can mount the project folder using ```docker run -v "$PWD":/app -it tictactoe```

# Brief explanation about classes

## Aux::MovePredictor::AvailablePositions

This is the AI brain it receives a player and the board to analise and predict the best move to current player. It check on every range that has a uniq player and flag the best range for the current player and the best range of the most well positioned opponent then compare to decide if should invest on the best range or block opponents offensive range.

## Aux::MovePredictor::Minimax

This is the AI brain it receives a player and the board to analise and predict the best move to current player. It uses minimax algorithm with pruning and a depth limit to build different scenarios and determine the best outcome. Works well on 3x3 board but fails badly on bigger boards, need to work a better solution for the scoring method, currently not being used by the AI interface.

## Aux::Grid

The object that controls logic on how to store a 2D grid in a single array.

Has methods to translate x,y positions into a proper index and the other way around. It provides methods to easy access to columns, rows, diagonals, available positions, and collection of these ranges.

It is used on the project as an abstraction by Board.

## Board

This is the game's storage. It will track player moves and regulate when the game is over and if there is any winner.

It inherits from Aux::Grid and extends its initializer, set and clone_from methods.

## Player

A simple object that only knows about its own symbol and the interface which will pick/decide the moves.

## PlayerInterface models

**Important notice!** The Interface in this context refers only to the input type and not the java keyword ```interface```

Collection of classes that will change the way the player chooses its moves on the board.

The available interfaces are ```PlayerInterface::Keyboard```, ```PlayerInterface::Ai``` and ```PlayerInterface::Random```.

## Game

Orchestrator that keeps the playing order and set each picked move into the board. Breaks the flow when ```board.game_over?``` and prints the result.

It has a collection of rules that are printed before the game starts.

## GameLoader

Loads the config file and instantiate game objects based on the input. Accepts "readable" interface as input and "loadable" interface as the parser

# How to run Tic-Tac-Toe

This package is built using Ruby and I'm providing a Dockerfile to config and run the program.

## Build

With docker installed we need to build the image using the following command:

```
docker build . -t tictactoe
```

this will prepare, install dependencies and copy the project into /app folder.

## Play

Then we can run it using the following:

```
docker run -it tictactoe
```

The previous command will lead you straight into the game, and the rules are printed on the console.

## Run tests

You can test using the command:

```
docker run -it tictactoe rspec
```

This will run the specs saved under /spec folder

## Live code/Test/console

to access the console to manually run ruby code:

```
docker run -u $(id -u) -v "$PWD":/app -it tictactoe /bin/bash
```

* *-v "$PWD":/app*: mounts the current folder as a volume into /app, so changes on source will be available inside the container.
* */bin/bash*: will start the bash console inside the container

### Inside the container

ruby console: ```irb -I lib```

run the game: ```ruby -I lib app.rb```

run the tests: ```rspec```

run specific test: ```rspec path/to/file_or_folder```

* *-I lib*: will include the folder lib into the $LOAD_PATH so classes are available to be required using ```require 'class_name'```.
* *app.rb*: is the main file that will load the game and start it.
* *rspec*: there is a config file ```.rspec``` on the project root where *-I lib* is configured among other configs
* *rspec* 2: the spec files are inside ```spec/lib``` folder
