const handleFileInputChange = function () {
    $('input[type="file"]').change(function () {
        $('.jq-avatar').attr('src', window.URL.createObjectURL(this.files[0]))
    });
}

up.compiler("main", function () {
    handleFileInputChange()
});