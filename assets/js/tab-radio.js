

const main = () => {
    // click link -> changes select dropdown value -> submits form
    // not ideal, but unpoly doesn't play nicely with radios so this hack was needed


    const ukTabItem = ".uk-tab li";
    const blockLinks = ".blocks a[data-enabled='true']";
    const activeClass = "uk-active";
    const idAttribute = "id";
    const pageSearchDropdown = "#search_page";
    const filterForm = "#filter";

    $(ukTabItem).on("click", function(e) {
        $(ukTabItem).removeClass(activeClass)
        $(this).addClass(activeClass)
    });

    $(blockLinks).on("click", function() {
        $(blockLinks).removeClass(activeClass);
        $(this).addClass(activeClass);
        $(pageSearchDropdown).val($(this).attr(idAttribute));
        $(filterForm).submit();
    })

    $(blockLinks).removeClass(activeClass);
    const current_sort = $(pageSearchDropdown).val();
    $("#" + current_sort).addClass(activeClass);

};


up.compiler("main", function() {
  main()

});

