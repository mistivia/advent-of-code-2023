all: 1.out 2.out
LIB=../lib/str.c

1.out: 1.c
	cc -g -I../lib/ $< $(LIB) -o $@

2.out: 2.c
	cc -g -I../lib/ $< $(LIB) -o $@

.PHONY: clean
clean:
	-rm *.out
