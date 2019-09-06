const main = () => {

    const toggleTrigger = "[data-toggle]";

    $(document).on("click", toggleTrigger, function(e) {
        const target = $(this);
        e.preventDefault()
        e.stopPropagation()

        const toggleTarget = $(target).data("toggle");

        $(toggleTarget).toggle();
        $(toggleTarget).parent().find(".arrow").toggleClass('rotated');
    });

};

$(() => main());








