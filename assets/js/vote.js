
    up.on('ajax:success', function(e) {
        const $target = $(e.target);
        if ($target.data("vote")) {
            const $voteCount = $target.find("[data-vote-count]");
            $target.removeClass("bg-purple-light")
            $target.addClass("bg-red-light")
            const votes = parseInt($voteCount.text() || 0, 10) + 1;
            $voteCount.html(votes);
        }
    });


    up.on('ajax:success', function(e) {
        const $target = $(e.target);
        if ($target.data("reviewForm")) {
            if (!location.href.includes("fanfics")) {
                $target.replaceWith( `<a href="fanfics/${$target.data("fanfic")}" class="bg-indigo-darkest no-underline text-center py-4 block lg:px-4">
                    <span class=\"p-2 bg-indigo-darker items-center text-indigo-lightest leading-none lg:rounded-full flex lg:inline-flex\" role=\"alert\"> 
                      <span class=\"flex rounded-full bg-indigo uppercase px-2 py-1 text-xs font-bold mr-3\">Yay</span>
                      <span class=\"font-semibold mr-2 text-left flex-auto\">Review successful! Click to view fanfic</span>
                      <svg class=\"fill-current opacity-75 h-4 w-4\" xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 20 20\"><path d=\"M12.95 10.707l.707-.707L8 4.343 6.586 5.757 10.828 10l-4.242 4.243L8 15.657l4.95-4.95z\"/></svg>
                    </span>
                    </a>` );
                $("#result-item-" + $target.data("fanfic")).find(".add-review-button").addClass("font-bold").text("Review Successful")
            }
            else location.reload(); // if we're on the fanfic page, just reload to show the review
        }
    });

    up.on('ajax:success', function(e) {
        const $target = $(e.target);
        if ($target.data("bookshelf")) {

            alert("Successfully added to bookshelf!")
        }
    });

    up.on('ajax:success', function(e) {
        const response = e.originalEvent.data.xhr.responseText;
        if (response.includes("_bookshelf")) { // e.g. delete_bookshelf
            $(e.target).parent().children().removeClass("active-bookshelf");
            if (response !== "delete_bookshelf") {
                $(e.target).addClass("active-bookshelf");
                $(e.target).parents(".result-item").find(".add-to-bookshelf").text("Bookshelf Updated!")
            }
        }
    });