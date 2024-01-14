%{
#include "header.h"

extern FILE* yyin;  // 声明外部文件指针

//每一个四元式都是一个node

node* linkhead;
node* current;
node* point;

node* nowNode;

int TnUse=1;//用于指示当前可用的Tn
char* _judgeType;//用于判断judgeJump的类型
nodes* AllNodes;

node* tempHead;
node* tempTail;

extern int yylineno; // 行号
extern int iserror = 0; // 用于判断是否有错误
%}


%union 
{
int i;
float f;
char* id;
struct nodes* Nodes;
}

%token EQ NE WHILE PROGRAM BEGIN0 VAR INTEGER REAL IF THEN ELSE SEMI COLON COMMA DOT LPAREN RPAREN ASSIGNMENT FINISH UNTIL REPEAT
%token FALSECHAR FALSECOMMENT ILLEGALCHR
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
%type <id> strExpe
%type <i> algoriExpe
%type <Nodes> statement stateTab assignState condiState whileState complexState subprog realExpe
%start prog

%%

//将产生式翻译成中文

prog : PROGRAM ID SEMI subprog { 
    linkhead = newnode();
    linkhead->type = 1;
    linkhead->programName = $2;
    AllNodes= newnodes();
    AllNodes->head=linkhead;
    AllNodes->tail=linkhead;
    merge(AllNodes,$4);

    node* sysNode = newnode();
    sysNode->type=6;
    addNodeToNodes(AllNodes,sysNode);

    printAllofNodes(AllNodes);
    
    return 0;
    };


subprog : varExplain BEGIN0 stateTab END DOT{
    
    $$ =$3;

};

varExplain : VAR varExpTab;

varExpTab : varTab COLON type SEMI
	| varTab COLON type SEMI varExpTab;

type : INTEGER
	| REAL;

varTab : ID
	| ID COMMA varTab;

stateTab : statement{
    $$=$1;
}
	| statement SEMI stateTab{
        node* stateNodes1;
        stateNodes1 = $1;
        node* stateNodes2;
        stateNodes2 = $3;
        merge(stateNodes1,stateNodes2);
        $$=stateNodes1;

    };

statement : assignState{$$=$1;}
	| condiState{$$=$1;}
	| whileState{$$=$1;}
	| complexState{$$=$1;};

assignState : ID ASSIGNMENT algoriExpe {
    //声明
    node* assignNode;
    assignNode = newnode();
    //属性
    assignNode->type =2;
    assignNode->assignType=1;
    assignNode->value1=$3;
    assignNode->variaName=$1;
    //链接

    nodes*assignNodes = newnodes();
    assignNodes->head=assignNode;
    assignNodes->tail=assignNode;
    $$=assignNodes;


    }
    | ID ASSIGNMENT strExpe {
        //声明
    node* assignNode;
    assignNode = newnode();
    //属性
    assignNode->type =2;
    assignNode->assignType=2;
    //------
    assignNode->value2=$3;
    assignNode->variaName=$1;
    //链接
    nodes*assignNodes = newnodes();
    assignNodes->head = assignNode;
    assignNodes->tail = assignNode;
    
    
    

    nodes* tempNodes = newnodes();
    if(tempHead!=NULL){
    tempNodes->head= tempHead;
    tempNodes->tail= tempTail;
    merge(tempNodes,assignNodes);}
    else{printf("NULL\n\n");
        tempNodes->head = assignNode;
        tempNodes->tail = assignNode;
    }

    tempHead=NULL;
    tempTail=NULL;
    $$=tempNodes;
    
    };  

condiState : IF realExpe THEN statement ELSE statement 
{
    nodes* realnodes = $2;
    int realNum = count(realnodes);
    

    nodes* thennodes = $4;
    int thenNum = count(thennodes);

    nodes* elsenodes = $6;
    int elseNum = count(elsenodes);


    node* temphead =  realnodes->head;

    while(1){
        if(temphead->type==4){
        temphead->relaJudgeJumpPosition+=2;}
        if(temphead==realnodes->tail)break;
        temphead = temphead->next;
    }

    node* jumpNode = newnode();
    jumpNode->type=3;
    jumpNode->relaJumpPosition=thenNum+2;

    node* jumpNode_ = newnode();
    jumpNode_->type=3;
    jumpNode_->relaJumpPosition=elseNum+1;
    
    nodes* endNodes;
    endNodes = realnodes;
    addNodeToNodes(endNodes,jumpNode);
    merge(endNodes,thennodes);
    addNodeToNodes(endNodes,jumpNode_);
    merge(endNodes,elsenodes);

    $$=endNodes;


}
  	| REPEAT stateTab UNTIL realExpe {
        nodes* realnodes = $4;
        int realNum = count(realnodes);
        

        nodes* thennodes = $2;
        int thenNum = count(thennodes);

        node* temphead =  realnodes->head;
        while(1){
            if(temphead->type==4){
            temphead->relaJudgeJumpPosition+=2;}
            if(temphead==realnodes->tail)break;
            temphead = temphead->next;
        }



        node* jumpNode = newnode();
        jumpNode->type=3;
        jumpNode->relaJumpPosition=-thenNum-1;

        
        nodes* endNodes;
        endNodes = thennodes;
        merge(endNodes,realnodes);
        addNodeToNodes(endNodes,jumpNode);

        $$=endNodes;
    };

