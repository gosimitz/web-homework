# Tests based off of merchants_test.exs
defmodule Homework.CompaniesTest do
  use Homework.DataCase

  alias Homework.Companies
  alias Homework.Transactions
  alias Homework.Merchants
  alias Homework.Users

  describe "companies" do
    alias Homework.Companies.Company

    @valid_attrs %{credit_line: 142857, name: "some name", available_credit: 142857}
    @update_attrs %{
      credit_line: 857142,
      name: "some updated name"
    }
    @invalid_attrs %{credit_line: nil, name: nil}

    def company_fixture(attrs \\ %{}) do
      {:ok, company} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Companies.create_company()

      company
    end

    test "list_companies/1 returns all companies" do
      company = company_fixture()
      assert Companies.list_companies([]) == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Companies.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      assert {:ok, %Company{} = company} = Companies.create_company(@valid_attrs)
      assert company.credit_line == 142857
      assert company.name == "some name"
      assert company.available_credit == 142857
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()
      assert {:ok, %Company{} = company} = Companies.update_company(company, @update_attrs)
      assert company.credit_line == 857142
      assert company.name == "some updated name"
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()
      assert {:error, %Ecto.Changeset{}} = Companies.update_company(company, @invalid_attrs)
      assert company == Companies.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Companies.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      company = company_fixture()
      assert %Ecto.Changeset{} = Companies.change_company(company)
    end

    test "delete_company/1 on a nonexistent company" do
      company = company_fixture()
      Companies.delete_company(company)
      assert_raise Ecto.StaleEntryError, fn -> Companies.delete_company(company) end
    end

    test "create_transaction/1 properly affects available credit" do
      # To create transaction, Merchant, User, and Company must be defined
      {:ok, company1} = Companies.create_company(@valid_attrs)
      {:ok, merchant1} =
        Merchants.create_merchant(%{description: "some description", name: "some name"})
      {:ok, user1} = Users.create_user(%{ dob: "some dob", first_name: "some first_name",
          last_name: "some last_name", company_id: company1.id})
      #create company with credit line 142857.

      Transactions.create_transaction(%{amount: 42857,
          credit: true, description: "Staircar purchase", merchant_id: merchant1.id,
          user_id: user1.id, company_id: company1.id})
      company1 = Companies.get_company!(company1.id)
      assert company1.available_credit == 100000

    end
    test "delete_transaction/1 properly affects available credit" do
      # To create transaction, Merchant, User, and Company must be defined
      {:ok, company1} = Companies.create_company(@valid_attrs)
      {:ok, merchant1} =
        Merchants.create_merchant(%{description: "some description", name: "some name"})
      {:ok, user1} = Users.create_user(%{ dob: "some dob", first_name: "some first_name",
          last_name: "some last_name", company_id: company1.id})
      #create company with credit line 142857.

       Transactions.create_transaction(%{amount: 42857,
          credit: true, description: "Staircar purchase", merchant_id: merchant1.id,
          user_id: user1.id, company_id: company1.id})
      {:ok, delete_me} = Transactions.create_transaction(%{amount: 500,
          credit: true, description: "Tickets for a Star War", merchant_id: merchant1.id,
          user_id: user1.id, company_id: company1.id})
      Transactions.delete_transaction(delete_me)
      company1 = Companies.get_company!(company1.id)
      assert company1.available_credit == 100000
    end

    test "update_company/2 properly affects available credit" do
      # To create transaction, Merchant, User, and Company must be defined
      {:ok, company1} = Companies.create_company(@valid_attrs)
      {:ok, merchant1} =
        Merchants.create_merchant(%{description: "some description", name: "some name"})
      {:ok, user1} = Users.create_user(%{ dob: "some dob", first_name: "some first_name",
          last_name: "some last_name", company_id: company1.id})
      #create company with credit line 142857.

      Transactions.create_transaction(%{amount: 42857,
          credit: true, description: "Staircar purchase", merchant_id: merchant1.id,
          user_id: user1.id, company_id: company1.id})
          update = %{
            credit_line: 42857,
            name: company1.name
          }
      {:ok, company1} = Companies.update_company(company1, update)
      assert company1.available_credit == 0

    end
  end
end
