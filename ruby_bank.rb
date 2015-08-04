class BankAccount
	def initialize(name, balance=0)
		@name = name
		@balance = balance
	end

	def show_balance(pin_access)
		if pin_access == pin || pin_access == bank_manager 
			puts "\nYour current balance is: $#{@balance}"
		else
			puts pin_error_message
		end
	end

	def withdraw(pin_access, amount)
		if pin_access == pin 
			@balance -= amount
			puts "'\nYou just withdrew $#{amount} from your account. \n\nYour remaining balance is: $#{@balance}\n\n"
		else
			puts pin_error_message
		end
			if @balance < 0
        @balance += amount
				return overdraft_protection
			end
	end

	def deposit(pin_access, amount)
		if pin_access == pin
			@balance += amount
			puts "\nYou just deposited $#{amount} into your account. \n\nYour remaining balance is: $#{@balance}"
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
		puts "Invalid PIN number. Try again."
	end

	def overdraft_protection
		puts "\nYou have overdrafted your account. We cannot complete your withdrawl. Please deposit money before trying again. \n\nYour corrected balance is $#{@balance}"
	end
end