whileState : WHILE realExpe DO statement 
{
    nodes* realnodes = $2;
        int realNum = count(realnodes);
        

        nodes* thennodes = $4;
        int thenNum = count(thennodes);

        node* temphead =  realnodes->head;
        while(1){
            if(temphead->type==4){
            temphead->relaJudgeJumpPosition+=2;}
            if(temphead->type==3){
            temphead->relaJumpPosition+=(thenNum+2);}
            if(temphead==realnodes->tail)break;
            temphead = temphead->next;
        }



        node* jumpNode = newnode();
        jumpNode->type=3;
        jumpNode->relaJumpPosition+=(thenNum+2);

        node* jumpNode_ = newnode();
        jumpNode_->type=3;
        jumpNode_->relaJumpPosition=-thenNum-1-realNum;
        
        nodes* endNodes;
        endNodes = realnodes;
        addNodeToNodes(endNodes,jumpNode);
        merge(endNodes,thennodes);
        addNodeToNodes(endNodes,jumpNode_);
        

        $$=endNodes;
};

complexState : BEGIN0 stateTab END;

algoriExpe : INT
	| algoriExpe PLUS algoriExpe {
        $$=$1+$3;
    }
	| algoriExpe MINUS algoriExpe {
        $$=$1-$3;
    }
	| algoriExpe TIMES algoriExpe {
        $$=$1*$3;
    }
	| algoriExpe DIVIDE algoriExpe {
        $$=$1/$3;
    };

