CC=gcc
#CFLAGS=-std=gnu99 -g -Wall -Wextra -Werror -Wmissing-declarations -Wmissing-prototypes -Werror-implicit-function-declaration -Wreturn-type -Wparentheses -Wunused -Wold-style-definition -Wundef -Wshadow -Wstrict-prototypes -Wswitch-default -Wunreachable-code
LIBS=-pthread

A2_Impfzentrum_2d: A2_Impfzentrum_2d.o A2_utils.o
	$(CC) -o A2_Impfzentrum_2d A2_Impfzentrum_2d.o A2_utils.o $(LIBS)

A2_Impfzentrum_2c: A2_Impfzentrum_2c.o A2_utils.o
	$(CC) -o A2_Impfzentrum_2c A2_Impfzentrum_2c.o A2_utils.o $(LIBS)

A2_Impfzentrum_2a: A2_Impfzentrum_2a.o A2_utils.o
	$(CC) -o A2_Impfzentrum_2a A2_Impfzentrum_2a.o A2_utils.o $(LIBS)

A2_Impfzentrum_2d.o: A2_Impfzentrum_2d.c A2_utils.h
	$(CC) -o A2_Impfzentrum_2d.o -c A2_Impfzentrum_2d.c

A2_Impfzentrum_2c.o: A2_Impfzentrum_2c.c A2_utils.h
	$(CC) -o A2_Impfzentrum_2c.o -c A2_Impfzentrum_2c.c

A2_Impfzentrum_2a.o: A2_Impfzentrum_2a.c A2_utils.h
	$(CC) -o A2_Impfzentrum_2a.o -c A2_Impfzentrum_2a.c

A2_utils.o: A2_utils.c A2_utils.h
	$(CC) -c A2_utils.c -o A2_utils.o

clean:
	rm -f *.o A2_Impfzentrum_2a A2_Impfzentrum_2b A2_Impfzentrum_2c A2_Impfzentrum_2d
