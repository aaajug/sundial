export const DeadlineCheckbox= {
  mounted() {
    const hook = this;
    deadline_disabled = $("#task-form_deadline").prop("disabled");
  }
};

export const CompletedOnCheckbox= {
  mounted() {
    const hook = this;
    completed_on_disabled = $("#task-form_completed_on").prop("disabled");
  }
};