strExpe :  ID{$$=$1;

}
    | strExpe PLUS algoriExpe {
        node* strNode;
        strNode = newnode();
          
        strNode->type=5;
        strNode->aloType="+";
        sprintf(strNode->left,"%s",$1);
        sprintf(strNode->right,"%d",$3);
        sprintf(strNode->res,"T%d",TnUse);
        TnUse++;
        if (tempHead==NULL){
            tempHead = strNode;
            tempTail = strNode;
        }else{
        tempTail = addNode(tempTail,strNode);
        }
        
        $$=strNode->res;
        
    }
    | algoriExpe PLUS strExpe {
        node* strNode;
        strNode = newnode();
          
        strNode->type=5;
        strNode->aloType="+";
        sprintf(strNode->left,"%d",$1);
        sprintf(strNode->right,"%s",$3);
        sprintf(strNode->res,"T%d",TnUse);
        TnUse++;
        if (tempHead==NULL){
            tempHead = strNode;
            tempTail = strNode;
        }else{
        tempTail = addNode(tempTail,strNode);
        }
        
        $$=strNode->res;
    }
    | strExpe PLUS strExpe {
        node* strNode;
        strNode = newnode();
          
        strNode->type=5;
        strNode->aloType="+";
        sprintf(strNode->left,"%s",$1);
        sprintf(strNode->right,"%s",$3);
        sprintf(strNode->res,"T%d",TnUse);
        TnUse++;
        if (tempHead==NULL){
            tempHead = strNode;
            tempTail = strNode;
        }else{
        tempTail = addNode(tempTail,strNode);
        }
        
        $$=strNode->res;

          
    }
    | strExpe MINUS algoriExpe {
        node* strNode;
        strNode = newnode();
          
        strNode->type=5;
        strNode->aloType="-";
        sprintf(strNode->left,"%s",$1);
        sprintf(strNode->right,"%d",$3);
        sprintf(strNode->res,"T%d",TnUse);
        TnUse++;
        if (tempHead==NULL){
            tempHead = strNode;
            tempTail = strNode;
        }else{
        tempTail = addNode(tempTail,strNode);
        }
        
        $$=strNode->res;
    }
    | algoriExpe MINUS strExpe {
        node* strNode;
        strNode = newnode();
          
        strNode->type=5;
        strNode->aloType="-";
        sprintf(strNode->left,"%d",$1);
        sprintf(strNode->right,"%s",$3);
        sprintf(strNode->res,"T%d",TnUse);
        TnUse++;
        if (tempHead==NULL){
            tempHead = strNode;
            tempTail = strNode;
        }else{
        tempTail = addNode(tempTail,strNode);
        }
        
        $$=strNode->res;
    }
    | strExpe MINUS strExpe {
        node* strNode;
        strNode = newnode();
          
        strNode->type=5;
        strNode->aloType="-";
        sprintf(strNode->left,"%s",$1);
        sprintf(strNode->right,"%s",$3);
        sprintf(strNode->res,"T%d",TnUse);
        TnUse++;
        if (tempHead==NULL){
            tempHead = strNode;
            tempTail = strNode;
        }else{
        tempTail = addNode(tempTail,strNode);
        }
        
        $$=strNode->res;
    }
    | strExpe TIMES algoriExpe {
        node* strNode;
        strNode = newnode();
          
        strNode->type=5;
        strNode->aloType="*";
        sprintf(strNode->left,"%s",$1);
        sprintf(strNode->right,"%d",$3);
        sprintf(strNode->res,"T%d",TnUse);
        TnUse++;
        if (tempHead==NULL){
            tempHead = strNode;
            tempTail = strNode;
        }else{
        tempTail = addNode(tempTail,strNode);
        }
        
        $$=strNode->res;
    }
    | algoriExpe TIMES strExpe {
        node* strNode;
        strNode = newnode();
          
        strNode->type=5;
        strNode->aloType="*";
        sprintf(strNode->left,"%d",$1);
        sprintf(strNode->right,"%s",$3);
        sprintf(strNode->res,"T%d",TnUse);
        TnUse++;
        if (tempHead==NULL){
            tempHead = strNode;
            tempTail = strNode;
        }else{
        tempTail = addNode(tempTail,strNode);
        }
        
        $$=strNode->res;
    }
    | strExpe TIMES strExpe {
          node* strNode;
        strNode = newnode();
          
        strNode->type=5;
        strNode->aloType="*";
        sprintf(strNode->left,"%s",$1);
        sprintf(strNode->right,"%s",$3);
        sprintf(strNode->res,"T%d",TnUse);
        TnUse++;
        if (tempHead==NULL){
            tempHead = strNode;
            tempTail = strNode;
        }else{
        tempTail = addNode(tempTail,strNode);
        }
        
        $$=strNode->res;
    }
    | strExpe DIVIDE algoriExpe {
          node* strNode;
        strNode = newnode();
          
        strNode->type=5;
        strNode->aloType="/";
        sprintf(strNode->left,"%s",$1);
        sprintf(strNode->right,"%d",$3);
        sprintf(strNode->res,"T%d",TnUse);
        TnUse++;
        if (tempHead==NULL){
            tempHead = strNode;
            tempTail = strNode;
        }else{
        tempTail = addNode(tempTail,strNode);
        }
        
        $$=strNode->res;
    }
    | algoriExpe DIVIDE strExpe {
        node* strNode;
        strNode = newnode();
          
        strNode->type=5;
        strNode->aloType="/";
        sprintf(strNode->left,"%d",$1);
        sprintf(strNode->right,"%s",$3);
        sprintf(strNode->res,"T%d",TnUse);
        TnUse++;
        if (tempHead==NULL){
            tempHead = strNode;
            tempTail = strNode;
        }else{
        tempTail = addNode(tempTail,strNode);
        }
        
        $$=strNode->res;
    }
    | strExpe DIVIDE strExpe {
        node* strNode;
        strNode = newnode();
          
        strNode->type=5;
        strNode->aloType="/";
        sprintf(strNode->left,"%s",$1);
        sprintf(strNode->right,"%s",$3);
        sprintf(strNode->res,"T%d",TnUse);
        TnUse++;
        if (tempHead==NULL){
            tempHead = strNode;
            tempTail = strNode;
        }else{
        tempTail = addNode(tempTail,strNode);
        }
        
        $$=strNode->res;
    };

