#defmodule FicdbWeb.FanficCommander do
#  use Drab.Commander, modules: [Drab.Query, Drab.Live, Drab.Element]
#
#  alias Ficdb.Directory
#  alias Ficdb.Repo
#  alias Ficdb.SchemaHelpers
#  alias Ficdb.Directory.{Fanfic, FanficsBookshelves, Character}
#
#  defp param_to_id_list(sender, form_name, param) do (sender.params[form_name][param] || []) |> List.flatten |> Enum.map(&String.to_integer/1) end
#
#  defhandler filter_character_dropdown(socket, sender) do
#    fandom_ids = param_to_id_list(sender, "fanfic", "fandoms") ++ param_to_id_list(sender, "search", "fandoms")
#
#    character_dropdown_options = Character
#                                 |> Character.from_fandom_query(fandom_ids)
#                                 |> SchemaHelpers.selectize_format_query
#                                 |> Repo.all
#
#    exec_js!(
#      socket,
#      "
#      const select_mcs = document.querySelectorAll('select[id*=\"main_character_id\"]');
#      const select_prs = document.querySelectorAll('select[id*=\"primary_relationship\"]');
#      [...select_mcs, ...select_prs].forEach(select => {
#        select.selectize.clearOptions();
#        select.selectize.addOption(#{Poison.encode!(character_dropdown_options)});
#      });
#      "
#    )
#  end
#
#  defhandler scrape_forum(socket, sender, host) do
#    id = sender.params["fanfic"][host <> "_id"]
#    with {:ok, scraped = %{}} <- Ficdb.Crawlers.fanfic_changeset(id, String.to_atom(host)) do
#      Enum.each scraped, fn {k, v} ->
#        k = "#fanfic_#{k}"
#        socket
#        |> update(:val, set: v, on: k)
#      end
#
#    else
#      err -> exec_js(
#               socket,
#               "uikit.notification({
#      message: 'scrape_forum error: #{err}',
#      status: 'danger',
#      timeout: 1000
#  });"
#             )
#    end
#  end
#
#
#
#
#end
