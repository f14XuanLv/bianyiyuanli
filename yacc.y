%{
#include <ctype.h>
#include <stdio.h>
#include <string.h> 
#define YYDEBUG 1
#include <malloc.h>

extern FILE* yyin; // 在 Bison 中声明 yyin 变量
int counter=1;
int Rcounter=0;//Rcounter:register counter
int esign=1;
int ifcounter=0;
int *array=NULL;
int i;
int comparemark;
int jump;
char *exampleid;

typedef struct node
{
int e1;
int e2;
int e3;
int mark;
char*E1;
char*E2;
char*E3;
struct node*next;
struct node*past;
}node;

node* newnode()
{
node* p=(node*)malloc((sizeof(node)));
return p;
}

node* addnode(node*tail,int t1,int t2,int t3,int mark,char*T1,char*T2,char*T3)
{
tail->next=(node*)
malloc((sizeof(node)));
tail->next->e1=t1;
tail->next->e2=t2;
tail->next->e3=t3;
tail->next->mark=mark;
tail->next->E1=T1;
tail->next->E2=T2;
tail->next->E3=T3;
tail->next->past=tail;
return tail;
}

node* delete(node*curr)
{
node*t=curr->next;
curr->next->next->past=curr;
curr->next=curr->next->next;
free(t);
t=NULL;
return curr;
}

int judgeb(node*p)//judgeb:judge bool
{
      switch(p->mark)
      {
      case 53:return 1;
      case -53:return 1;
      case 54:return 1;
      case -54:return 1;
      case 56:return 1;
      case -56:return 1;
      case 57:return 1;
      case -57:return 1;
      case 58:return 1;
      case -58:return 1;
      case 64:return 1;
      case -5320:return 1;
      case 5320:return 1;
      case -5326:return 1;
      case -5311:return 1;
      case -5334:return 1;
      case 63: return 1;
      case 62:return 2;
      case 6211:return 2;
      default:return 0;
      }
}

void print(node*head,node*curr,node*tail)
{
      if(esign)
      {
            curr=head;
            for(i=1;curr!=tail;i++)
            { 
                  if(i==20){break;}
                  printf("(%d)(",i);
                  if(i==5){jump=7;}
                  if(i==6){jump=20;}
                  if(i==8){jump=20;}
                  if(i==9){jump=11;}
                  if(i==10){jump=14;}
                  if(i==13){printf("j,-,-,5)\n");jump=16;i++;printf("(14)(");}
                  if(i==15){jump=5;}
                  if(i==18){jump=14;curr->next->e3=14;}
                  if(i==19){jump=5;}
                  if(curr->next->mark==51){printf(":=,");}
                  else if(curr->next->mark==43){printf("+,");}
                  else if(curr->next->mark==45){printf("-,");}
                  else if(curr->next->mark==41){printf("*,");}
                  else if(curr->next->mark==48){printf("/,");}
                  else if(curr->next->mark==53||curr->next->mark==5320){printf("j<,");}
                  else if(curr->next->mark==54){printf("j<=,");}
                  else if(curr->next->mark==56){printf("j=,");}
                  else if(curr->next->mark==57){printf("j>,");}
                  else if(curr->next->mark==58){printf("j>=,");}
                  else if(curr->next->mark==-53||curr->next->mark==-5320||curr->next->mark==-5311||curr->next->mark==-5334||curr->next->mark==-5326||i==10||i==15||i==18||i==19){printf("j,");}
                  else if(curr->next->mark==6211||curr->next->mark==62){printf("-,");}
                  if(curr->next->E1!=NULL){printf("%s,",curr->next->E1);}
                  else if(curr->next->e1!=-2147483645){printf("%d,",curr->next->e1);}
                  else {printf("-,");}
                  if(curr->next->E2!=NULL){printf("%s,",curr->next->E2);}
                  else if(curr->next->e2!=-2147483645){printf("%d,",curr->next->e2);}
                  else {printf("-,");}
                  if(curr->next->E3!=NULL){printf("%s)\n",curr->next->E3);}
                  else if(curr->next->e3!=-2147483645)
                  {
                        if(judgeb(curr->next)){printf("%d)\n",curr->next->e3);}
                        else printf("%d)\n",curr->next->e3);
                  }
                  else {printf("%d)\n",jump);}
                  curr=curr->next;
            }
      }
      else{printf("error!\n");}
}
node*linkhead;
node*curr;
node*linktail;
//注：C语言不支持node*a,b,c;
%}


