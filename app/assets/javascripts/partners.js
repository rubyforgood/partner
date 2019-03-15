$(document).on('turbolinks:load', function() {
    $('form').on('change', '#partner_agency_type', function(event) {
        console.log("I changed successfully");
        console.log($(this).val() == "Other");
        if($(this).val() === "Other") {
            $('#other_agency_input').show();
        } else {
            $('#other_agency_input').hide();
        }
        return false
    });
});
