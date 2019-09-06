var UJS = require("phoenix_ujs");


const main = () => {

    const scrapeTrigger = "[data-crawl-fandom]";

    $(document).on("click", scrapeTrigger, function (e) {
        const scraper = $(this);

        const url = scraper.prev().val();

        UJS.xhr(`/crawl/fandom`, "POST", {
            type: 'json', // the request's payload
            data: {url: url}, // the request's payload

            success: function (xhr) {
                debugger
                const characters = JSON.parse(xhr.response).join("\n");
                const $textarea = $(`#fandom_characters_bulk`);
                $textarea.val($textarea.val() + "\n" + characters)

            }
        });
    });

};

$(() => main());

