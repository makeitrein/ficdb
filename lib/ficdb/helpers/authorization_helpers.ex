defmodule Ficdb.Authorization do

  def render({:ok}, render), do: render
  def render({:ok, conn}, render), do: render
  def render({:error, status}, render), do: nil

  def verify_role(conn, permitted_roles) do
    with {:ok, conn} <- authenticate(conn),
         {:ok, conn} <- authorize(conn, permitted_roles) do
      {:ok}
    else
      {:error, status} ->
        {:error, status}
    end
  end

  def submitter_id(%{submitter_id: submitter_id}), do: submitter_id
  def submitter_id(_), do: nil

  def merge_submitter_id(struct, conn), do: Map.put(struct, "submitter_id", current_user_id(conn))
  def merge_updater_id(struct, conn), do: Map.put(struct, "updater_id", current_user_id(conn))

  def current_user_id(conn),
      do: Map.get(conn.assigns, :veil_user_id)

  def verify_owner_or_role(conn, user_id, permitted_roles) do
    case verify_role(conn, permitted_roles) == {:ok} || verify_owner(conn, user_id) == {:ok} do
      true -> {:ok}
      false -> {:error, :forbidden}
    end
  end

  def verify_owner(conn, user_id) do
    with {:ok, conn} <- authenticate(conn),
         {:ok, conn} <- do_verify_ownership(conn, user_id) do
      {:ok}
    else
      {:error, status} ->
        {:error, status}
    end
  end

  defp do_verify_ownership(conn, user_id) do
    case current_user_id(conn) == user_id do
      true -> {:ok, conn}
      false -> {:error, :forbidden}
    end
  end

  def authenticate(conn) do
    if current_user_id(conn) do
      {:ok, conn}
    else
      {:error, :unauthorized}
    end
  end

  defp authorize(conn, permitted_roles) when permitted_roles == [], do: {:ok, conn}

  defp authorize(conn, permitted_roles) do
    case role_permitted?(conn, permitted_roles) do
      true -> {:ok, conn}
      false -> {:error, :forbidden}
    end
  end

  defp role_permitted?(conn, permitted_roles) do
    veil_user = conn.assigns.veil_user
    Map.has_key?(veil_user, :role) && veil_user.role in permitted_roles
  end
end