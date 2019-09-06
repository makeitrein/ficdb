const queryString = require('query-string');


const main = () => {

    const qsTrigger = "[data-qs]";

    $(document).on("click", qsTrigger, (e) => {
        const target = $(e.target);
        const qs = queryString.parse(location.search);
        const qsKey = $(target).data("qs");
        const qsValue = $(target).data("qs-value");
        qs[qsKey] = qsValue;
        const newQs = queryString.stringify(qs);
        up.visit(window.location.origin + window.location.pathname + "?" + newQs, {target: "#up-results", restoreScroll: true})
    });

};

$(() => main());








