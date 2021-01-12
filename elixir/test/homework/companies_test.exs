# # Tests based off of merchants_test.exs
# defmodule Homework.CompaniesTest do
#   use Homework.DataCase
#
#   alias Homework.Companies
#
#   describe "companies" do
#     alias Homework.Companies.Company
#
#     @valid_attrs %{credit_line: 142857, name: "some name"}
#     @update_attrs %{
#       credit_line: 857142,
#       name: "some updated name"
#     }
#     @invalid_attrs %{credit_line: nil, name: nil}
#
#     def company_fixture(attrs \\ %{}) do
#       {:ok, company} =
#         attrs
#         |> Enum.into(@valid_attrs)
#         |> Companies.create_company()
#
#       company
#     end
#
#     test "list_companies/1 returns all companies" do
#       company = company_fixture()
#       assert Companies.list_companies([]) == [company]
#     end
#
#     test "get_company!/1 returns the company with given id" do
#       company = company_fixture()
#       assert Companies.get_company!(company.id) == company
#     end
#
#     test "create_company/1 with valid data creates a company" do
#       assert {:ok, %Company{} = company} = Companies.create_company(@valid_attrs)
#       assert company.credit_line == 8675309
#       assert company.name == "some name"
#     end
#
#     test "create_company/1 with invalid data returns error changeset" do
#       assert {:error, %Ecto.Changeset{}} = Companies.create_company(@invalid_attrs)
#     end
#
#     test "update_company/2 with valid data updates the company" do
#       company = company_fixture()
#       assert {:ok, %Company{} = company} = Companies.update_company(company, @update_attrs)
#       assert company.credit_line == 14641
#       assert company.name == "some updated name"
#     end
#
#     test "update_company/2 with invalid data returns error changeset" do
#       company = company_fixture()
#       assert {:error, %Ecto.Changeset{}} = Companies.update_company(company, @invalid_attrs)
#       assert company == Companies.get_company!(company.id)
#     end
#
#     test "delete_company/1 deletes the company" do
#       company = company_fixture()
#       assert {:ok, %Company{}} = Companies.delete_company(company)
#       assert_raise Ecto.NoResultsError, fn -> Companies.get_company!(company.id) end
#     end
#
#     test "change_company/1 returns a company changeset" do
#       company = company_fixture()
#       assert %Ecto.Changeset{} = Companies.change_company(company)
#     end
#
#     test "delete_company/1 on a nonexistent company" do
#       company = company_fixture()
#       Companies.delete_company(company)
#       assert_raise Ecto.StaleEntryError, fn -> Companies.delete_company(company) end
#     end
#   end
# end