realExpe : algoriExpe realOp algoriExpe {
    
        
        char tempstr[16] = {0};
        char tempstr_[16] = {0};
        node* ifNode;
        ifNode = newnode();
        ifNode->type=4;
        ifNode->judgeType = _judgeType;
        sprintf(ifNode->judgeLeft,"%d",$1);
        sprintf(ifNode->judgeRight,"%d",$3);

        nodes* ifNodes = newnodes();
        if(tempHead == NULL){
            ifNodes->head = ifNode;
            ifNodes->tail = ifNode;
        }else{
        ifNodes->head= tempHead;
        ifNodes->tail= tempTail;
        addNodeToNodes(ifNodes,ifNode);
        }
        tempHead=NULL;
        tempTail=NULL;
        $$ = ifNodes;
    }
    | strExpe realOp algoriExpe {
        
        char tempstr[16] = {0};
        char tempstr_[16] = {0};
        node* ifNode;
        ifNode = newnode();
        ifNode->type=4;
        ifNode->judgeType = _judgeType;
        sprintf(ifNode->judgeLeft,"%s",$1);
        sprintf(ifNode->judgeRight,"%d",$3);

        nodes* ifNodes = newnodes();
        if(tempHead == NULL){
            ifNodes->head = ifNode;
            ifNodes->tail = ifNode;
        }else{
        ifNodes->head= tempHead;
        ifNodes->tail= tempTail;
        addNodeToNodes(ifNodes,ifNode);
        }
        tempHead=NULL;
        tempTail=NULL;
        $$ = ifNodes;
    }
    | strExpe realOp strExpe {
        char tempstr[16] = {0}; 
        char tempstr_[16] = {0};
        node* ifNode;
        ifNode = newnode();
        ifNode->type=4;
        ifNode->judgeType = _judgeType;
        sprintf(ifNode->judgeLeft,"%s",$1);
        sprintf(ifNode->judgeRight,"%s",$3);

        nodes* ifNodes = newnodes();
        if(tempHead == NULL){
            ifNodes->head = ifNode;
            ifNodes->tail = ifNode;
        }else{
        ifNodes->head= tempHead;
        ifNodes->tail= tempTail;
        addNodeToNodes(ifNodes,ifNode);
        }
        tempHead=NULL;
        tempTail=NULL;
        $$ = ifNodes;
    }
    | algoriExpe realOp strExpe {
        
        
        char tempstr[16] = {0};
        char tempstr_[16] = {0};
        node* ifNode;
        ifNode = newnode();
        ifNode->type=4;
        ifNode->judgeType = _judgeType;
        sprintf(ifNode->judgeLeft,"%d",$1);
        sprintf(ifNode->judgeRight,"%s",$3);

        nodes* ifNodes = newnodes();
        if(tempHead == NULL){
            ifNodes->head = ifNode;
            ifNodes->tail = ifNode;
        }else{
        ifNodes->head= tempHead;
        ifNodes->tail= tempTail;
        addNodeToNodes(ifNodes,ifNode);
        }
        tempHead=NULL;
        tempTail=NULL;
        $$ = ifNodes;
    }
    | realExpe AND realExpe  {
        int realNum = count($3);

        nodes* real1 = $1;
        nodes* real2 = $3;
        node*jump = newnode();
        jump->type = 3;
        jump->relaJumpPosition += realNum+1;
        node*jump_ = newnode();
        jump->type = 3;

        

        nodes* endNodes=real1;
        addNodeToNodes(endNodes,jump);
        merge(endNodes,real2);

        $$ = endNodes;
    };

realOp : LT {_judgeType = "<";}
	| LE {_judgeType = "<=";}
	| EQ {_judgeType = "=";}
	| GT {_judgeType = ">";}
	| GE {_judgeType = ">=";}
	| NE;

%%

extern FILE *yyin; // 声明外部文件指针
int main() 
{   
    char info1[100] = "";
    char info2[100] = "";
    char info3[100] = "";

    printf("姓名\t班级\t学号\n%s\n%s\n%s\n", info1, info2, info3);

    char filename[256];

    /* FILE *original_stdout = stdout; // 保存原始的标准输出流

    freopen("NUL", "w", stdout); // 将标准输出重定向到/dev/null

    FILE *file = fopen("t3.txt", "r");
    yyin = file; // 将文件指针传递给yyin
    linkhead = newnode();
    current = linkhead;
    yyparse();
    fclose(file); // 关闭文件

    freopen("CON", "w", stdout); // 将标准输出重定向到控制台 */

    for (;;) 
    {
        printf("\n请输入测试代码文件名（包括扩展名）:\n");
        scanf("%s", filename); // 从用户输入读取文件名

        FILE *file = fopen(filename, "r"); // 打开文件
        if (file == NULL) {
            printf("无法打开文件，请确保文件存在并且拥有正确的权限。\n");
            continue;
        }
        yyin = file; // 将文件指针传递给yyin
        linkhead = newnode();
        current = linkhead;
        yyparse();
        fclose(file); // 关闭文件
        yylineno = 0; // 重置行号
    }

    return 0;
}


void yyerror(char *msg) 
{
   printf("error: %s\n\tat line %d.\n",msg, yylineno);  // 打印错误信息,行号
   iserror = 1; // 设置错误标志为1
   system("pause");
   return;
}

int yywrap()
{
    return 1;
}

