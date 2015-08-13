require_relative 'view'
require_relative 'model'

class BankFlow
  attr_accessor :bank

  def initialize
    @bank = Bank.new
  end

  def signup_signin # Asks a user if they have a pre-existing account.
    response = Dialog::new_or_old_user

    if response == "yes" 
      signin

    elsif response == "no"
      make_an_account

    else
      signup_signin
    end
  end

  def signin
    @name = Dialog::signin_name
    @pin = Dialog::signin_pin
    @cust_id = bank.find_customer_id(@name, @pin)
    account_choice
  end

  def make_an_account # Asks user if they want to make an account.
    answer = Dialog::greeting

    if answer == "yes"
      @name = Dialog::account_name
      @pin = Dialog::enter_pin

      if bank.name_exists?(@name, "customers") == false
        @customer = Customer.new(bank.db, @name, @pin)
        @customer.add_to_db
        @customer_id = @bank.find_customer_id(@name, @pin) 
        @account = Account.new(bank.db, @customer_id)
        @account.save_to_db 
        account_choice

      else
        Dialog::existing_account_error
        signin
      end

    elsif answer == "no"
      Dialog::goodbye

    else
      make_an_account
    end
  end

  def account_choice # Asks user if they want to deposit/withdraw, view current balance, or end their session.
    action = Dialog::how_can_we_help_you

    if action == "balance"
      Dialog::space
      acct_list = @bank.customer_accounts(@name, @pin)
      puts acct_list[0]["account_id"]
      acct_num = Dialog::pick_your_account
      account = bank.load_account(acct_num)
      cust_id = bank.find_customer_id(@name, @pin)
      puts account.return_balance(cust_id)
      account_choice

    elsif action == "deposit"
      Dialog::space
      acct_list = @bank.customer_accounts(@name, @pin)
      puts acct_list[0]["account_id"]
      acct_num = Dialog::pick_your_account
      account = bank.load_account(acct_num)
      amount = Dialog::deposit_amount
      account.deposit(amount)
      account.save_to_db
      account_choice

    elsif action == "withdraw"
      Dialog::space
      acct_list = @bank.customer_accounts(@name, @pin)
      puts acct_list[0]["account_id"]
      acct_num = Dialog::pick_your_account
      account = bank.load_account(acct_num)
      amount = Dialog::deposit_amount
      account.withdraw(amount)
      account.save_to_db
      account_choice

    elsif action == "end"
      Dialog::goodbye_cust

    else
      Dialog::wrong_entry
      account_choice
    end
  end
end

BankFlow.new.signup_signin # Starts Ruby Bank