require 'sqlite3'

class Bank
	def initialize
		initialize_database
	end

	# Creates database file if it doesn't exist, sets results to be outputted as hashes, and creates tables if they don't yet exist
	def initialize_database
		@db = SQLite3::Database.new("bank.db")
		@db.results_as_hash = true
		accounts_table_exists = @db.execute("SELECT 1 FROM sqlite_master WHERE type='table' AND name= ?", "accounts").length > 0
		unless accounts_table_exists
			create_accounts_table
			create_managers_table
		end
	end

	# Creates accounts table in database file
	def create_accounts_table
		@db.execute %q{
			CREATE TABLE accounts (
		  id integer primary key,
		  name varchar(50),
		  balance float,
		  pin integer(4))
		}
	end

	# Creates managers table in database file
	def create_managers_table
		@db.execute %q{
			CREATE TABLE managers (
		  id integer primary key,
		  name varchar(50),
		  pin integer(4))
		}
	end

	# Adds a new manager
	def add_manager(name, pin)
		@db.execute("INSERT INTO managers (name,pin) VALUES (?,?)", name, pin)
	end

	# Adds new account with given name and pin, sets balance to 0
	def add_account(name, pin)
		@db.execute("INSERT INTO accounts (name,balance,pin) VALUES (?,?,?)", name, 0, pin)
	end

	# Returns true if name and pin match are found or false if not found; table parameter should be either "accounts" or "managers"
	def verify_pin(name, pin, table)
		@db.execute("SELECT 1 FROM ? WHERE name = ? AND pin = ?", table, name, pin).length > 0
	end

	# Returns balance for an account
	def balance(name, pin)
		customer = @db.execute("SELECT * FROM accounts WHERE name = ? AND pin = ?", name, pin)
		return customer[0]["balance"]
	end

# Subtracts amount from balance of an account
	def withdraw(name, pin, amount)
		@db.execute("UPDATE accounts SET balance = balance - ? WHERE name = ? AND pin = ?", amount, name, pin)
	end

# Add amount to balance of an account
	def deposit(name, pin, amount)
		@db.execute("UPDATE accounts SET balance = balance + ? WHERE name = ? AND pin = ?", amount, name, pin)
	end
end