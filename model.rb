require 'sqlite3'

class Bank
  attr_accessor :db

  def initialize
    initialize_database
  end

  # Creates database file if it doesn't exist, sets results to be outputted as
  # hashes, turns on foreign key support, creates tables if they don't exist,
  # and adds initial manager if none exist
  def initialize_database
    @db = SQLite3::Database.new("bank.db")
    db.results_as_hash = true
    db.execute("PRAGMA foreign_keys = ON")
    accounts_table_exists = db.execute("SELECT 1 FROM sqlite_master WHERE 
      type='table' AND name= ?", "accounts").length > 0
    managers_exist = db.execute("SELECT 1 FROM sqlite_master WHERE 
      type='table' AND name= ?", "managers").length > 0
    unless accounts_table_exists
      create_customers_table
      create_accounts_table
      create_managers_table
    end
    add_manager("admin", 1111) if !managers_exist
  end

  # Creates accounts table in database file
  def create_accounts_table
    db.execute %q{
      CREATE TABLE accounts (
      account_id integer primary key,
      customer_id integer references customers(customer_id) ON UPDATE CASCADE ON
       DELETE CASCADE,
      balance float)
    }
  end

  # Creates customers table in database file
  def create_customers_table
    db.execute %q{
      CREATE TABLE customers (
      customer_id integer primary key,
      name varchar(50),
      pin integer(4))
    }
  end

  # Creates managers table in database file
  def create_managers_table
    db.execute %q{
      CREATE TABLE managers (
      id integer primary key,
      name varchar(50),
      pin integer(4))
    }
  end

  # Adds a new manager to database
  def add_manager(name, pin)
    db.execute("INSERT INTO managers (name,pin) VALUES (?,?)", name, pin)
  end

  # Returns true if name and pin match are found or false if not found; table 
  # parameter should be either "customers" or "managers"
  def verify_pin(name, pin, table)
    db.execute("SELECT 1 FROM #{table} WHERE LOWER(name) = ? AND pin = ?", 
      name.downcase, pin).length > 0
  end

  # Returns list of all bank accounts as an array of hashes. Requires manager 
  # name and pin match to be true
  def account_list(name, pin)
    list = db.execute("SELECT * FROM accounts")
    return list if verify_pin(name, pin, "managers")
  end

  # Transfers "amount" of money from the "sender" account to "receiver" account
  def money_transfer(sender_account_id, receiver_account_id, amount)
    db.execute("UPDATE accounts SET balance = (balance - #{amount}) WHERE 
      account_id = ?", sender_account_id)
    db.execute("UPDATE accounts SET balance = (balance + #{amount}) WHERE 
      account_id = ?", receiver_account_id)
  end

  # Returns true if name exists in given table; table parameter should be either
  # "customers" or "managers"
  def name_exists?(name, table)
    db.execute("SELECT 1 FROM #{table} WHERE LOWER(name) = ?", 
      name.downcase).length > 0
  end

  # Returns true if acount_id exists
  def account_exists?(account_id)
    db.execute("SELECT 1 FROM accounts WHERE account_id = ?", 
      account_id).length > 0
  end

  # Returns customer_id of customer found with name and pin
  def find_customer_id(name, pin)
    customer = db.execute("SELECT * FROM customers WHERE LOWER(name) = ? AND pin = ?", name.downcase, pin)
    customer[0]["customer_id"]
  end

  # Returns customer_id of manager found with name and pin
  def find_manager_id(name, pin)
    manager = db.execute("SELECT * FROM managers WHERE LOWER(name) = ? AND pin = ?", name.downcase, pin)
    manager[0]["id"]
  end

  # Returns accounts for customer
  def customer_accounts(name, pin)
    db.execute("SELECT * FROM accounts WHERE customer_id = ?", find_customer_id(
      name, pin))
  end

  # Returns customer found with given customer_id
  def find_customer_by_customer_id(customer_id)
    db.execute("SELECT * FROM customers WHERE customer_id = ?",
      customer_id)
  end

  # Returns manager found with given id
  def find_manager_by_id(id)
    db.execute("SELECT * FROM managers WHERE id = ?", id)
  end

  # Returns balance for an account
  def return_balance(account_id)
    account = db.execute("SELECT * FROM accounts WHERE account_id = ?", 
      account_id)
    return account[0]["balance"]
  end

  # Returns Customer instance with customer from database
  def load_customer(customer_id)
    customer = find_customer_by_customer_id(customer_id)
    Customer.new(db, customer[0]["name"], customer[0]["pin"])
  end

  # Returns Account instance with account from database
  def load_account(account_id)
    account = db.execute("SELECT * FROM accounts WHERE account_id = ?",
      account_id)
    new_instance = Account.new(db, account[0]["customer_id"], account_id)
    new_instance.balance = account[0]["balance"]
    new_instance
  end

  # Returns Account instance with account from database
  def load_manager(id)
    manager = find_manager_by_id(id)
    Manager.new(db, manager[0]["name"], manager[0]["pin"])
  end

  # Creates new account for given customer_id
  def create_account(customer_id)
   db.execute("INSERT INTO accounts (customer_id,balance) VALUES (?,?)", 
      customer_id, 0)
  end
end

class Customer
  attr_accessor :db, :name, :pin

  def initialize(db, name, pin)
    @db = db 
    @name = name
    @pin = pin
  end       
  
  def add_to_db
    db.execute("INSERT INTO #{self.class.name.downcase + "s"} (name,pin) VALUES
      (?,?)", name, pin)
  end
end

class Manager < Customer
end

class Account
  attr_accessor :db, :balance, :new_account, :customer_id, :account_id

  def initialize(db, customer_id, account_id)
    @customer_id = customer_id
    @balance = 0.0
    @db = db
    @new_account = new_account
    @account_id = account_id
  end

  # Subtracts amount from balance of account
  def withdraw(amount)
    @balance -= amount
  end

  # Add amount to balance of account
  def deposit(amount)
    @balance += amount
  end

  # Either adds or updates database
  def save_to_db
    db.execute("UPDATE accounts SET balance = #{balance} WHERE account_id = 
      ?", account_id)
  end
end