%option noyywrap

%{
#include<cstdio>
#include<cstdlib>
#include<string>
#include<vector>
#include"symbolInfo.h"

using namespace std;

int line_count=1;
int error_count=0;

FILE *logout;
FILE *tokenout;


class scopeTable
{
    static const int index=100;
    int id,n;
    symbolInfo* hashTable[index];

public:
    scopeTable* parentScope;

    void setId(int id)
    {
        this->id=id;
    }

    int getId()
    {
        return id;
    }

    //the constructor function allocates memory
    scopeTable(int n)
    {
        this->n=n;
        for(int i=0; i<n; i++)
        {
            hashTable[i] = new symbolInfo;
            hashTable[i]->setName("null");
            hashTable[i]->setType("null");
            hashTable[i]->next=NULL;
        }
    }

    //the destructor function frees the allocated memory
    ~scopeTable()
    {
        for(int i=0; i<n; i++)
        {
            symbolInfo* ptr=hashTable[i];
            symbolInfo* ptr2;
            while(ptr->next!=NULL)
            {
                ptr2=ptr;
                ptr=ptr->next;
                delete ptr2;
            }
        }
    }


//A hash function that returns a specific key index
    int hashFunction(string key)
    {

        int hashValue=0;

        for(int i=0; i<key.size(); i++)
        {
            hashValue+= (int)key[i];
        }
        return hashValue%n;
    }

//Function to search a key
    symbolInfo* lookUp(string name)
    {
        int bucket=hashFunction(name);
        symbolInfo* ptr=hashTable[bucket];
        symbolInfo* retPtr=NULL;
        bool found = false;

        while(ptr!=NULL)
            {
                if(ptr->getName()==name)
                {
                    //cout<<"No error here"<<endl<<endl;
                    retPtr=ptr;
                    break;
                }
                ptr=ptr->next;
            }

        return retPtr;

    }

//Function to insert a new entry
    bool insertItem(string name, string type)
    {
        if(lookUp(name)!= NULL)
        {
           
            return false;
        }
        else
        {
            
            int index=hashFunction(name);
            symbolInfo* ptr = new symbolInfo();

            ptr->setName(name);
            ptr->setType(type);
            ptr->next=NULL;

            if(hashTable[index]->getName() == "null")
            {
                hashTable[index]->setName(name);
                hashTable[index]->setType(type);
            }
            else
            {
                symbolInfo* ptr2=hashTable[index];

                while(ptr2->next!=NULL)
                {
                    ptr2=ptr2->next;
                }
                ptr2->next=ptr;
            }
            return true;
        }
    }

//Function to delete an item
    bool deleteItem(string name)
    {
        symbolInfo* ptr1;
        symbolInfo* ptr2;
        symbolInfo* dltPtr;

        if(lookUp(name)==NULL)
            return false;
        else
        {

            int index=hashFunction(name);

            if(hashTable[index]->getName() == name && hashTable[index]->next==NULL)
            {
                hashTable[index]->setName("null");
                hashTable[index]->setType("null");
                return true;
            }
            else if(hashTable[index]->getName() == name)
            {
                dltPtr=hashTable[index];
                hashTable[index]=hashTable[index]->next;
                delete dltPtr;
                return true;
            }
            else
            {
                ptr1=hashTable[index]->next;
                ptr2=hashTable[index];

                while(ptr1!=NULL && ptr1->getName()!=name)
                {
                    ptr2=ptr1;
                    ptr1=ptr1->next;
                }
                if(ptr1->getName()==name)
                {
                    dltPtr=ptr1;
                    ptr1=ptr1->next;
                    ptr2->next=ptr1;
                    delete dltPtr;
                    return true;
                }

            }
        }
    }

//Function to print the hash table
    void printHashTable()
    {
        for(int i=0; i<n; i++)
        {
            
            symbolInfo*  ptr=hashTable[i];

            while(ptr != NULL)
            {
                if(ptr->getName()!="null")
                {
                    fprintf(logout,"%d--> <%s:%s>\n",i,ptr->getName().c_str(),ptr->getType().c_str());
                }   
                ptr=ptr->next;
            }
            
        }
        
    }

    //function to find the row of an item
    int rowLocation(string name)
    {
        int s=0;
        int x=hashFunction(name);
        symbolInfo* ptr=hashTable[x];

        while(ptr!=NULL)
        {
            if(ptr->getName()==name)
                return s;
            else
            {
                s++;
                ptr=ptr->next;
            }
        }
        return s;
    }

    //function to print the location of an item
    int  columnLocation(string name)
    {
        if(lookUp(name)==NULL)
            return -1;
        else
            return hashFunction(name);
    }

};


scopeTable* st=new scopeTable(10);

%}

