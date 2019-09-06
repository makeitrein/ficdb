import "selectize/dist/js/standalone/selectize.js"
var UJS = require("phoenix_ujs");

const SELECTED_OPTION = "option:selected";
const SELECT = "select:not(.selectize):not([multiple])";

const selectizeBasicDropdown = () => {
  $("select[multiple]").selectize({
    plugins: ['remove_button'],
      onChange: function(value) {
          const isFandomSelect = $(this)[0].$control_input.prop("id").includes("fandom");
          if (isFandomSelect) {
              crawlFandoms(value)
          }
      }
  })

  $("select.selectize").selectize({})

};


const crawlFandoms = (fandom_ids) => {

    UJS.xhr(`/crawl/characters?fandom_ids=${encodeURIComponent(JSON.stringify(fandom_ids))}`, "GET", {

        success: function (xhr) {
            const characters = JSON.parse(xhr.response);

            const select_mcs = document.querySelectorAll('select[id*=\"main_character_id\"]');
            const select_prs = document.querySelectorAll('select[id*=\"primary_relationship\"]');
            [...select_mcs, ...select_prs].forEach(select => {
                select.selectize.clearOptions();
                select.selectize.addOption(characters);
            });
        }
    });
}

const main = () => {
  selectizeBasicDropdown()
}

up.compiler("select", function() {
  main()
});

