export const AddSharedUserField = {
  mounted() {
    $(".add-user-field").click(function() {
      var new_field_id = $(this).data("next");
      $(this).data("next", parseInt(new_field_id + 1));
      
      var new_field = `
      <div class="field is-horizontal" id="user_`+new_field_id+`-container">
        <div class="field-body">
          <div class="field">
            <input id="user_`+new_field_id+`-email" name="board[pemrissions][user_`+new_field_id+`][email]" placeholder="alice@wonderland.com" style="background-color: white;">
          </div>
          <div class="field">
            <select id="user_`+new_field_id+`-role" name="board[pemrissions][user_`+new_field_id+`][role]" style="background-color: white;">
              <option value="" disabled selected>select role</option>
              <option value="manager">manager</option>
              <option value="contributor">contributor</option>
              <option value="member">member</option>
            </select>
          </div>
          <div class="field" style="display: flex; align-items: center;">
            <span class="icon-text has-text-danger remove-user-field" id="remove-user-field-`+new_field_id+`" data-tag="`+new_field_id+`" style="cursor: pointer;">
              <span class="icon">
                <ion-icon name="remove-circle"></ion-icon>
              </span>
              <span>remove</span>
            </span>
          </div> 
        </div>
      </div>`;

      $("#board_users_container").append(new_field);
    });
  }
};

export const RemoveSharedUserField = {
  mounted() {
    $(".remove-user-field").click(function(e) {
      var tag = $(this).data("tag");
      console.log("remove field with tag " + tag);

      $("#user_"+tag+"-email").val("");
      // $("#user_"+tag+"-container").hide();
    });
  }
};