import Noty from 'noty';


const main = () => {
  $(".jquery-stars-input").each(function (el) {
    $(this).starRating({
      totalStars: 5,
      initialRating: $(this).data("stars"),
      starShape: 'rounded',
      useFullStars: true,
      starSize: 15,
      useGradient: false,
      disableAfterRate: false,
      callback: function (currentRating, $el) {
        const tooltip = $el.parents("[data-tippy-content]");
        if (tooltip) {
          tooltip.show();
            const rating = $el.siblings(".jquery-rating");
            setTimeout(() => rating.val(currentRating), 200);
        }

        if (currentRating === 1 || currentRating === 2) {
            const n = new Noty({
                text: 'Heads up! ' +
                    'Ficdb is anti-fanfic-bashing! To that end, 1 and 2 stars reviews need some constructive & respectful criticism backing it up!',
                layout: 'center',
                type: 'info',
                buttons: [
                    Noty.button('I Understand!', 'button', function () {
                        console.log('button 2 clicked');
                        n.close();
                    })
                ]
            }).show();
        }
      }
    });
  });

  $(document).on("click", ".open-review-form", (e) => $(e.target).siblings(".review-form").addClass("visible"));
  $(".close-review-form").click((e) => $(e.target).parents(".review-form").removeClass("visible"));

  $(".jquery-stars").each(function (el) {
    $(this).starRating({
      totalStars: 5,
      initialRating: $(this).data("stars"),
      starShape: 'rounded',
      starSize: 15,
      useGradient: false,
      readOnly: true
    });
  })
}

up.compiler(".jquery-stars", function() {
  main()
});

export default main;
