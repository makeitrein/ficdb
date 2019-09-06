var UJS = require("phoenix_ujs");


const main = () => {

    const scrapeTrigger = "[data-crawl-fanfic]";

    $(document).on("click", scrapeTrigger, function (e) {
        const scraper = $(this);

        const host = scraper.data("host");
        const id = scraper.prev().val();
        UJS.xhr(`/crawl/${host}/${id}`, "POST", {
            success: function (xhr) {
                $.each(JSON.parse(xhr.response), function (name, val) {
                    const $el = $('#fanfic_' + name),
                        type = $el.attr('type');

                    if ($el[0].selectize) {
                        $el[0].selectize.setValue(val)
                    }
                    else {
                        switch (type) {
                            case 'checkbox':
                                $el.attr('checked', 'checked');
                                break;
                            case 'radio':
                                $el.filter('[value="' + val + '"]').attr('checked', 'checked');
                                break;
                            case 'select':
                                debugger
                                $el.filter('[value="' + val + '"]').attr('checked', 'checked');
                                break;

                            default:
                                $el.val(val);
                        }
                    }
                });

            }
        });
    });

};

$(() => main());