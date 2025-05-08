CC = gcc
CFLAGS = -Wall -g
OBJ = main.o BinaryGCD.o
EXEC = binaryGCD

all: $(EXEC)

$(EXEC): $(OBJ)
	$(CC) -o $@ $^

main.o: main.c
	$(CC) $(CFLAGS) -c $< -o $@

BinaryGCD.o: BinaryGCD.s
	$(CC) -c $< -o $@

clean:
	rm -f $(OBJ) $(EXEC)