WHITESPACE [ \t\f\r\v]+ 
LETTER [a-zA-Z]
DIGIT [0-9]
NEWLINE \n
CHARACTER "'"[.]-[\t\\\"\a\f\r\b\v\0]"'"
IDENTIFIER [a-zA-Z][_a-zA-Z0-9]*
STRING [.]*
COMMENT "/*"(.|\n)*"*/"
ERRDOUBLE [0-9]*"."[0-9]*"."[0-9]
ERRDOUBLETWO [0-9]+"E"[0-9]+"."[0-9]*


%%

{NEWLINE} {line_count++;}

"if"	{
			fprintf(tokenout,"<IF>");
			fprintf(logout,"Line no %d: TOKEN <IF> Lexeme %s found\n",line_count,yytext);
		}
		
"else"	{
			fprintf(tokenout,"<ELSE>");
			fprintf(logout,"Line no %d: TOKEN <ELSE> Lexeme %s found\n",line_count,yytext);
		}

"for"	{
			fprintf(tokenout,"<FOR>");
			fprintf(logout,"Line no %d: TOKEN <FOR> Lexeme %s found\n",line_count,yytext);
		}

"while"	{
			fprintf(tokenout,"<WHILE>");
			fprintf(logout,"Line no %d: TOKEN <WHILE> Lexeme %s found\n",line_count,yytext);
		}

"do"	{
			fprintf(tokenout,"<DO>");
			fprintf(logout,"Line no %d: TOKEN <DO> Lexeme %s found\n",line_count,yytext);
		}

"break"	{
			fprintf(tokenout,"<BREAK>");
			fprintf(logout,"Line no %d: TOKEN <BREAK> Lexeme %s found\n",line_count,yytext);
		}

"int"	{
			fprintf(tokenout,"<INT>");
			fprintf(logout,"Line no %d: TOKEN <INT> Lexeme %s found\n",line_count,yytext);
		}

"char"	{
			fprintf(tokenout,"<CHAR>");
			fprintf(logout,"Line no %d: TOKEN <CHAR> Lexeme %s found\n",line_count,yytext);
		}

"FLOAT"	{
			fprintf(tokenout,"<FLOAT>");
			fprintf(logout,"Line no %d: TOKEN <FLOAT> Lexeme %s found\n",line_count,yytext);
		}

"double"	{
			fprintf(tokenout,"<DOUBLE>");
			fprintf(logout,"Line no %d: TOKEN <DOUBLE> Lexeme %s found\n",line_count,yytext);
		}

"void"	{
			fprintf(tokenout,"<VOID>");
			fprintf(logout,"Line no %d: TOKEN <VOID> Lexeme %s found\n",line_count,yytext);
		}

"return"	{
			fprintf(tokenout,"<RETURN>");
			fprintf(logout,"Line no %d: TOKEN <RETURN> Lexeme %s found\n",line_count,yytext);
		}

"switch"	{
			fprintf(tokenout,"<SWITCH>");
			fprintf(logout,"Line no %d: TOKEN <SWITCH> Lexeme %s found\n",line_count,yytext);
		}

"case"	{
			fprintf(tokenout,"<CASE>");
			fprintf(logout,"Line no %d: TOKEN <CASE> Lexeme %s found\n",line_count,yytext);
		}

"default"	{
			fprintf(tokenout,"<DEFAULT>");
			fprintf(logout,"Line no %d: TOKEN <DEFAULT> Lexeme %s found\n",line_count,yytext);
		}

"continue"	{
			fprintf(tokenout,"<CONTINUE>");
			fprintf(logout,"Line no %d: TOKEN <CONTINUE> Lexeme %s found\n",line_count,yytext);
		}

"+"		|

"-"		{
			fprintf(tokenout,"<ADDOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <ADDOP> Lexeme %s found\n",line_count,yytext);
			
		}

"*"		|
"/"     |
"%"		{
			fprintf(tokenout,"<MULOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <MULOP> Lexeme %s found\n",line_count,yytext);

		}

"++"	|
"--"		{
			fprintf(tokenout,"<INCOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <INCOP> Lexeme %s found\n",line_count,yytext);

		}

"<"		 |
"<="     |
"=="     |
">="     |
">"      |
"!="	{
			fprintf(tokenout,"<RELOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <RELOP> Lexeme %s found\n",line_count,yytext);

		}

"="		{
			fprintf(tokenout,"<ASSIGNOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <ASSIGNOP> Lexeme %s found\n",line_count,yytext);

		}

"&&"     |
"||"		{
			fprintf(tokenout,"<LOGICOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <LOGICOP> Lexeme %s found\n",line_count,yytext);

		}

"!"		|
"&"     |
"|"     |
">>"    |
"<<"    |
"^"		{
			fprintf(tokenout,"<BITOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <BITOP> Lexeme %s found\n",line_count,yytext);

		}

"("		{
			fprintf(tokenout,"<LPAREN,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <LPAREN> Lexeme %s found\n",line_count,yytext);
		}

")"		{
			fprintf(tokenout,"<RPAREN,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <RPAREN> Lexeme %s found\n",line_count,yytext);
		}

"{"		{
			fprintf(tokenout,"<LCURL,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <LCURL> Lexeme %s found\n",line_count,yytext);
		}

"}"		{
			fprintf(tokenout,"<RCURL,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <RCURL> Lexeme %s found\n",line_count,yytext);

		}

"["		{
			fprintf(tokenout,"<LTHIRD,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <LTHIRD> Lexeme %s found\n",line_count,yytext);

		}

"]"		{
			fprintf(tokenout,"<RTHIRD,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <RTHIRD> Lexeme %s found\n",line_count,yytext);

		}

","		{
			fprintf(tokenout,"<COMMA,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <COMMA> Lexeme %s found\n",line_count,yytext);

		}

";"		{
			fprintf(tokenout,"<SEMICOLON,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <SEMICOLON> Lexeme %s found\n",line_count,yytext);

		}

{DIGIT}+ 	{
				fprintf(tokenout,"<CONST_INT,%s>",yytext);
				fprintf(logout,"Line no %d: TOKEN <CONST_INT> Lexeme %s found\n",line_count,yytext);
				st->insertItem(string(yytext),"CONST_INT");
                st->printHashTable();
			}

{DIGIT}+"."{DIGIT}*  |
{DIGIT}+"E"{DIGIT}+    {
				fprintf(tokenout,"<CONST_FLOAT,%s>",yytext);
				fprintf(logout,"Line no %d: TOKEN <CONST_FLOAT> Lexeme %s found\n",line_count,yytext);
				st->insertItem(string(yytext),"CONST_FLOAT");
                st->printHashTable();
			}

{CHARACTER}       {
                    string str="\0";
                   if(strlen(yytext)==3)
                       {str+=yytext[1];
				fprintf(tokenout,"<CONST_CHAR,%s>",str.c_str());
				fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n",line_count,str.c_str());
				st->insertItem(string(yytext),"CONST_CHAR");
                st->printHashTable();
                    }
                    else
                        {
fprintf(logout,"Syntax error in line %d\n",line_count);
                error_count++;
}
			}
{IDENTIFIER}        {
				fprintf(tokenout,"<ID,%s>",yytext);
				fprintf(logout,"Line no %d: TOKEN <ID> Lexeme %s found\n",line_count,yytext);
				st->insertItem(string(yytext),"ID");
                st->printHashTable();
			}

{STRING}        {
				fprintf(tokenout,"<STRING,%s>",yytext);
				fprintf(logout,"Line no %d: TOKEN <STRING> Lexeme %s found\n",line_count,yytext);
				st->insertItem(string(yytext),"STRING");
                st->printHashTable();
			}
{COMMENT}       {
				fprintf(logout,"Line no %d: TOKEN <COMMENT> Lexeme %s found\n",line_count,yytext);

			}

{WHITESPACE}        { /*does nothing*/ }

{ERRDOUBLE}     {
        fprintf(logout,"Error in line %d\n", line_count);
        error_count++;
}

{ERRDOUBLETWO}     {
        fprintf(logout,"Error in line %d\n", line_count);
        error_count++;
}

.-[_a-zA-Z]{IDENTIFIER}         {
        fprintf(logout,"Illegal Identifier name in line no %d\n", line_count);
        error_count++;
}

. {
    fprintf(logout,"Unrecognised Symbol");
        error_count++;
  }


%%

int main(int argc,char *argv[]){
	
	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
	
	logout= fopen("log.txt","w");
	tokenout= fopen("token.txt","w");

    fprintf(logout, "Total Errors :%d", error_count);
	yyin= fin;
	yylex();
	//st->printHashTable();
	fclose(yyin);
	fclose(tokenout);
	fclose(logout);
	return 0;
}
