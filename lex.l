%{
#include <stdio.h> 
#include "y.tab.h"
%}

%option yylineno
delim		[ \t \n]
ws			{delim}+
letter		[A-Za-z]
digit		[0-9]
int			{digit}+
float		\.{int}|{int}\.{int}
id			{letter}({letter}|{digit})*
character  ['][^'\n]*[']
false_character     ['][^'\n]*
comment	[/][*](.)*[*][/]
false_comment   [/][*](.)*

%s COMMENT
%s LINECOMMENT

%%
<INITIAL>{comment}			{ 
    BEGIN INITIAL;
}
<INITIAL>{false_comment}             {  // 错误注释
    printf("Wrong Comment Format: %s\n", yytext); 
    return FALSECOMMENT;
}
<INITIAL>{character}			{ 
    BEGIN INITIAL;
}
<INITIAL>{false_character}             {  // 错误字符
    printf("Wrong Character Format: %s\n", yytext); 
    return FALSECHAR;
}
<COMMENT>.|\n				{ ;}
<INITIAL>"if"				{return (IF);}
<INITIAL>"then"				{return (THEN);}
<INITIAL>"else"				{return (ELSE);}
<INITIAL>"while"			{return (WHILE);}
<INITIAL>"and"              {return (AND);}
<INITIAL>"do"				{return (DO);}
<INITIAL>"program"			{return (PROGRAM);}
<INITIAL>"begin"			{return (BEGIN0);}
<INITIAL>"end"				{return (END);}
<INITIAL>"until"			{return (UNTIL);}
<INITIAL>"var"				{return (VAR);}
<INITIAL>"integer"			{return (INTEGER);}
<INITIAL>"real"				{return (REAL);}
<INITIAL>"repeat"			{return (REPEAT);}
<INITIAL>"<"				{return (LT);}
<INITIAL>"<="				{return (LE);}
<INITIAL>">"				{return (GT);}
<INITIAL>">="				{return (GE);}
<INITIAL>"="				{return (EQ);}
<INITIAL>"<>"				{return (NE);}
<INITIAL>"+"				{return (PLUS);}
<INITIAL>"-"				{return (MINUS);}
<INITIAL>"*"				{return (TIMES);}
<INITIAL>"/"				{return (DIVIDE);}
<INITIAL>":="				{return (ASSIGNMENT);}
<INITIAL>";"				{return (SEMI);}
<INITIAL>":"				{return (COLON);}
<INITIAL>","				{return (COMMA);}
<INITIAL>"."				{return (DOT);}
<INITIAL>"finish"			{return (FINISH);}
{id}			yylval.id=strdup(yytext); return ID;
{int}			yylval.i = atoi(yytext); return INT;
{float}			yylval.f = atoi(yytext); return FLOAT;
{ws}				{;}
. {  //其他非法字符
    printf("Illegal character: %s\n",yytext);
    return ILLEGALCHR;
}

%%
