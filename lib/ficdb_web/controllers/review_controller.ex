defmodule FicdbWeb.ReviewController do
  use FicdbWeb, :controller
  use Breadcrumble

  plug :add_breadcrumb, name: "Reviews", url: "/" <> "reviews"

  plug FicdbWeb.Plugs.Authenticate when action in [:create, :new, :vote]
  plug FicdbWeb.Plugs.VerifyOwnerOrRole, :review when action in [:edit, :update, :delete]

  alias Ficdb.{DateHelpers, SchemaHelpers}
  alias Ficdb.Authorization
  alias Ficdb.Repo
  alias Ficdb.Directory
  alias Ficdb.Directory.{Review, Fandom, Genre, Character}

  def genre_dropdown_filter,
      do: Genre
          |> SchemaHelpers.ordered_by_query
          |> SchemaHelpers.with_fanfics_query
          |> SchemaHelpers.dropdown_format_query
          |> Repo.all

  def fandom_dropdown_filter,
      do: Fandom
          |> SchemaHelpers.ordered_by_query
          |> SchemaHelpers.with_fanfics_query
          |> SchemaHelpers.dropdown_format_query
          |> Repo.all

  def main_character_filter_options,
      do: Character
          |> SchemaHelpers.ordered_by_query
          |> Character.main_character_dropdown_query
          |> Repo.all

  def relationship_filter_options,
      do: Character
          |> SchemaHelpers.ordered_by_query
          |> Character.relationship_dropdown_query
          |> Repo.all

  def current_user_reviews(current_user_id) do

    if is_nil(current_user_id) do
      nil
    else
      Review
      |> Review.from_submitter_query(current_user_id)
      |> Repo.one
    end
  end


  def new(conn, _params) do
    changeset = Directory.change_review(%Review{})
    add_breadcrumb(conn, name: "New", url: review_path(conn, :new))
    |> render("new.html", changeset: changeset)
  end



  def index(conn, _params) do
    start = DateHelpers.now_microseconds
    current_user_id = Authorization.current_user_id(conn)

    with {:ok, query, filter_values}
         <- Review
            |> Review.summary_query()
            |> Review.with_headline()
            |> Review.with_fanfic_query()
            |> Review.apply_filters(conn.params, Review),
         reviews <- query
                    |> Repo.all
      do
      render(
        conn,
        "index.html",
        reviews: reviews,
        genre_dropdown_filter: genre_dropdown_filter,
        main_character_filter_options: main_character_filter_options,
        relationship_filter_options: relationship_filter_options,
        fandom_dropdown_filter: fandom_dropdown_filter,
        current_user_reviews: current_user_reviews(current_user_id),

        filter_values: filter_values,
        sort_by_options: Review.sort_by_options(),
        items_length: (Enum.at(reviews, 0) || %{}) |> Map.get(:items_length, 1),
        benchmark: DateHelpers.now_microseconds - start
      )
    end
  end

  def show(conn, %{"id" => id}) do
    current_user_id = Authorization.current_user_id(conn)
    review = Directory.get_review!(id)

    can_edit = current_user_id == review.submitter_id

    render(
      conn,
      "show.html",
      review: review,
      can_edit: can_edit
    )
  end

  def create(conn, %{"review" => review_params}) do
    current_user_id = Authorization.current_user_id(conn)
    fanfic = Directory.get_fanfic!(review_params["fanfic_id"], current_user_id)
    case Directory.create_review(Authorization.merge_submitter_id(review_params, conn)) do
      {:ok, review} ->
        render(
          conn,
          "show.html",
          review: review
        )
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Review failed to create.")
        |> redirect(to: fanfic_path(conn, :show, fanfic))
    end
  end

  def edit(conn, %{"id" => id}) do
    review = conn.assigns.review
    changeset = Directory.change_review(review)

    add_breadcrumb(conn, name: review.fanfic.name, url: fanfic_path(conn, :show, review.fanfic_id))
    |> add_breadcrumb(name: "Edit Review", url: review_path(conn, :edit, review))
    |> render("edit.html", review: review, changeset: changeset)
  end

  def vote(conn, %{"id" => id}) do
    submitter_id = Authorization.current_user_id(conn)

    vote_params = %{submitter_id: submitter_id, review_id: id}
    case Directory.create_review_vote(vote_params) do
      {:ok, review} -> send_resp(conn, 200, "")
      {:error, %Ecto.Changeset{} = changeset} -> send_resp(conn, 500, "")
    end

  end

  def update(conn, %{"id" => id, "review" => review_params}) do
    review = conn.assigns.review
    fanfic = Directory.get_fanfic!(review_params["fanfic_id"], conn.assigns[:veil_user_id])

    case Directory.update_review(review, Authorization.merge_updater_id(review_params, conn)) do
      {:ok, review} ->
        render(
          conn,
          "show.html",
          review: review
        )
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", review: review, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    review = conn.assigns.review
    {:ok, _review} = Directory.delete_review(review)

    conn
    |> put_flash(:info, "Review deleted successfully.")
    |> redirect(to: review_path(conn, :index))
  end
end
