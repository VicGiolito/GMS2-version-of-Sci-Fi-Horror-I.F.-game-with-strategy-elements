
function array_count(ar_to_check, val) {
    var count = 0;
    for (var i = 0; i < array_length(ar_to_check); i++) {
        if (ar_to_check[i] == val) {
            count++;
        }
    }
    return count;
}