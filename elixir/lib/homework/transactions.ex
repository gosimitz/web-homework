defmodule Homework.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias Homework.Repo

  alias Homework.Transactions.Transaction
  alias Homework.Companies

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions([])
      [%Transaction{}, ...]

  """
  def list_transactions(_args) do
    Repo.all(Transaction)
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}) do
    {:ok, ret_val} = %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert(returning: true)
    company = Companies.get_company!(ret_val.company_id)
    Companies.update_available_credit(ret_val.company_id, ret_val.amount, company.available_credit)
    ret_val
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction_difference = attrs.amount - transaction.amount
    ret_val = transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
    company = Companies.get_company(transaction.company_id)
    update_company = %{
      credit_line: company.credit_line,
      name: company.name,
      available_credit: company.available_credit - transaction_difference
    }
    Companies.update_company(company, update_company)
    ret_val
  end

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    transaction = Repo.delete(transaction)
    company = Companies.get_company(transaction.company_id)
    update_company = %{
      credit_line: company.credit_line,
      name: company.name,
      available_credit: company.available_credit + transaction.amount
    }
    Companies.update_company(company, update_company)
    transaction
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{data: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, attrs)
  end
end
