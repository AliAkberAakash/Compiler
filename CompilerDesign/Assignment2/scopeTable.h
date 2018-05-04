#include<bits/stdc++.h>
#include"symbolInfo.h"

using namespace std;

#ifndef SCOPETABLE_H_INCLUDED
#define SCOPETABLE_H_INCLUDED

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

//    symbolInfo* lookUp(string name)
//    {
//        symbolInfo* ptr=NULL;
//        return ptr;
//    }

//Function to insert a new entry
    bool insertItem(string name, string type)
    {
        if(lookUp(name)!= NULL)
        {
            //cout<<"error in if"<<endl<<endl;
            return false;
        }
        else
        {
            //cout<<"error in else"<<endl<<endl;
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
//            cout<<"Deleted entry from current ScopeTable at position ";
//            printLocation(name);
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
        cout<<"Scope Table #"<<id<<endl;
        for(int i=0; i<n; i++)
        {
            cout<<i<<"--> ";
            symbolInfo*  ptr=hashTable[i];

            while(ptr != NULL)
            {
                if(ptr->getName()!="null")
                    cout<<"< "<<ptr->getName()<<" : "<<ptr->getType()<<" > ";
                ptr=ptr->next;
            }
            cout<<endl;
        }
        cout<<endl;
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

#endif // SCOPETABLE_H_INCLUDED
