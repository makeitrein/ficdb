const main = () => {
    const sidebar = "#menu";
    const sidebarTrigger = "[href='#menu']";

    $(sidebar).mmenu({
        extensions: ["theme-dark", "fx-menu-fade",
            "fx-panels-none", "pagedim-black"],
        navbar: {
            title: " "
        }
    }, {
        offCanvas: {
            page: {
                selector: "#page"
            }
        }
    });


    $(document).on("click", sidebarTrigger, e => {
            const api = $(sidebar).data("mmenu");

            if ($(sidebar).hasClass('mm-menu_opened')) api.close()
            else api.open()
        }
    )


};


up.compiler("#up-results", function () {
    setTimeout(function(){main()}, 100)

});
