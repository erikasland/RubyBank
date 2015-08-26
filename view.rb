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
    gets.chomp
  end

  def self.account_pin # this should be the dialog around initializing your bank account. You give your account name.  
    print "\nPlease enter the pin you wish to associate with the account: "
    gets.chomp
  end

  def self.signin_name
    print "\nPlease enter your account name: "
    gets.chomp
  end

  def self.signin_pin
    print "\nPlease enter your account pin: "
    gets.chomp.to_i
  end

  def self.existing_account_error
    print "\n Our records inticate that you already have an account with us. Please sign in to your account.\n"
  end

  def self.how_can_we_help_you # Dialog asking user to enter their choice.
    print "\nHow can we help you? Would you like to 'deposit' or 'withdraw' to/from your account, view your current 'balance', create a 'new account' or 'end' your session?"
    print "\n\n(Please enter 'new account', 'deposit', 'withdraw', 'balance', or 'end'): "
    gets.chomp.downcase 
  end

  def self.how_can_we_help_you_man # Dialog asking user to enter their choice.
    print "\nWould you like to 'transfer' money between accounts, deposit' or 'withdraw' to/from their account, view your current 'balance', create a 'new account' or 'end' your session?"
    print "\n\n(Please enter 'new account', 'deposit', 'withdraw', 'balance', or 'end'): "
    gets.chomp.downcase 
  end

  def self.space
    print "\n"
  end

  def self.account_prompt
    print "Your total accounts: " 
  end

  def self.pick_your_account
    print "\n\n\nYour list of accounts is displayed above. Please select an " +
    "account by entering its account number: "
    gets.chomp.to_i
  end 

  def self.deposit_amount # Asks for amount you would like to deposit
    print "\nPlease enter the amount you would like to deposit: $"
    gets.chomp.to_f
  end

  def self.withdraw_amount # Asks for amount you would like to withdraw
    print "\nPlease enter the amount you would like to withdraw: $"
    gets.chomp.to_f
  end

  def self.enter_pin  # Asks you to enter your PIN number.
    print "\nPlease enter your unique PIN number: "
    gets.chomp.to_i
  end

  def self.pin_error_message # Should throw an error message when user print in incorrect password.
    print "\nInvalid PIN number. Try again."
  end

  def self.wrong_entry # Throws error if user enters something that computer doesn't recognize.
    print "\nI don't understand. You are mumbling. Please say 'yes' or 'no'.\n"
  end

  def self.wrong_username_or_pin
    print "\nYou have either entered an incorrect name or PIN. Please try again"
    print ",\n"
  end

  def self.incorrect_entry
    print "\nIncorrect entry.\n"
  end

  def self.fixnum_error
    print "\nIncorrect entry. Your account number should be a number. Please " +
    "enter only that number.\n"
  end

  def self.new_account
    print "\nYour new account has been created. Congratulations!\n"
  end

  def self.are_you_a_manager
    print "\nAre you a manager? "
    gets.chomp.downcase 
  end

  def self.enter_man_name
    print "\nPlease enter your account name: "
    gets.chomp
  end

  def self.man_choice
    print "\nHello sir/mam! Welcome to YOUR bank! Would you like to 'alter' customer accounts, 'create' a new manager, or 'end' your session?? ('alter', 'create', 'end') "
    gets.chomp.downcase
  end

  def self.man_goodbye
    print "\nHave a good day. Say hello to your family for me!\n\n"
  end

  def self.overdraft_protection
    print "\nThe amount you attempted to withdraw would have left your account with a negative balance. Please deposit more money before attempting to withdraw said amount again. Thank you.\n"
  end

  def self.which_account
    print "\n\nPlease select your account number (Numbers only please): "
    gets.chomp.to_f
  end

  def self.which_customer
    print "\n\nPlease select your customer number (Numbers only please): "
    gets.chomp.to_f
  end

  def self.transfer_acct_1
    print "\nPlease enter the account number you wish to send the money from (numbers only): "
    gets.chomp.to_i
  end
  
  def self.transfer_acct_2
    print "\nPlease enter the account you wish to send the money to (numbers only): "
    gets.chomp.to_i
  end

  def self.transfer_ammount
    print "\nHow much would you like to transfer? "
    gets.chomp.to_f
  end

  end
module Display
  def self.account_info(acct_list)
    account_id_array = []
    acct_list.each do |a|
      print "\n"
      print 'Account #' + a["account_id"].to_s + "  -----  " + "Balance: $" +
      a["balance"].to_s
      print "\n"
      account_id_array.push(a["account_id"])
    end
    account_id_array
  end

  def self.account_info2(acct_list)
    account_id_array = []
    acct_list.each do |a|
      print "\n"
      print 'Customer #' + a["customer_id"].to_s + ' Account #' + a["account_id"].to_s + "  -----  " + "Balance: $" +
      a["balance"].to_s
      print "\n"
      account_id_array.push(a["account_id"])
    end
    account_id_array
  end
end