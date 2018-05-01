#include<bits/stdc++.h>
#include"scopeTable.h"
#include"symbolInfo.h"
#include"symbolTable.h"

using namespace std;

int main()
{
    ifstream infile;
    infile.open("input2.txt");
    symbolTable* table1=new symbolTable();
    string s;
    int bucket;

    if(!infile)
    {
        cerr<<"Could not open the file!!!\n"<<endl;
        exit(1);
    }

    infile>>bucket;
    table1->enterScope(bucket);

    while(infile>>s)
    {
        if(s=="I")
        {
            string name,type;
            infile>>name;
            infile>>type;
            cout<<s<<" "<<name<<" "<<type<<endl<<endl;
            int x=table1->insertSymbol(name,type);
            if(x)
            {
                cout<<"Inserted in ScopeTable #"<<table1->getId()<<" at position ";
                table1->printLoc(name);
                cout<<endl;
            }
            else
            {
                cout<<'<'<<name<<','<<type<<'>'<<" already exists in current Scope Table\n"<<endl;
            }
        }
        else if(s=="S")
        {
            cout<<s<<endl<<endl;
            table1->enterScope(bucket);
            printf("New Scope Table with Id #%d created\n\n", table1->getId());
        }
        else if(s=="P")
        {
            cout<<s<<" ";
            string p;
            infile>>p;
            cout<<p<<endl<<endl;
            if(p=="A")
            {
                table1->printAllScope();
            }
            else if(p=="C")
            {
                table1->printCurrentScope();
            }
        }
        else if(s=="E")
        {
            cout<<s<<endl<<endl;
            printf("ScopeTable with id #%d removed\n\n", table1->getId());
            table1->exitScope();
        }
        else if(s=="D")
        {
            string del;
            infile>>del;
            cout<<s<<" "<<del<<endl<<endl;
            if(table1->lookUpSymbol(del)==NULL)
                cout<<"Not Found\n"<<endl;
            else
            {
                cout<<"Deleted entry at ";
                table1->printLoc(del);
                cout<<endl;
                table1->removeSymbol(del);
            }
        }
        else if(s=="L")
        {
            string look;
            infile>>look;
            cout<<s<<" "<<look<<endl<<endl;
            if(table1->lookUpSymbol(look)==NULL)
                cout<<"Not Found\n"<<endl;
            else
            {
                cout<<"Found in ScopeTable at pos ";
                table1->printLoc(look);
                cout<<endl;
            }
        }

    }

    return 0;
}
