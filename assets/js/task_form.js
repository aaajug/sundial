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
