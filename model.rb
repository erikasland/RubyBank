require 'sqlite3'

class Bank
	attr_accessor :db

	def initialize
		initialize_database
	end

	# Creates database file if it doesn't exist, sets results to be outputted as hashes, turns on foreign key support, and creates tables if they don't yet exist
	def initialize_database
		@db = SQLite3::Database.new("bank.db")
		db.results_as_hash = true
		db.execute("PRAGMA foreign_keys = ON")
		accounts_table_exists = db.execute("SELECT 1 FROM sqlite_master WHERE type='table' AND name= ?", "accounts").length > 0
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
		  customer_id integer references customers(customer_id) ON UPDATE CASCADE ON DELETE CASCADE,
		  name varchar(50),
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

	# Adds a new customer to database
	def add_customer(name, pin)
		db.execute("INSERT INTO customers (name,pin) VALUES (?.?)", name, pin)
	end

	# Adds new account under given customer_id, sets balance to 0
	def add_account(customer_id)
		db.execute("INSERT INTO accounts (customer_id,balance) VALUES (?,?)", customer_id, 0)
	end

	# Returns true if name and pin match are found or false if not found; table parameter should be either "accounts" or "managers"
	def verify_pin(name, pin, table)
		db.execute("SELECT 1 FROM #{table} WHERE name = ? AND pin = ?", name, pin).length > 0
	end

	# Returns list of all bank accounts as an array of hashes. Requires manager name and pin match to be true
	def account_list(name, pin)
		list = db.execute("SELECT * FROM accounts")
		return list if verify_pin(name, pin, "managers")
	end
end

class Customer
	attr_accessor :db, :name, :pin, :balance

	def initialize(db, name, pin)
		@db = db
		@name = name
		@pin = pin
		@balance = 0
	end

	def save_to_db
		#
	end
end

class Account
	attr_accessor :db, :customer_id

	def initialize(customer_id, db)
		@customer_id = customer_id
		@db = db
	end

	# Returns balance for an account
	def balance(name, pin)
		customer = db.execute("SELECT * FROM accounts WHERE name = ? AND pin = ?", name, pin)
		return customer[0]["balance"]
	end

	# Subtracts amount from balance of an account
	def withdraw(name, pin, amount)
		db.execute("UPDATE accounts SET balance = balance - ? WHERE name = ? AND pin = ?", amount, name, pin)
	end

	# Add amount to balance of an account
	def deposit(name, pin, amount)
		db.execute("UPDATE accounts SET balance = balance + ? WHERE name = ? AND pin = ?", amount, name, pin)
	end
end