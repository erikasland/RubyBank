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
      answer = Dialog::are_you_a_manager
      if answer == "yes"
        manager_signin
      else
        signin
      end
    elsif response == "no"
      make_an_account
    else
      signup_signin
    end
  end

  def signin # Signs in pre-existing customer
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

  def manager_signin
    @man_name = Dialog::enter_man_name
    @man_pin = Dialog::signin_pin
    if bank.name_exists?(@man_name, "managers") == true && bank.verify_pin(@man_name, @man_pin, "managers") == true
      @man_id = bank.find_manager_id(@man_name, @man_pin) 
      manager_choice
    else
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

  def show_accounts # Shows customer's accounts
    Dialog::space
    @acct_list = bank.customer_accounts(@name, @pin)
    Dialog::account_prompt
    @account_id_array = Display::account_info(@acct_list)
  end

  def do_dep_and_with # Checks for correct entry and loads customer's accounts
    @acct_num = Dialog::pick_your_account
    if !@account_id_array.include?(@acct_num)
      Dialog::fixnum_error
    else
      @account = bank.load_account(@acct_num)
      yield
    end
  end

  def do_deposit # Deposits customer's money into their account
    amount = -1
    while amount < 0
      amount = Dialog::deposit_amount
    end
    @account.deposit(amount)
    @account.save_to_db
  end

  def do_withdraw # Deposits customer's money into their account
    amount = Dialog::withdraw_amount
    if @account.balance - amount < 0
      Dialog::overdraft_protection
    else 
      @account.withdraw(amount)
      @account.save_to_db
    end
  end

  def do_new_account # Creates a new account for a customer
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

  def account_select # Displays user customer accounts and asks you to chose the one you would like to alter
    Dialog::space
    @acct_list = bank.account_list(@man_name, @man_pin)
    @account_id_array = Display::account_info2(@acct_list)
    account_num = Dialog::which_account
    @account = bank.load_account(account_num)
    alter_account
  end

  def show_man_balance # Prepares data needed to utilize the show_accounts method
    Dialog::space
    @acct_list = bank.account_list(@man_name, @man_pin)
    @account_id_array = Display::account_info2(@acct_list)  
  end
  
  def transfer_funds # Lets a manager transfer funds from one account to another.
    Dialog::space
    @acct_list = bank.account_list(@man_name, @man_pin)
    @account_id_array = Display::account_info2(@acct_list)
    from = Dialog::transfer_acct_1
    to = Dialog::transfer_acct_2
    how_much = Dialog::transfer_ammount
    bank.money_transfer(from, to, how_much)
  end

  def new_manager # Allows pre-existing manager to create a new manager
    name = Dialog::account_name 
    pin = Dialog::account_pin
    @manager = Manager.new(bank.db, name, pin)
    @manager.add_to_db
    manager_choice
  end

  def manager_choice # Asks a manager if your would like to alter a customer account or create a new manager.
    ans = Dialog::man_choice
    case ans 
    when 'alter'
      account_select
      alter_account
    when 'create'
      new_manager
    when 'end'
      Dialog::man_goodbye
    else
      Dialog::wrong_entry
      manager_choice
    end
  end

  def alter_account # Asks user if they want to deposit/withdraw, view current balance, or end their session.
    action = Dialog::how_can_we_help_you_man
    case action
    when "new account"
      do_new_account
      alter_account
    when "balance"
      show_man_balance
      alter_account
    when "deposit"
      do_deposit  
      alter_account
    when "withdraw"
      do_withdraw
      alter_account
    when "transfer"
      transfer_funds
    when "end"
      manager_choice
    else
      Dialog::wrong_entry
      alter_account
    end
  end
end

BankFlow.new.signup_signin # Starts Ruby Bank