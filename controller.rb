require_relative 'view'
	
### Contains methods to initialize BankAccount, Deposit/Withdraw money, and view current balance
class BankAccount
	def initialize (name, balance=0)
		@name = name
		@balance = balance
	end

### Shows user's current balance
	def show_balance(pin_access)
		if pin_access == pin 
			Dialog::display_balance
		else
			puts pin_error_message
		end
	end
### Lets user withdraw money
	def do_withdraw(pin_access, amount)
		if pin_access == pin 
			@balance -= amount if @balance - amount > 0
		else
			puts pin_error_message
		end
	end
### Lets user deposit money
	def do_deposit(pin_access, amount)
		if pin_access == pin
			@balance += amount
		else
			puts pin_error_message
		end
	end


	private

	def pin
		@pin = 1234
	end
	def bank_manager
		@bank_manager = 4321
	end
	def pin_error_message
		Dialog::pin_error_message
	end
end

### The class that contains methods that make up the flow of the 
### user's view/experience. 
class BankFlow
	def new_or_old_user
		@response = Dialog::new_or_old_user
		if @response == "yes"
			Dialog::goodbye2
		elsif @response == "no"
			greeting
		else
			new_or_old_user
		end
	end

	### Asks you if you want to create and account. If you do, it creates an account for you. If you don't it mourns your rejection and says goodbye.
	def greeting
		@answer = Dialog::greeting
		if @answer == "yes"
		@user = Dialog::account_name
		@initbalance = Dialog::account_balance
		@user = BankAccount.new(@user, @initbalance)
		choice
		elsif @answer == "no"
			Dialog::goodbye
		else
			greeting
		end
	end
	
	def choice	
		### Asks what you want you want to do now that your bank account exists.
		@action = Dialog::how_can_we_help_you

		### If the balance is chosen. Show current bank account balance with BankAccount method "show_balance"
		if @action == "balance" 
			@bpin = Dialog::enter_pin
			@user.show_balance(@bpin)
			choice

		### If 'deposit' is chosen, prompt user for PIN number and deposit amount and deposit it in account using BankAccount method "deposit".
		elsif @action == "deposit" 
			@dpin = Dialog::enter_pin
			@damount = Dialog::deposit_amount
			@user.do_deposit(@dpin, @damount)
			@user.show_balance(1234)
			choice

		### If 'withdraw' is chosen, prompt user for PIN number and withdraw amount and withdraw amount using BankAccount method "withdraw".
		elsif @action == "withdraw" 
			@wpin = Dialog::enter_pin
			@wamount = Dialog::withdraw
			@user.do_withdraw(@wpin, @wamount)
			@user.show_balance(1234)
			choice

		### If 'leave' is chosen, say goodbye with BankAccount method "goodbye_cust".
		elsif @action == "leave"
			Dialog::goodbye_cust
		else
			Dialog::wrong_entry
			choice
		end
	end
end


BankFlow.new.new_or_old_user

	#
  #	# #
 # 	#  #
	#
	#
	#
#Starts Ruby Bank#







