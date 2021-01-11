# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Homework.Repo.insert!(%Homework.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Homework.Users
alias Homework.Merchants
alias Homework.Transactions
alias Homework.Companies
# Number of users to add to the database
num_user_add = 10
# Number of Merchants to add to the database
num_merchant_add = 10
# Number of Transactions to add to the database
num_transaction_add = 10

Companies.create_company(%{credit_line: 123, name: "Bombay House"})

merchant_names = ["Michael B. Company", "Gobias Industries", "Steve Holt! Pest Control", "Sitwell Enterprises", "Bluth Company"]
first_names = ["Maebe", "Egg", "Her?", "Plant", "Ann", "Gene", "George", "Lucille", "George Michael", "Stan", "Lucille 2", "Bob", "Barry", "Tobias", "Buster"]
last_names = ["Sitwell", "Bluth", "Veal", "Funke", "Austero", "Loblaw", "Zuckercorn", "Holt!", "Parmesan"]
descriptions = ["Homebuilder", "Egg", "Private Investigator", "Attorney", "Software Developer", "Actor"]

# Create the desired amount of users.
for _i <- 1..num_user_add do
  # Randomly select a first and last name
  first_index = :rand.uniform(Enum.count(first_names))
  last_index = :rand.uniform(Enum.count(last_names))
  # Get the first and last name at those indices
  f_name = Enum.at(first_names, first_index)
  l_name = Enum.at(last_names, last_index)
  Users.create_user(%{dob: "11-02-2003", first_name: f_name, last_name: l_name})
end

# Create the desired amount of merchants.
for _i <- 1..num_merchant_add do
  # Randomly select a name and description
  name_index = :rand.uniform(Enum.count(merchant_names))
  desc_index = :rand.uniform(Enum.count(descriptions))
  # Get the name and description at those indices
  name = Enum.at(merchant_names, name_index)
  desc = Enum.at(descriptions, desc_index)
  Merchants.create_merchant(%{name: name, description: desc})
end

user_data = Users.list_users([])
merchant_data = Merchants.list_merchants([])


# Create the number of Transactions specified randomly.
for _i <- 1..num_transaction_add do
  # Getting random user_index and merchant_index.
  user_index = :rand.uniform(Enum.count(user_data))
  merchant_index = :rand.uniform(Enum.count(merchant_data))
  # Get the ids of the user and merchant at those indices
  uid = Enum.at(user_data, user_index).id
  mid = Enum.at(merchant_data, merchant_index).id
  Transactions.create_transaction(%{user_id: uid, merchant_id: mid, amount: 64, debit: true, description: "One Bluth Frozen Banana"})
end
