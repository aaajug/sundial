$(document).ready(function() {
    deadline_disabled = $("#task_deadline").prop("disabled")
    completed_on_disabled = $("#task_completed_on").prop("disabled")
    
    $("#task_deadline_hour").prop("disabled", deadline_disabled);
    $("#task_deadline_minute").prop("disabled", deadline_disabled);
    $("#task_completed_on_hour").prop("disabled", completed_on_disabled);
    $("#task_completed_on_minute").prop("disabled", completed_on_disabled);
});

$(".disable-timestamp").change(function() {
    var target = "#" + $(this).data("target");

    if(this.checked) {
        var current_datetime = new Date();

        $(target).prop("disabled", false);
        $(target).val(current_datetime.getFullYear() + "-" + ('0' + (current_datetime.getMonth()+1)).slice(-2) + "-" + ('0' + (current_datetime.getDate())).slice(-2));

        $(target + "_hour").prop("disabled", false);
        $(target + "_hour").val(current_datetime.getHours())

        $(target + "_minute").prop("disabled", false);        
        $(target + "_minute").val(current_datetime.getMinutes())

        $(target).change();
        $(target + "_hour").change();
        $(target + "_minute").change();

        if(target == "#task_completed_on") {
            $("#task_status").val(4);
        }
    } else {
        $(target).prop("disabled", true);  
        $(target + "_hour").prop("disabled", true);
        $(target + "_minute").prop("disabled", true);

        $(target + "_year").val("");        
        $(target + "_month").val("");        
        $(target + "_day").val("");        
        $(target + "_hour_field").val("");        
        $(target + "_minute_field").val("");

        if(target == "#task_completed_on") {
            $("#task_status").val(1);
        }
    }
});

$("#task_status").change(function() {
    if($(this).val() == 4) {
        $("#completed_on_checkbox").prop("checked", true).triggerHandler("change");
    } else {
        $("#completed_on_checkbox").prop("checked", false).triggerHandler("change");
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