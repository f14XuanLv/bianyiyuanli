#include <stdio.h>
#include <malloc.h>
#include <string.h> 
#include <stdlib.h>

typedef struct node {
    int type;//四元式的类型:program,赋值，jump，judgejump，加减乘除，sys

    //类型1：属性：程序名
    char* programName;

    //类型2：赋值
    int assignType;//声明类型，是值声明还是字符声明
    char* variaName;//赋值给的变量名
    int value1;//赋值的值
    char* value2;//赋值的字符串值

    //类型3：跳至
    int relaJumpPosition;//跳到的相对位置

    //类型4：判断跳至
    char* judgeType;//判断的类型（等于，大于，小于，大于等于，小于等于
    int relaJudgeJumpPosition;//跳到的相对位置
    char judgeLeft[10];
    char judgeRight[10];

    //类型5：加减乘除
    char* aloType;//加减乘除
    char left[10];//左操作数
    char right[10];//右操作数
    char res[10];//赋值给

    //类型6：sys
    struct node* next;//下一个node

}node;

typedef struct nodes {
    node* head;
    node* tail;
}nodes;



void addNodeToNodes(nodes*target,node* source){
    if(target->head==NULL){target->head=source;target->tail=source;}
    else {target->tail->next=source;target->tail=source;}
}

void merge(nodes*nodesFirst,nodes*nodesLast){
    nodesFirst->tail->next=nodesLast->head;
    nodesFirst->tail=nodesLast->tail;
}

void remerge(nodes*nodesFirst,nodes*nodesLast){
    nodesFirst->tail->next=nodesLast->head;
    nodesFirst->tail=nodesLast->tail;
}

node* newnode()
{
node* p=(node*)malloc((sizeof(node)));
p->relaJudgeJumpPosition=0;
p->relaJumpPosition=0;  //初始化
return p;
}

nodes* newnodes()
{
nodes* p=(nodes*)malloc((sizeof(nodes)));
return p;
}


node* addNode(node* tail,node* nodeNeeded){
    tail->next=nodeNeeded;
    return tail->next;
}

//计算nodes的长度
int count(nodes* nodes){
    node* head = nodes->head;
    node* tail = nodes->tail;
    int temp = 1;
    while(head != tail){
        head = head->next;
        temp++;

    }
    return temp;
}

void print(node* thisNode,int nowNumber){

    //输出四元式

    if(thisNode->type == 1)printf("(program,%s,-,-)",thisNode->programName);

    else if(thisNode->type == 2&&thisNode->assignType==1)printf("(:=,%d,-,%s)",thisNode->value1,thisNode->variaName);

    else if(thisNode->type == 2&&thisNode->assignType==2)printf("(:=,%s,-,%s)",thisNode->value2,thisNode->variaName);

    else if(thisNode->type == 3)printf("(j,-,-,%d)",thisNode->relaJumpPosition+nowNumber);

    else if(thisNode->type == 4)printf("(j%s,%s,%s,%d)",thisNode->judgeType,thisNode->judgeLeft,thisNode->judgeRight,thisNode->relaJudgeJumpPosition+nowNumber);
    
    else if(thisNode->type == 5)printf("(%s,%s,%s,%s)",thisNode->aloType,thisNode->left,thisNode->right,thisNode->res);

    else if(thisNode->type == 6)printf("(sys,-,-,-)");

    else {printf("not Found %d",thisNode->type);}

    printf("\n");
}

//输出nodes的所有四元式,弃用
void printAll(node *head,node* tail)
{
    node* curr = head;
    int number = 0;
    while(1){
        printf("(%d)",number);
        print(curr,number);
        number++;
        if(curr == tail)break;
        curr=curr->next;
    }
}

void printAllofNodes(nodes* Nodes)
{
    node* curr = Nodes->head;
    int number = 0;
    while(1){
        printf("(%d)",number);
        print(curr,number);
        number++;
        if(curr == Nodes->tail)break;
        curr=curr->next;
    }
}

//字符串拼接函数
char* join(char *s1, char *s2)
{
    char *result = malloc(strlen(s1)+strlen(s2)+1);
    if (result == NULL) exit (1);

    strcpy(result, s1);
    strcat(result, s2);

    return result;
}

