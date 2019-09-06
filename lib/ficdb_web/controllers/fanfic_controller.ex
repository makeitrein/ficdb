defmodule FicdbWeb.FanficController do
  use FicdbWeb, :controller
  use Breadcrumble

  require Logger

  plug :add_breadcrumb, name: "Fanfics", url: "/"
  plug FicdbWeb.Plugs.Authenticate when action not in [:index, :show, :new, :create]
  plug FicdbWeb.Plugs.VerifyRole, [:admin, :mod] when action in [:approve, :unapprove, :reject, :unreject]
  plug FicdbWeb.Plugs.VerifyOwnerOrRole, :fanfic when action in [:edit, :update, :delete]

  alias Ficdb.{Directory, Repo, SchemaHelpers, DateHelpers, EnumHelpers, Authorization}
  alias Ficdb.Directory.{Fanfic, Fandom, Review, Genre, Bookshelf, Character}


  def genre_dropdown_options,
      do: Genre
          |> SchemaHelpers.ordered_by_query
          |> SchemaHelpers.dropdown_format_query
          |> Repo.all

  def approval_status_options(conn)
    do
    case Authorization.verify_role(conn, [:admin, :mod]) do
      {:ok} -> Fanfic.power_user_approval_status_options
      _ -> Fanfic.approval_status_options()
    end
  end


  def character_dropdown_options,
      do: Character
          |> SchemaHelpers.ordered_by_query
          |> SchemaHelpers.dropdown_format_query
          |> Repo.all

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

  def sort_by_options,
      do: Fanfic.sort_by_options

  def fandom_dropdown_options,
      do: Fandom
          |> SchemaHelpers.ordered_by_query
          |> SchemaHelpers.dropdown_format_query
          |> Repo.all

  def word_count_options,
      do: Fanfic.word_count_options
          |> Keyword.keys

  def review_avg_options,
      do: Fanfic.review_avg_options

  def last_chapter_at_options,
      do: Fanfic.last_chapter_at_options
          |> Keyword.keys
          |> List.insert_at(0, nil)

  def current_user_bookshelves(current_user_id),
      do: Bookshelf
          |> Bookshelf.user_bookshelves_query(current_user_id)
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


  def bookshelf_dropdown_options(current_user_id),
      do: Bookshelf
          |> Bookshelf.user_bookshelves_query(current_user_id)
          |> Repo.all
          |> EnumHelpers.get_dropdown_tuple()


  def current_user_bookshelves(nil),
      do: Bookshelf.base_bookshelves()

  def humanize_tuple({a, b}), do: {Phoenix.Naming.humanize(a), b}

  def maturity_options,
      do: Ficdb.MaturityEnum.__enum_map__

  def status_options,
      do: Ficdb.FanficStatusEnum.__enum_map__


  def order_by_options,
      do: Fanfic.order_by_options()

  def sort_by_icons,
      do: Fanfic.sort_by_icons()

  def index(conn, params) do

    start = DateHelpers.now_microseconds

    current_user_id = Authorization.current_user_id(conn)


    with {:ok, query, filter_values} <- Fanfic
                                        |> Fanfic.summary_query(current_user_id)
                                        |> Fanfic.apply_filters(
                                             Map.merge(params, conn.params),
                                             share: [
                                               current_user_id: current_user_id,
                                               params: Map.merge(params, conn.params)
                                             ]
                                           ),
         fanfics <- query
                    |> Repo.all
      do
      render(
        conn,
        "index.html",
        fanfics: fanfics,
        approval_status_options: approval_status_options(conn),
        sort_by_options: sort_by_options(),
        main_character_filter_options: main_character_filter_options(),
        relationship_filter_options: relationship_filter_options(),
        review_avg_options: review_avg_options(),
        word_count_options: word_count_options(),
        status_options: status_options(),
        page_description: Fanfic.page_description(),
        page_options: Fanfic.page_options(),
        maturity_options: maturity_options(),
        last_chapter_at_options: last_chapter_at_options(),
        current_user_id: current_user_id,
        genre_dropdown_options: genre_dropdown_filter(),
        fandom_dropdown_options: fandom_dropdown_filter(),
        current_user_bookshelves: current_user_bookshelves(current_user_id),
        bookshelf_dropdown_options: bookshelf_dropdown_options(current_user_id),
        order_by_options: order_by_options(),
        sort_by_icons: sort_by_icons(),
        character_dropdown_options: character_dropdown_options(),
        filter_values: filter_values,
        items_length: (Enum.at(fanfics, 0) || %{})
                      |> Map.get(:items_length, 1),
        benchmark: DateHelpers.now_microseconds - start,
        current_user_reviews: current_user_reviews(current_user_id)
      )
    else
      err -> IO.inspect(err)
    end
  end



  def new(conn, _params) do
    # should i use repo here?... also, wtf syntax
    changeset = Directory.change_fanfic(
      %Fanfic{}
      |> Fanfic.form_query
    )
    add_breadcrumb(conn, name: "New", url: fanfic_path(conn, :new))
    |> render(
         "new.html",
         changeset: changeset,
         genre_dropdown_options: genre_dropdown_options(),
         fandom_dropdown_options: fandom_dropdown_options(),
         character_dropdown_options: character_dropdown_options(),
         fandom_ids: nil
       )
  end


  def create(conn, %{"fanfic" => fanfic_params}) do
    case Directory.create_fanfic(Authorization.merge_submitter_id(fanfic_params, conn)) do
      {:ok, fanfic} ->
        conn
        |> put_flash(:info, "Fanfic created successfully.")
        |> redirect(to: fanfic_path(conn, :show, fanfic))
      {:error, %Ecto.Changeset{} = changeset} ->


        #### TODO figure out how to load changeset into here
        IO.inspect changeset
        render(
          conn,
          "new.html",
          changeset: update_in(changeset.data, &Repo.preload(&1, [:genres, :fandoms, :primary_relationship])),
          genre_dropdown_options: genre_dropdown_options(),
          fandom_dropdown_options: fandom_dropdown_options(),
          character_dropdown_options: character_dropdown_options()
        )
    end
  end

  def show(conn, %{"id" => id}) do
    current_user_id = Authorization.current_user_id(conn)
    fanfic = Directory.get_fanfic!(id, current_user_id)

    can_review = current_user_id && !(
      Review
      |> Review.review_exists_query(id, current_user_id)
      |> Repo.one)
    review_changeset = fanfic
                       |> Ecto.build_assoc(:reviews)
                       |> Directory.change_review

    suggestion_changeset = fanfic
                           |> Ecto.build_assoc(:suggestions)
                           |> Repo.preload([:genres])
                           |> Ficdb.Directory.Suggestion.changeset(%{})

    render(
      conn,
      "show.html",
      fanfic: fanfic,
      review_changeset: review_changeset,
      suggestion_changeset: suggestion_changeset,
      genre_dropdown_options: genre_dropdown_options,
      approval_status_options: approval_status_options(conn),
      hide_unpoly_target: true,
      can_review: can_review,
      current_user_bookshelves: current_user_bookshelves(current_user_id)
    )
  end

  def edit(conn, %{"id" => id}) do
    current_user_id = Authorization.current_user_id(conn)
    fanfic = conn.assigns.fanfic
    changeset = Directory.change_fanfic(fanfic)
    add_breadcrumb(conn, name: fanfic.name, url: fanfic_path(conn, :show, fanfic))
    |> add_breadcrumb(name: "Edit", url: fanfic_path(conn, :edit, fanfic))
    |> render(
         "edit.html",
         fanfic: fanfic,
         changeset: changeset,
         genre_dropdown_options: genre_dropdown_options(),
         fandom_dropdown_options: fandom_dropdown_options(),
         character_dropdown_options: character_dropdown_options(),
       )

  end

  def update(conn, %{"id" => id, "fanfic" => fanfic_params}) do
    current_user_id = Authorization.current_user_id(conn)
    fanfic = conn.assigns.fanfic

    case Directory.update_fanfic(fanfic, Authorization.merge_updater_id(fanfic_params, conn)) do
      {:ok, fanfic} ->
        conn
        |> put_flash(:info, "Fanfic updated successfully.")
        |> redirect(to: fanfic_path(conn, :show, fanfic))
      {:error, %Ecto.Changeset{} = changeset} ->
        add_breadcrumb(conn, name: fanfic.name, url: fanfic_path(conn, :show, fanfic))
        |> add_breadcrumb(name: "Edit", url: fanfic_path(conn, :edit, fanfic))
        |> render(
             "edit.html",
             fanfic: fanfic,
             changeset: changeset,
             genre_dropdown_options: genre_dropdown_options(),
             fandom_dropdown_options: fandom_dropdown_options(),
             character_dropdown_options: character_dropdown_options()
           )
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user_id = Authorization.current_user_id(conn)
    fanfic = conn.assigns.fanfic

    {:ok, _fanfic} = Directory.delete_fanfic(fanfic)

    conn
    |> put_flash(:info, "Fanfic deleted successfully.")
    |> redirect(to: fanfic_path(conn, :index))
  end

  def approve(conn, %{"id" => id, "approval_status" => approval_status}) do
    current_user_id = Authorization.current_user_id(conn)
    fanfic = Directory.get_fanfic!(id, current_user_id)

    changeset = case approval_status do
      "unapproved" -> Fanfic.approve_changeset(fanfic, %{approver_id: nil , rejector_id: nil})
      "rejected" -> Fanfic.approve_changeset(fanfic, %{approver_id: nil, rejector_id: current_user_id})
      "approved" ->  Fanfic.approve_changeset(fanfic, %{approver_id: current_user_id, rejector_id: nil})
    end


    with {:ok, fanfic} <- Repo.update(changeset) do
      conn
      |> put_flash(:info, "Genre created successfully.")

    else
      err -> IO.inspect err
    end
  end


end
