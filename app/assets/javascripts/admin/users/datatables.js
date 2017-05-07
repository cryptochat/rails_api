jQuery(document).ready(function() {
    var table = $('#UsersDataTables');
    table.dataTable({
        "processing": true,
        "serverSide": true,
        "ajax": table.data('source'),
        "pagingType": "full_numbers"
    });
});
