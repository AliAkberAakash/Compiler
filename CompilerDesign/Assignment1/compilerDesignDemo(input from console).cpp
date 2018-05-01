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

    cin>>bucket;
    table1->enterScope(bucket);

    while(cin>>s)
    {
        if(s=="I")
        {
            string name,type;
            cin>>name;
            cin>>type;
            cout<<s<<" "<<name<<" "<<type<<endl<<endl;
            table1->insertSymbol(name,type);
            //table1->printAllScope();
        }
        else if(s=="S")
        {
            cout<<s;
            table1->enterScope(bucket);
        }
        else if(s=="P")
        {
            cout<<s<<" ";
            string p;
            cin>>p;
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
            table1->exitScope();
        }
        else if(s=="D")
        {
            string del;
            cin>>del;
            cout<<s<<" "<<del<<endl<<endl;
            if(table1->lookUpSymbol(del)==NULL)
                cout<<"Not Found\n"<<endl;
            else
            {
                table1->removeSymbol(del);
            }
        }
        else if(s=="L")
        {
            string look;
            cin>>look;
            cout<<s<<" "<<look<<endl<<endl;
            if(table1->lookUpSymbol(look)==NULL)
                cout<<"Not Found\n"<<endl;
            else
            {
                cout<<"Found in ScopeTable at pos ";
                table1->printLoc(look);
            }
        }

    }

    infile.close();

    return 0;
}
