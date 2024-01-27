all: run

run: part1 part2
	./part1
	./part2

part1: part1.c
	gcc -g -lm -I../lib/ ../lib/*.c part1.c -o part1

part2: part2.c
	gcc -g -lm -I../lib/ ../lib/*.c part2.c -o part2

clean:
	rm part1 part2
