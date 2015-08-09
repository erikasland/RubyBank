module Dialog
	### Asks if you have an account already.
	def self.new_or_old_user
		print "\nHello! Do you have a pre-existing account with us? ('yes' or 'no')\n"
		gets.chomp.downcase
	end

	### Initial greeting (first thing user should see straight after entering ruby <file> into the command line)
	def self.greeting  
		puts "\nWelcome to RubyBank, where all of your financial dreams come true."
		puts "\nWould you like to make an account? ('yes' or 'no')" 
		gets.chomp.downcase
	end

	### Says goodbye and mourns the loss of user.
	def self.goodbye 
		puts "\nThat is too bad. We are a great bank. Suit yourself! Have a nice day!\n"
	end
	### Explains that method is not yet available, check back later.
	def self.goodbye2			
		puts "\nThis is not yet a current working method in RubyBank. Check back in a few hours.\nGoodbye!\n\n"
	end

	def self.goodbye_cust # The goodbye message for a customer. 
		puts "\nHave a great day! We will look forward to your return!\n"
	end

	def self.account_name # this should be the dialog around initializing your bank account. You give your account name.	
		puts "\nplease enter your the name you wish to associate with the account."
		gets.chomp.downcase
	end

	def self.account_balance # this should be the dialog around initializing your bank account. You give your account password.	
		puts "\nplease enter the initial balance you would like to deposit into your new account."
		gets.chomp.downcase.to_i
	end

	def self.how_can_we_help_you # Dialog around asking user to enter their choice.
		puts "\nHow can we help you? (please enter 'deposit', 'withdraw', 'balance', or 'leave')"
		gets.chomp.downcase
	end

	def self.display_balance #Should be dialog around user request to check balance.
		print "\nYour current balance is: $ "
	end

	def self.withdraw #Should be dialog around user request to withdraw money from their account.
		puts "'\nPlease enter the amount you would like to withdraw."
		gets.chomp.downcase.to_i
	end
	
	def self.deposit_amount #Asks for amount you would like to deposit
		puts "\nPlease enter the ammount you would like to deposit."
		gets.chomp.downcase.to_i
	end

	def self.enter_pin  # Asks you to enter your PIN number.
		puts "\nPlease enter your PIN number."
		gets.chomp.downcase.to_i
	end

	def self.pin_error_message #Should throw an error message when user puts in incorrect password.
		puts "\nInvalid PIN number. Try again."
	end

	def self.wrong_entry #Throws error if user enters something that computer doesn't recognize.
		puts "\nI don't understand. You are mumbling. Please say 'yes' or 'no'."
	end
	### Flags a user that inputs anything aside from a Fixnum and instructs them to enter a number again.
	def self.not_fixnum_error
		puts "That was an incorrect entry. Your entry can ONLY be a number (example: 123). Restart from square one and be careful this time!"
	end

end
