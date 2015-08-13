module Dialog
	def self.new_or_old_user # Asks if you have an account already.
		print "\nHello! Do you have a pre-existing account with us? ('yes' or 'no'): "
		gets.chomp.downcase
	end

	def self.greeting # Initial greeting (first thing user should see straight after entering ruby <file> into the command line)
		print "\nWelcome to RubyBank, where all of your financial dreams come true."
		print "\n\nWould you like to make an account? ('yes' or 'no'): " 
		gets.chomp.downcase
	end

	def self.goodbye # Says goodbye and mourns the loss of user.
		print "\nThat is too bad. We are a great bank. Suit yourself! Have a nice day!\n\n"
	end

	def self.goodbye_cust # The goodbye message for a customer. 
		print "\nHave a great day! We will look forward to your return!\n\n"
	end

	def self.account_name # this should be the dialog around initializing your bank account. You give your account name.	
		print "\nPlease enter your the name you wish to associate with the account: "
		gets.chomp.downcase
	end

  def self.signin_name
    print "\nPlease enter your account name: "
    gets.chomp.downcase
  end

  def self.signin_pin
    print "\nPlease enter your account pin: "
    gets.chomp.downcase.to_i
  end

  def self.existing_account_error
    print "\n Our records inticate that you already have an account with us. Please sign in to your account.\n"
  end

	def self.how_can_we_help_you # Dialog around asking user to enter their choice.
		print "\nHow can we help you? Would you like to 'deposit' or 'withdraw' to/from your account, view your current 'balance', or 'end' your session?"
		print "\n\n(Please enter 'deposit', 'withdraw', 'balance', or 'end'): "
		gets.chomp.downcase 
	end

	def self.space
		print "\n\n\n"
	end

	def self.pick_your_account
		print "\n\n\nYour current account numbers are displayed above. Please enter your account number please: "
		gets.chomp.downcase.to_i
	end 

	def self.withdraw # Should be dialog around user request to withdraw money from their account.
		print "'\nPlease enter the amount you would like to withdraw."
		gets.chomp.downcase.to_i
	end
	
	def self.deposit_amount # Asks for amount you would like to deposit
		print "\nPlease enter the amount you would like to deposit: "
		gets.chomp.downcase.to_i
	end

	def self.enter_pin  # Asks you to enter your PIN number.
		print "\nPlease enter your unique PIN number: "
		gets.chomp.downcase.to_i
	end

	def self.pin_error_message # Should throw an error message when user print in incorrect password.
		print "\nInvalid PIN number. Try again."
	end

	def self.wrong_entry # Throws error if user enters something that computer doesn't recognize.
		print "\nI don't understand. You are mumbling. Please say 'yes' or 'no'."
	end

	def self.not_fixnum_error # Flags a user that inputs anything aside from a Fixnum and instructs them to enter a number again.
		print "That was an incorrect entry. Your entry can ONLY be a number (example: 123). Restart from square one and be careful this time!"
	end
end
