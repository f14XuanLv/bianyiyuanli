CC = gcc
LEX = win_flex
YACC = win_bison
RM = del

all:parser.exe

parser.exe:lex.yy.c y.tab.c y.tab.h
	$(CC) lex.yy.c y.tab.c -o parser

lex.yy.c:lex.l
	$(LEX) lex.l

y.tab.c:yacc.y
	$(YACC) -y yacc.y

y.tab.h:yacc.y
	$(YACC) -y -d yacc.y

clean:
	$(RM) parser.exe lex.yy.c y.tab.c y.tab.h

