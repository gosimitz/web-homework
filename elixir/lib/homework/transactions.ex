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
    ret_val = %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
    |> modify_company
  end

  def modify_company({:ok, transaction}) do
    comp_id = transaction.company_id
    company = Companies.get_company!(comp_id)
    Companies.update_available_credit(transaction.company_id, transaction.amount, company.available_credit, true)
    {:ok, transaction}
  end

  def modify_company({:error, changeset}) do
    {:error, changeset}
  end

  def company_process({:ok, transaction_map}, attrs) do
    company = Companies.get_company!(transaction_map.company_id)
    transaction_difference = attrs.amount - transaction_map.amount
    update_company = %{
      credit_line: company.credit_line,
      name: company.name,
      available_credit: company.available_credit - transaction_difference
    }
    if{:ok, _} = Companies.update_company(company, update_company) do
      {:ok, transaction_map}
    else
      {:error, %Ecto.Changeset{}}
  end
  end

  def company_process({:error, changeset}, attrs) do
    {:error, changeset}
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
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
    |> company_process(attrs)
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
    {:ok, transaction_map} = Repo.delete(transaction)
    company = Companies.get_company!(transaction_map.company_id)
    update_company = %{
      credit_line: company.credit_line,
      name: company.name,
      available_credit: company.available_credit + transaction_map.amount
    }
    Companies.update_company(company, update_company)
    {:ok, transaction}
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
