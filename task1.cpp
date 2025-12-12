#include <iostream>
#include <string>
#include <iomanip>

using namespace std;

class BankAccount {
protected:
    string accountNumber;
    string ownerName;
    double balance;

public:
    BankAccount(string accNum, string name, double initialBalance = 0.0)
        : accountNumber(accNum), ownerName(name), balance(initialBalance) {
        cout << "Bank account created for " << name << endl;
    }

    virtual void deposit(double amount) {
        if (amount > 0) {
            balance += amount;
            cout << "Deposited: " << amount << " RUB" << endl;
        } else {
            cout << "Invalid deposit amount!" << endl;
        }
    }

    virtual bool withdraw(double amount) {
        if (amount > 0 && amount <= balance) {
            balance -= amount;
            cout << "Withdrawn: " << amount << " RUB" << endl;
            return true;
        } else {
            cout << "Withdrawal failed!" << endl;
            return false;
        }
    }

    virtual void displayInfo() const {
        cout << "\n=== Account Info ===" << endl;
        cout << "Account: " << accountNumber << endl;
        cout << "Owner: " << ownerName << endl;
        cout << "Balance: " << fixed << setprecision(2) << balance << " RUB" << endl;
    }

    virtual ~BankAccount() {}
};

class SavingsAccount : public BankAccount {
private:
    double interestRate;

public:
    SavingsAccount(string accNum, string name, double initialBalance = 0.0, double rate = 0.0)
        : BankAccount(accNum, name, initialBalance), interestRate(rate) {
        cout << "Savings account with " << rate << "% interest" << endl;
    }

    void applyInterest() {
        if (interestRate > 0 && balance > 0) {
            double interest = balance * (interestRate / 100.0);
            balance += interest;
            cout << "Interest applied: " << interest << " RUB at " << interestRate << "%" << endl;
        }
    }

    void displayInfo() const override {
        BankAccount::displayInfo();
        cout << "Interest rate: " << interestRate << "%" << endl;
        cout << "Account type: Savings" << endl;
    }
};

int main() {
    cout << "=== BANK ACCOUNT DEMO ===" << endl;

    BankAccount account1("ACC001", "John Smith", 1000.0);
    account1.displayInfo();
    
    account1.deposit(500.0);
    account1.withdraw(200.0);
    account1.withdraw(1500.0); 
    
    cout << "\nFinal state:";
    account1.displayInfo();

    cout << "\n" << string(40, '-') << "\n" << endl;

    SavingsAccount account2("ACC002", "Emma Johnson", 5000.0, 5.0);
    account2.displayInfo();
    
    account2.deposit(1000.0);
    account2.withdraw(500.0);
    account2.applyInterest();
    
    cout << "\nFinal state:";
    account2.displayInfo();

    cout << "\n=== DEMO COMPLETED ===" << endl;
    
    return 0;
}