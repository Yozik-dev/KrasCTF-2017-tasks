$("#autocomplete-address").autocomplete({
    source: './search.php',
    minLength: 3,
    select: function (e, ui) {
        $("#autocomplete-address").val(ui.item.label).attr('data-id', ui.item.value);
        return false;
    }
}).on('change', function () {
    var id = $(this).attr('data-id');
    if (id) {
        $(this).css('border-color','green');
        $(this).attr('data-id', '');
    } else {
        alert('Несуществующий адрес!');
    }
});