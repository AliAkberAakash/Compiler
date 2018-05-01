#include<bits/stdc++.h>

using namespace std;

#ifndef SYMBOLINFO_H_INCLUDED
#define SYMBOLINFO_H_INCLUDED

class symbolInfo
{
    string name, type;

public:
    symbolInfo* next;

    symbolInfo()
    {
        next=NULL;
    }

//Function to set the name
    void setName(string name)
    {
        this->name=name;
    }
//Function to set the type
    void setType(string type)
    {
        this->type=type;
    }

//function to get the name
    string getName()
    {
        return name;
    }

//function to get the type
    string getType()
    {
        return type;
    }

};



#endif // SYMBOLINFO_H_INCLUDED
