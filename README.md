# Advent of Code 2019

## Each Day

To download the input and create test and source files for a particular day, make sure the `AOC_SESSION` env var has your session cookie value, and then run:

```sh
$ mix day.setup <day>
```

For instance, to setup day 3, run:

```sh
$ mix day.setup 3
```

Then, to run the code and output the solution, run:

```sh
$ mix day.run <day> <part> <optional args>
```

For example, run day 2 part 2 and pass an argument of 19690720 (which will be passed along to the `Day02.part2` function):

```sh
$ mix day.run 2 2 19690720
```
