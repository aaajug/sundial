export const TimestampCheckbox = {
  mounted() {
    const selector = "#" + this.el.id;
    const selector_object = $(selector);

    selector_object.change(function() {
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
  }
};