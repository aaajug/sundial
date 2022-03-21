$(document).ready(function() {
    $("#task_deadline_hour").prop("disabled", true);
    $("#task_deadline_minute").prop("disabled", true);
    $("#task_completed_on_hour").prop("disabled", true);
    $("#task_completed_on_minute").prop("disabled", true);
});

$(".disable-timestamp").change(function() {
    var target = "#" + $(this).data("target");

    if(this.checked) {
        $(target).prop("disabled", false);
        $(target + "_hour").prop("disabled", false);
        $(target + "_minute").prop("disabled", false);        
    } else {
        $(target).prop("disabled", true);  
        $(target + "_hour").prop("disabled", true);
        $(target + "_minute").prop("disabled", true);

        $(target + "_year").val("");        
        $(target + "_month").val("");        
        $(target + "_day").val("");        
        $(target + "_hour_field").val("");        
        $(target + "_minute_field").val("");
    }
});

$("#task_deadline").change(function() {
    var deadline_str = $(this).val();
    var deadline_date = new Date(deadline_str);

    $("#task_deadline_year").val(deadline_date.getFullYear());
    $("#task_deadline_month").val(deadline_date.getMonth() + 1);
    $("#task_deadline_day").val(deadline_date.getDate());
});

$("#task_deadline_hour").change(function() {
    $("#task_deadline_hour_field").val($(this).val());
});

$("#task_deadline_minute").change(function() {
    $("#task_deadline_minute_field").val($(this).val());
});

$("#task_completed_on").change(function() {
    var completed_on_str = $(this).val();
    var completed_on_date = new Date(completed_on_str);

    $("#task_completed_on_year").val(completed_on_date.getFullYear());
    $("#task_completed_on_month").val(completed_on_date.getMonth() + 1);
    $("#task_completed_on_day").val(completed_on_date.getDate());
});

$("#task_completed_on_hour").change(function() {
    $("#task_completed_on_hour_field").val($(this).val());
});

$("#task_completed_on_minute").change(function() {
    $("#task_completed_on_minute_field").val($(this).val());
});

$(".disable-timestamp").click(function() {

});