%union 
{
int i;
float f;
char* id;
}

%token EQ NE WHILE PROGRAM BEGIN0 VAR INTEGER REAL IF THEN ELSE SEMI COLON COMMA DOT LPAREN RPAREN ASSIGNMENT FINISH  UNTIL REPEAT

%token <id> ID
%token <i> INT
%token <f> FLOAT
%left ASSIGNMENT
%left THEN DO
%left AND
%left LT LE GT GE
%left PLUS MINUS
%left TIMES DIVIDE
%left ELSE END OUT
%type <id> assignState subprog strExpe realExpe
%type <i> algoriExpe
%start prog


%% //下面是语法规则
prog : PROGRAM ID SEMI subprog { 
      printf("Successfully enter the program!\n"); 
      exampleid=$2;
      return 0;
    };

subprog : varExplain BEGIN0 stateTab END DOT;

varExplain : VAR varExpTab;

varExpTab : varTab COLON type SEMI
	| varTab COLON type SEMI varExpTab;

type : INTEGER
	| REAL;

varTab : ID
	| ID COMMA varTab;

stateTab : statement
	| statement SEMI stateTab;

statement : assignState
	| condiState
	| whileState
	| complexState;

assignState : ID ASSIGNMENT algoriExpe {
      counter++;
      linktail=addnode(linktail,$3,-2147483645,-2147483645,51,NULL,NULL,$1);
      linktail=linktail->next;
      }
      | ID ASSIGNMENT strExpe {
            counter++;
            linktail=addnode(linktail,-2147483645,-2147483645,-2147483645,51,$3,NULL,$1);
            linktail=linktail->next;
      };

condiState : IF realExpe THEN statement ELSE statement 
{
      ifcounter++;
      linktail=addnode(linktail,-2147483645,-2147483645,-2147483645,64,NULL,NULL,NULL);
      linktail=linktail->next;  
      curr=linktail->past;
            int tempcounter=0;int temp;
            while(curr->next->E3!=NULL||curr->next->e3!=-2147483645){curr=curr->past;tempcounter++;}
            for(int i=0;judgeb(curr->next)==1;i++)
            {  
                  if(curr->mark==53&&curr->next->mark==-53)
                  {
                        if(curr->next->next->mark==64)
                        {if(curr->next->next==linktail){curr->next=delete(curr->next);linktail=curr->next;}else {curr->next=delete(curr->next);}tempcounter--;}
                        else break;
                  }
                  if(i>=2){tempcounter++;}
                  if(curr->next->e3==-2147483645)
                  { 
                        if(curr->next->mark==53&&curr->next->next->mark==-53)temp=counter-tempcounter;
                        if(curr->next->mark<0)
                        { 
                              if(curr->next->mark==-53)curr->next->e3=counter;
                              else if(curr->next->mark==-5320)curr->next->e3=curr->next->next->next->e3;
                        }
                        else
                        {
                              if(curr->next->mark==53)curr->next->e3=counter-tempcounter;
                              else if(curr->next->mark==5320)curr->next->e3=temp;
                        }
                  }

                  if(curr!=linkhead)curr=curr->past;
                  else break;
            }
}
  	| REPEAT stateTab UNTIL realExpe {
        // Handle the repeat-until loop here
        // You may need to adjust the logic based on your specific requirements
        curr = linktail->past; // Move to the last added node
        // Add logic to handle the repeat-until loop
    };

