import Noty from 'noty';



up.on('ajax:success', function(e) {
    const $target = $(e.target);
    if ($target.data("approve")) {
        new Noty({
            text: 'Approved! Refresh to see changes...',
            timeout: 1000,

        }).show();
    } else if ($target.data("unapprove")) {
        new Noty({
            text: 'Unapproved! Refresh to see changes...',
            timeout: 1000,
        }).show();
    } else if ($target.data("reject")) {
        new Noty({
            text: 'Rejected! Refresh to see changes...',
            timeout: 1000,
        }).show();
    }
    else if ($target.data("unreject")) {
        new Noty({
            text: 'Unrejected! Refresh to see changes...',
            timeout: 1000,
        }).show();
    }
});
