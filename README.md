
INSTRUCTIONS:


Create an account: 

To create an account, create an instance of the class "BankAccount" and assign it to your 
account name. As arguments to the class instance, type your account name, followed by the 
ammount of money you would like to initially deposit. 

				Like this...

					rogers_bank = BankAccount.new("Roger", 10000)



Deposit or withdraw money:

To deposit or withdraw money, call your new account variable and the corresponding 'deposit' or 'withdraw' method, and include your PIN# and the ammount you would like to deposit as an argument to your method. Your PIN number will always be 1234 (unless
you take it upon yourself to change the 'pin' method in the private section of the code).

			    Like this...

					rogers_bank.deposit(1234, 100000000)

					or

					rogers_bank.withdraw(1234, 67)



Check your balance: 

To check how much is currently available in your account, call your new account variable and the correspoding 'show_balance' method, and include your PIN# as an argument to the 'show_balance' method. Again, your PIN number will always be 1234 unless
you change it.

										Like this...

											rogers_bank.show_balance(1234)

											



