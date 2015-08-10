require 'sqlite3'

class Bank
	attr_accessor :db

	def initialize
		initialize_database
	end

	# Creates database file if it doesn't exist, sets results to be outputted as
	# hashes, turns on foreign key support, and creates tables if they don't exist
	def initialize_database
		@db = SQLite3::Database.new("bank.db")
		db.results_as_hash = true
		db.execute("PRAGMA foreign_keys = ON")
		accounts_table_exists = db.execute("SELECT 1 FROM sqlite_master WHERE 
			type='table' AND name= ?", "accounts").length > 0
		unless accounts_table_exists
			create_customers_table
			create_accounts_table
			create_managers_table
		end
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
		db.execute("SELECT 1 FROM #{table} WHERE name = ? AND pin = ?", 
			name, pin).length > 0
	end

	# Returns list of all bank accounts as an array of hashes. Requires manager 
	# name and pin match to be true
	def account_list(name, pin)
		list = db.execute("SELECT * FROM accounts")
		return list if verify_pin(name, pin, "managers")
	end

	# Returns true if name exists in given table; table parameter should be either
	# "customers" or "managers"
	def name_exists?(name, table)
		db.execute("SELECT 1 FROM #{table} WHERE name = ?", 
			name).length > 0
	end

	# Returns customer_id of customer found with name and pin
	def find_customer_id(name, pin)
		customer = db.execute("SELECT * FROM customers WHERE name = ? AND pin = ?", 
			name, pin)
		return customer[0]["customer_id"]
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

	# Returns Customer instance with customer from database
	def load_customer(customer_id)
		customer = find_customer_by_customer_id(customer_id)
		Customer.new(db, customer[0]["name"], customer[0]["pin"])
	end

	# Returns Account instance with account from database
	def load_account(account_id)
		account = db.execute("SELECT * FROM accounts WHERE account_id = ?",
			account_id)
		Account.new(db, account[0]["customer_id"], false)
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
		db.execute("INSERT INTO customers (name,pin) VALUES (?,?)", name, pin)
	end
end

class Account
	attr_accessor :db, :balance, :new_account, :customer_id

	def initialize(db, customer_id, new_account = true)
		@customer_id = customer_id
		@balance = 0.0
		@db = db
		@new_account = new_account
	end

	# Subtracts amount from balance of account
	def withdraw(name, pin, amount)
		balance -= amount
	end

	# Add amount to balance of account
	def deposit(name, pin, amount)
		balance += amount
	end

	# Returns balance for an account
	def return_balance(customer_id)
		customer = db.execute("SELECT * FROM accounts WHERE customer_id = ?", 
			customer_id)
		return customer[0]["balance"]
	end

	# Either adds or updates database
	def save_to_db
		if new_account
			db.execute("INSERT INTO accounts (customer_id,balance) VALUES (?,?)", 
				customer_id, balance)
		else
			db.execute("UPDATE accounts SET balance = #{balance} WHERE customer_id = 
				?", customer_id)
		end
	end
end


# Testing stuff.....

# bank = Bank.new
# bank.add_customer("Bob", 1234)
# cust_id = bank.find_customer_id("Bob", 1234)
# 	puts cust_id
# bank.add_account(cust_id)
# acc = Account.new(cust_id, bank.db)
# acc.balance = 500
# 	puts acc.balance
# acc.save_to_db
# 	puts acc.return_balance(cust_id)
# bank.add_manager("Joe the plumber", 1234)
# puts bank.account_list("Joe the plumber",1234).count