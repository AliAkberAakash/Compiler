#include<bits/stdc++.h>
#include"scopeTable.h"
#include"symbolInfo.h"

using namespace std;


#ifndef SYMBOLTABLE_H_INCLUDED
#define SYMBOLTABLE_H_INCLUDED

class idNo
{
public:
    static int id;
};
int idNo::id=0;

class symbolTable
{
    scopeTable* currentScope;


public:

    symbolTable()
    {
        currentScope=NULL;
    }
    void enterScope(int n)
    {
        //id++;
        idNo::id++;
        scopeTable* table = new scopeTable(n);
        table->setId(idNo::id);
        table->parentScope=currentScope;
        currentScope=table;
    }
    void exitScope()
    {
        //this->id--;

        scopeTable* ptr=currentScope;
        currentScope=currentScope->parentScope;
        delete ptr;
        idNo::id--;
    }

    //function to insert a symbolInfo into currentScope
    bool insertSymbol(string name, string type)
    {
        bool x=currentScope->insertItem(name,type);
//        if(x)
//        {
//            cout<<"error in if"<<endl<<endl;
//            cout<<"Inserted in ScopeTable #"<<idNo::id<<" at position ";
//            currentScope->printLocation(name);
//        }
//        else
//        {
//            cout<<"error in else"<<endl<<endl;
//            cout<<'<'<<name<<','<<type<<'>'<<" already exists in current Scope Table\n"<<endl;
//        }
        return x;
    }
    //function to delete a symbolInfo from currentScope
    bool removeSymbol(string name)
    {
        if(!currentScope->deleteItem(name))
            return false;
        else
            return true;

    }
    //function to look up a symbol from currentScope
    symbolInfo* lookUpSymbol(string name)
    {
        return currentScope->lookUp(name);
    }
    //function to print currentScope
    void printCurrentScope()
    {
        currentScope->printHashTable();
    }

    //function to print all scopeTables
    void printAllScope()
    {
        scopeTable* ptr=currentScope;

        while(ptr!=NULL)
        {
            ptr->printHashTable();
            ptr=ptr->parentScope;
        }
    }

    void printLoc(string name)
    {
        cout<<currentScope->rowLocation(name)<<","<<currentScope->columnLocation(name)<<endl;
    }

    int getId()
    {
        return currentScope->getId();
    }

};


//symbolTable::id=0;

#endif // SYMBOLTABLE_H_INCLUDED
