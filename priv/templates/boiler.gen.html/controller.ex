defmodule <%= inspect context.web_module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>Controller do
  use <%= inspect context.web_module %>, :controller
  use Breadcrumble

  plug :add_breadcrumb, name: "<%= schema.human_plural %>", url: "/" <> "<%= schema.plural %>"
  plug FicdbWeb.Plugs.Veil.Authenticate when action not in [:index, :show]

  alias <%= inspect context.module %>
  alias <%= inspect schema.module %>

  def index(conn, _params) do
    <%= schema.plural %> = <%= inspect context.alias %>.list_<%= schema.plural %>()
    render(conn, "index.html", <%= schema.plural %>: <%= schema.plural %>)
  end

  def new(conn, _params) do
    changeset = <%= inspect context.alias %>.change_<%= schema.singular %>(%<%= inspect schema.alias %>{})
    add_breadcrumb(conn, name: "New", url: <%= schema.route_helper %>_path(conn, :new))
    |> render("new.html", changeset: changeset)
  end


  def create(conn, %{<%= inspect schema.singular %> => <%= schema.singular %>_params}) do
    case <%= inspect context.alias %>.create_<%= schema.singular %>(<%= schema.singular %>_params) do
      {:ok, <%= schema.singular %>} ->
        conn
        |> put_flash(:info, "<%= schema.human_singular %> created successfully.")
        |> redirect(to: <%= schema.route_helper %>_path(conn, :show, <%= schema.singular %>))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    <%= schema.singular %> = <%= inspect context.alias %>.get_<%= schema.singular %>!(id)
    name_or_id = <%= schema.singular %>.name || <%= schema.singular %>.id
    add_breadcrumb(conn, name: name_or_id, url: <%= schema.route_helper %>_path(conn, :show, <%= schema.singular %>))
    |> render("show.html", <%= schema.singular %>: <%= schema.singular %>)
  end

  def edit(conn, %{"id" => id}) do
    <%= schema.singular %> = <%= inspect context.alias %>.get_<%= schema.singular %>!(id)
    name_or_id = <%= schema.singular %>.name || <%= schema.singular %>.id
    changeset = <%= inspect context.alias %>.change_<%= schema.singular %>(<%= schema.singular %>)
    add_breadcrumb(conn, name: name_or_id, url: <%= schema.route_helper %>_path(conn, :show, <%= schema.singular %>))
    |> add_breadcrumb(name: "Edit", url: <%= schema.route_helper %>_path(conn, :edit, <%= schema.singular %>))
    |> render("edit.html", <%= schema.singular %>: <%= schema.singular %>, changeset: changeset)
  end

  def update(conn, %{"id" => id, <%= inspect schema.singular %> => <%= schema.singular %>_params}) do
    <%= schema.singular %> = <%= inspect context.alias %>.get_<%= schema.singular %>!(id)

    case <%= inspect context.alias %>.update_<%= schema.singular %>(<%= schema.singular %>, <%= schema.singular %>_params) do
      {:ok, <%= schema.singular %>} ->
        conn
        |> put_flash(:info, "<%= schema.human_singular %> updated successfully.")
        |> redirect(to: <%= schema.route_helper %>_path(conn, :show, <%= schema.singular %>))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", <%= schema.singular %>: <%= schema.singular %>, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    <%= schema.singular %> = <%= inspect context.alias %>.get_<%= schema.singular %>!(id)
    {:ok, _<%= schema.singular %>} = <%= inspect context.alias %>.delete_<%= schema.singular %>(<%= schema.singular %>)

    conn
    |> put_flash(:info, "<%= schema.human_singular %> deleted successfully.")
    |> redirect(to: <%= schema.route_helper %>_path(conn, :index))
  end
end
