import star from './star-rating'
const main = () => {
    tippy.setDefaults({
        arrow: true,
        arrowType: 'round',
        animation:"fade",
        theme: "honeybee",
        onShown: function() {
            star();
        }
    })

    tippy('[data-tippy-content]')
}

up.compiler("main", function() {
    main();
    tippy.hideAllPoppers()
});

up.compiler("#up-results", function() {
    main();
});