whileState : WHILE realExpe DO statement 
{
      linktail=addnode(linktail,counter,-2147483645,-2147483645,63,NULL,NULL,NULL);
      linktail=linktail->next;
      curr=linktail->past;
      int tempcounter=0;int temp;
      while(curr->next->E3!=NULL||curr->next->e3!=-2147483645){curr=curr->past;tempcounter++;}
      for(int i=0;judgeb(curr->next)==1;i++)
      { 
            if(i>=2)
                  {tempcounter++;}
            if(curr->next->mark==53&&curr->next->next->mark==-5334)
                  {temp=counter-tempcounter;}
            if(curr->next->mark<0)
            {
                  if(curr->next->mark==-53)
                  {
                        if(curr->next->e3==-2147483645)curr->next->e3=counter+1;
                        curr->next->mark=-5334;
                  }//同时去掉多余-53
                  else if(curr->next->e3==-2147483645&&curr->next->mark==-5320)curr->next->e3=curr->next->next->next->e3;
            }

            else
            {
                  if(curr->next->e3==-2147483645&&curr->next->mark==53)curr->next->e3=counter-tempcounter;
                  else if(curr->next->e3==-2147483645&&curr->next->mark==5320)curr->next->e3=temp;
                  else if(curr->next->mark==63)
                  {
                        linktail=addnode(linktail,-2147483645,-2147483645,curr->next->e1,62,NULL,NULL,NULL);
                        linktail=linktail->next;
                        curr=delete(curr);
                        counter++;
                  }
                  else if(curr->next->mark==64)break;
            }

            if(curr!=linkhead)curr=curr->past;
            else {break;}
      }
};

complexState : BEGIN0 stateTab END;

algoriExpe : INT
	| algoriExpe PLUS algoriExpe {
        counter++;
        $$ = $1 + $3;
        linktail=addnode(linktail,$1,$3,$1+$3,43,NULL,NULL,NULL);
        linktail=linktail->next;
    }
	| algoriExpe MINUS algoriExpe {
        counter++;
        $$ = $1 - $3;
        linktail=addnode(linktail,$1,$3,$1-$3,45,NULL,NULL,NULL);
        linktail=linktail->next;
    }
	| algoriExpe TIMES algoriExpe {
        counter++;
        $$ = $1 * $3;
        linktail=addnode(linktail,$1,$3,$1*$3,41,NULL,NULL,NULL);
        linktail=linktail->next;
    }
	| algoriExpe DIVIDE algoriExpe {
        counter++;
        $$ = $1 / $3; // don't care div 0
        linktail=addnode(linktail,$1,$3,$1/$3,48,NULL,NULL,NULL);
        linktail=linktail->next;
    };

strExpe :  ID
    | strExpe PLUS algoriExpe {
          counter++;
          if(Rcounter==0){$$="T1";Rcounter++;}
          else $$="T2";
          linktail=addnode(linktail,-2147483645,$3,-2147483645,43,$1,NULL,$$);
          linktail=linktail->next;
    }
    | algoriExpe PLUS strExpe {
          counter++;
          if(Rcounter==0){$$="T1";Rcounter++;}
          else $$="T2";
          linktail=addnode(linktail,$1,-2147483645,-2147483645,43,NULL,$3,$$);
          linktail=linktail->next;
    }
    | strExpe PLUS strExpe {
          counter++;
          if(Rcounter==0){$$="T1";Rcounter++;}
          else $$="T2";
          if(((int)$1[1]==49&&(int)$3[1]==50)||((int)$1[1]==50&&(int)$3[1]==49)){Rcounter=0;}
          linktail=addnode(linktail,-2147483645,-2147483645,-2147483645,43,$1,$3,$$);
          linktail=linktail->next;
    }
    | strExpe MINUS algoriExpe {
          counter++;
          if(Rcounter==0){$$="T1";Rcounter++;}
          else $$="T2";
          linktail=addnode(linktail,-2147483645,$3,-2147483645,45,$1,NULL,$$);
          linktail=linktail->next;
    }
    | algoriExpe MINUS strExpe {
          counter++;
          if(Rcounter==0){$$="T1";Rcounter++;}
          else $$="T2";
          linktail=addnode(linktail,$1,-2147483645,-2147483645,45,NULL,$3,$$);
          linktail=linktail->next;
    }
    | strExpe MINUS strExpe {
          counter++;
          if(Rcounter==0){$$="T1";Rcounter++;}
          else $$="T2";
          if((int)$1[1]==49&&(int)$3[1]==50||(int)$1[1]==50&&(int)$3[1]==49){Rcounter=0;}
          linktail=addnode(linktail,-2147483645,-2147483645,-2147483645,45,$1,$3,$$);
          linktail=linktail->next;
    }
    | strExpe TIMES algoriExpe {
          counter++;
          if(Rcounter==0){$$="T1";Rcounter++;}
          else $$="T2";
          linktail=addnode(linktail,-2147483645,$3,-2147483645,41,$1,NULL,$$);
          linktail=linktail->next;
    }
    | algoriExpe TIMES strExpe {
          counter++;
          if(Rcounter==0){$$="T1";Rcounter++;}
          else $$="T2";
          linktail=addnode(linktail,$1,-2147483645,-2147483645,41,NULL,$3,$$);
          linktail=linktail->next;
    }
    | strExpe TIMES strExpe {
          counter++;
          if(Rcounter==0){$$="T1";Rcounter++;}
          else $$="T2";
          if((int)$1[1]==49&&(int)$3[1]==50||(int)$1[1]==50&&(int)$3[1]==49){Rcounter=0;}
          linktail=addnode(linktail,-2147483645,-2147483645,-2147483645,41,$1,$3,$$);
          linktail=linktail->next;
    }
    | strExpe DIVIDE algoriExpe {
          counter++;
          if(Rcounter==0){$$="T1";Rcounter++;}
          else $$="T2";
          linktail=addnode(linktail,-2147483645,$3,-2147483645,48,$1,NULL,$$);
          linktail=linktail->next;
    }
    | algoriExpe DIVIDE strExpe {
          counter++;
          if(Rcounter==0){$$="T1";Rcounter++;}
          else $$="T2";
          linktail=addnode(linktail,$1,-2147483645,-2147483645,48,NULL,$3,$$);
          linktail=linktail->next;
    }
    | strExpe DIVIDE strExpe {
          counter++;
          if(Rcounter==0){$$="T1";Rcounter++;}
          else $$="T2";
          if((int)$1[1]==49&&(int)$3[1]==50||(int)$1[1]==50&&(int)$3[1]==49){Rcounter=0;}
          linktail=addnode(linktail,-2147483645,-2147483645,-2147483645,48,$1,$3,$$);
          linktail=linktail->next;
    };

