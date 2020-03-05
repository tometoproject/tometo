defmodule AphWeb.ConnCase do
  alias Ecto.Adapters.SQL.Sandbox

  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use AphWeb.ConnCase, async: true`, although
  this option is not recommendded for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      alias AphWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint AphWeb.Endpoint
    end
  end

  setup tags do
    :ok = Sandbox.checkout(Aph.Repo)

    unless tags[:async] do
      Sandbox.mode(Aph.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
