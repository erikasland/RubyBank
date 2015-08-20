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
    if bank.name_exists?(@name, "customers") == true && bank.verify_pin(@name, @pin, "customers") == true
      @customer_id = @bank.find_customer_id(@name, @pin) 
      account_choice

    else
      Dialog::wrong_username_or_pin
      signup_signin
    end
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
        bank.create_account(@customer_id)
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

  def show_accounts
    Dialog::space
    @acct_list = @bank.customer_accounts(@name, @pin)
    Dialog::account_prompt
    @account_id_array = Display::account_info(@acct_list)
  end

  def do_dep_and_with
    @acct_num = Dialog::pick_your_account
    if !@account_id_array.include?(@acct_num)
      Dialog::fixnum_error
    else
      @account = bank.load_account(@acct_num)
      yield
    end
  end

  def do_deposit
    amount = -1
    while amount < 0
      amount = Dialog::deposit_amount
    end
    @account.deposit(amount)
    @account.save_to_db
  end

  def do_withdraw
    amount = -1
    while amount < 0
      amount = Dialog::withdraw_amount
    end
    @account.withdraw(amount)
    @account.save_to_db
  end

  def do_new_account
    bank.create_account(@customer_id)
    Dialog::new_account
  end

  def account_choice # Asks user if they want to deposit/withdraw, view current balance, or end their session.
    action = Dialog::how_can_we_help_you
    case action
    when "new account"
      do_new_account
      account_choice
    when "balance"
      show_accounts
      account_choice
    when "deposit"
      show_accounts
      do_dep_and_with {do_deposit}
      account_choice
    when "withdraw"
      show_accounts
      do_dep_and_with {do_withdraw}
      account_choice
    when "end"
      Dialog::goodbye_cust
    else
      Dialog::wrong_entry
      account_choice
    end
  end
end


BankFlow.new.signup_signin # Starts Ruby Bank