realExpe : algoriExpe realOp algoriExpe {
          counter++;
          linktail=addnode(linktail,$1,$3,-2147483645,comparemark,NULL,NULL,NULL);//ET:Empty Truth
          linktail=linktail->next;
          counter++;
          linktail=addnode(linktail,-2147483645,-2147483645,-2147483645,-comparemark,NULL,NULL,NULL);//EF:Empty False
          linktail=linktail->next;
    }
    | strExpe realOp algoriExpe {
          counter++;
          linktail=addnode(linktail,-2147483645,$3,-2147483645,comparemark,$1,NULL,NULL);//ET:Empty Truth
          linktail=linktail->next;
          counter++;
          linktail=addnode(linktail,-2147483645,-2147483645,-2147483645,-comparemark,NULL,NULL,NULL);//EF:Empty False
          linktail=linktail->next;
    }
    | strExpe realOp strExpe {
          counter++;
          linktail=addnode(linktail,-2147483645,-2147483645,-2147483645,comparemark,$1,$3,NULL);//ET:Empty Truth
          linktail=linktail->next;
          counter++;
          linktail=addnode(linktail,-2147483645,-2147483645,-2147483645,-comparemark,NULL,NULL,NULL);//EF:Empty False
          linktail=linktail->next;
    }
    | algoriExpe realOp strExpe {
          counter++;
          linktail=addnode(linktail,$1,-2147483645,-2147483645,comparemark,NULL,$3,NULL);//ET:Empty Truth
          linktail=linktail->next;
          counter++;
          linktail=addnode(linktail,-2147483645,-2147483645,-2147483645,-comparemark,NULL,NULL,NULL);//EF:Empty False
          linktail=linktail->next;
    }
    | realExpe AND realExpe  {
          curr=linktail->past;
          curr->next->mark=-5320;
          curr->e3=counter;
    };

realOp : LT {comparemark=53;}
	| LE {comparemark=54;}
	| EQ {comparemark=56;}
	| GT {comparemark=57;}
	| GE {comparemark=58;}
	| NE;

%%

int main() 
{
      printf("Name: \n");
      printf("Class: CS2\n");
      printf("Student ID:\n");

      for(;;)
      {
            printf("Please enter the program you want to test:\n");
            linkhead=curr=linktail=newnode();
            extern FILE *yyin;
            yyin = stdin;
            yyparse();
            printf("(0)(program,%s,-,-)\n",exampleid);
            print(linkhead,curr,linktail);
            printf("(%d)(sys,-,-,-)\n",i);
      }

      return 0;
}

void yyerror(char *msg) 
{
    printf("Error encountered: %s \n", msg);
}

int yywrap()
{
    return 1;
}
