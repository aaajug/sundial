export const TimestampCheckbox = {
  mounted() {
    const selector = "#" + this.el.id;
    const selector_object = $(selector);

    $(document).ready(function() {
      deadline_disabled = $("#task_deadline").prop("disabled");
      completed_on_disabled = $("#task_completed_on").prop("disabled");
  
      // $("#task_completed_on").triggerHandler("change");/
      if($("#completed_on_checkbox").is(":checked")) {
          var completed_on_str = $("#task_completed_on").val();
          var completed_on_date = new Date(completed_on_str);
  
          $("#task_completed_on_year").val(completed_on_date.getFullYear());
          $("#task_completed_on_month").val(completed_on_date.getMonth() + 1);
          $("#task_completed_on_day").val(completed_on_date.getDate());
  
          var time = $("#task_completed_on_time").val().split(":");
          $("#task_completed_on_hour_field").val(time[0]);
          $("#task_completed_on_minute_field").val(time[1]);
      }
  
      if($("#deadline_checkbox").is(":checked")) {
          // $("#task_deadline").triggerHandler("change");
          var deadline_str = $("#task_deadline").val();
          var deadline_date = new Date(deadline_str);
  
          $("#task_deadline_year").val(deadline_date.getFullYear());
          $("#task_deadline_month").val(deadline_date.getMonth() + 1);
          $("#task_deadline_day").val(deadline_date.getDate());

          var time = $("#task_deadline_time").val().split(":");
          $("#task_deadline_hour_field").val(time[0]);
          $("#task_deadline_minute_field").val(time[1]);
      }
    });

    selector_object.change(function() {
      var target = "#" + $(this).data("target");
  
      if(this.checked) {
          var current_datetime = new Date();
  
          $(target).prop("disabled", false);
          $(target).val(current_datetime.getFullYear() + "-" + ('0' + (current_datetime.getMonth()+1)).slice(-2) + "-" + ('0' + (current_datetime.getDate())).slice(-2));

          $(target + "_time").prop("disabled", false);
          $(target + "_time").val(current_datetime.getHours() + ":" + current_datetime.getMinutes());
  
          $(target).change();
          $(target + "_time").change();

          if(target == "#task_completed_on") {
              $("#task_status").val(4);
          }
      } else {
          $(target).prop("disabled", true);  
  
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
  }
};

export const DeadlineTimeSelect = {
  mounted() {
    const selector = "#" + this.el.id;

    deadline_disabled = $(selector).data("checked");
    if(typeof deadline_disabled === 'undefined') 
      deadline_disabled = true;

    $("#task_deadline_hour").prop("disabled", deadline_disabled);
    $("#task_deadline_minute").prop("disabled", deadline_disabled);
    
    $("#task_deadline_time").change(function() {
      var new_time = $(this).val().split(":");
      
      $("#task_deadline_hour_field").val(new_time[0]);
      $("#task_deadline_minute_field").val(new_time[1]);

      var date = $("#task_deadline");
      var deadline_str = date.val();
      var deadline_date = new Date(deadline_str);

      $("#task_deadline_year").val(deadline_date.getFullYear());
      $("#task_deadline_month").val(deadline_date.getMonth() + 1);
      $("#task_deadline_day").val(deadline_date.getDate());
    });
  }
};

export const CompletedOnTimeSelect = {
  mounted() {
    const selector = "#" + this.el.id;

    completed_on_disabled = $(selector).data("checked");
    if(typeof completed_on_disabled === 'undefined') 
      completed_on_disabled = true;

    $("#task_completed_on_hour").prop("disabled", completed_on_disabled);
    $("#task_completed_on_minute").prop("disabled", completed_on_disabled);

    $("#task_completed_on_time").change(function() {
      var new_time = $(this).val().split(":");
      
      $("#task_completed_on_hour_field").val(new_time[0]);
      $("#task_completed_on_minute_field").val(new_time[1]);
  
      var date = $("#task_completed_on");
      var completed_on_str = date.val();
      var completed_on_date = new Date(completed_on_str);
  
      $("#task_completed_on_year").val(completed_on_date.getFullYear());
      $("#task_completed_on_month").val(completed_on_date.getMonth() + 1);
      $("#task_completed_on_day").val(completed_on_date.getDate());
    });
  }
};

export const StatusSelect = {
  mounted() {
    const selector = "#" + this.el.id;
    const selector_object = $(selector);

    selector_object.change(function() {
      if($(this).val() == 4) {
          $("#completed_on_checkbox").prop("checked", true).triggerHandler("change");
      } else {
          if($("#completed_on_checkbox").is(":checked")) {
              var selected = $(this).val();
              $("#completed_on_checkbox").prop("checked", false).triggerHandler("change");
              $(this).val(selected);
          }    
      }
    });    
  }
};

export const DeadlineDate = {
  mounted() {
    const selector = "#" + this.el.id;

    $(selector).change(function() {
      var deadline_str = $(this).val();
      var deadline_date = new Date(deadline_str);
  
      $("#task_deadline_year").val(deadline_date.getFullYear());
      $("#task_deadline_month").val(deadline_date.getMonth() + 1);
      $("#task_deadline_day").val(deadline_date.getDate());
  
      // $("#task_deadline_hour").triggerHandler("change");
      var hour = $("#task_deadline_hour");
      $("#task_deadline_hour_field").val(hour.val());
  
      // $("#task_deadline_minute").triggerHandler("change");
      var minute = $("#task_deadline_minute");
      $("#task_deadline_minute_field").val(minute.val());
    });
  }
};

export const CompletedOnDate = {
  mounted() {
    const selector = "#" + this.el.id;

    $(selector).change(function() {
      var completed_on_str = $(this).val();
      var completed_on_date = new Date(completed_on_str);
  
      $("#task_completed_on_year").val(completed_on_date.getFullYear());
      $("#task_completed_on_month").val(completed_on_date.getMonth() + 1);
      $("#task_completed_on_day").val(completed_on_date.getDate());
  
      // $("#task_completed_on_hour").triggerHandler("change");
      var hour = $("#task_completed_on_hour");
      $("#task_completed_on_hour_field").val(hour.val());
  
      // $("#task_completed_on_minute").triggerHandler("change");
      var minute = $("#task_completed_on_minute");
      $("#task_completed_on_minute_field").val(minute.val());
    });  
  }
};