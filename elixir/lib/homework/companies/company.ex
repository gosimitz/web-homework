defmodule Homework.Companies.Company do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homework.Companies

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "companies" do
    field(:credit_line, :integer)
    field(:name, :string)
    field(:available_credit, :integer)

    timestamps()
  end

  # As a frequent user of if, else if, and else by trade, it was tough to leave
  # that comforting world. but here
  # I am, leaving the nest.
  def modify_attrs(company, attrs, nil) do
    new_attrs = %{
      credit_line: attrs.credit_line,
      name: attrs.name,
      available_credit: attrs.credit_line
    }
  end
  def modify_attrs(company, attrs, true) do
    # No need to change the attrs if the credit line stays the same then available_credit does too
      new_attrs = %{
        credit_line: attrs.credit_line,
        name: attrs.name,
        available_credit: attrs.available_credit
      }
  end
  def modify_attrs(company, attrs, false) do
    #credit_line changed, thus available_credit has too
    new_attrs = %{
      credit_line: attrs.credit_line,
      name: attrs.name,
      available_credit: (attrs.credit_line-company.credit_line) + company.available_credit
    }
  end
  @doc false
  def changeset(company, attrs) do

    # See if company is already in DB. If so, then make new attrs with available_credit from old company
    # If not, then available_credit = credit_line
    if(is_nil(company.id)) do
      attrs = modify_attrs(company, attrs, nil)

    else #The value of available_credit is already stored in the database. Thus the new available_credit
    #must be calculated based on changes to the credit_line, if that changed.
      # {:ok, stored_company} = Companies.get_company!(company.id)

      attrs = modify_attrs(company, attrs, company.credit_line == attrs.credit_line)
    end

    company
    |> cast(attrs, [:name, :credit_line, :available_credit])
    |> validate_required([:name, :credit_line, :available_credit])
  end
end
