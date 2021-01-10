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

Merchants.create_merchant(%{name: "Gene", description: "Private Investigator"})
Users.create_user(%{dob: "1-23-1234", first_name: "Maebe", last_name: "Funke"})
Transactions.create_transaction(%{user_id: "1a110e2b-a79f-4a24-abec-11cfd092ca0d", merchant_id: "f0457fc7-811e-4fcc-a0b8-a8589127212a", amount: 250, debit: true, description: "One Bluth Frozen Banana"})
