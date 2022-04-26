export default {
  mounted() {
    const hook = this;
    var dragSrcEl;

    selector = "#" + hook.el.id;

    attachListeners(document.querySelectorAll(".dropzone"));
    attachListeners(document.querySelectorAll(".draggable-card"));

    function attachListeners(items) {
      items.forEach(function (item) {
        item.addEventListener('dragstart', handleDragStart);
        item.addEventListener('dragleave', handleDragLeave);
        item.addEventListener('dragend', handleDragEnd);
    
        if (item.dataset.kind == "dropzone") {
          item.addEventListener('dragover', handleDragOver);
          item.addEventListener('dragenter', handleDragEnter);
          item.addEventListener('drop', handleDrop);
        } else {
          item.addEventListener('click', handleClick);
        }
      });
    }

    function handleClick(e) {
      var content = this.querySelector(".content");
      var flex_container = this.querySelector(".flex");

      var unexpanded = true;

      if(content) {
        unexpanded = content.classList.contains("truncated");
      }
    
      $(".task-card").find(".content").addClass("truncated");
      $(".draggable-card").find(".flex").removeClass("highlighted");
        
      if(unexpanded) {
        if(content) {
          content.classList.remove("truncated");
        }
        flex_container.classList.add("highlighted");
      }
      
    }

    function handleDragStart(e) {
        $("html").css("overflow-y", "scroll");
        dragSrcEl = this;

        this.click();

        this.style.opacity = '0.4';

        var content = this.querySelector(".content");
        if (content)
          content.classList.add("truncated");

        $(".dropzone").show();
        $(".dropzone").css("z-index", 10);
      
        e.dataTransfer.effectAllowed = 'move';
        e.dataTransfer.setData('text/html', this.innerHTML);
    }
      
      function handleDragEnd(e) {
        // $("html").css("overflow-y", "hidden");
        this.style.opacity = '1';

        $(".dropzone").hide();

        document.querySelectorAll(".task-list").forEach(function (item) {
          item.style.overflowY = "scroll";
        });  

        document.querySelectorAll(".dropzone").forEach(function (item) {
          item.style.height = "50px";
        });

        dragSrcEl = null;
      }
      
      function handleDragOver(e) {
        if (e.preventDefault) {
          e.preventDefault();
        }
      
        return false;
      }
      
      function handleDragEnter(e) {
        var column = document.querySelector("#" + this.id).closest(".task-list");
        column.style.overflowY = "unset";

        var dragged_card_index = dragSrcEl.dataset.card_index;
        var dropzone_card_index = this.dataset.card_index;

        var dragged_card_column = dragSrcEl.dataset.task_status;
        var dropzone_card_column = this.dataset.column;

        if(dragged_card_column == dropzone_card_column)
          if(dropzone_card_index == dragged_card_index || dropzone_card_index == dragged_card_index - 1)
            return false;

        this.style.height = (dragSrcEl.offsetHeight + 80) + "px";
      }
      
      function handleDragLeave(e) {
        if(this.classList.contains("dropzone")) {
          this.style.height = "50px";
        } else {
          this.style.background = "transparent";
        }
      }
      
      function handleDrop(e) {      
        // $("html").css("overflow-y", "hidden");
        $(".dropzone").hide();

        document.querySelectorAll(".dropzone").forEach(function (item) {
          item.style.height = "50px";
        });

        // console.log(this.id);
        // var column = document.querySelector("#" + this.id).closest(".task-list");
        var column = this.closest(".task-list");
        column.style.overflowY = "scroll";

        var dragged_card_column = dragSrcEl.dataset.column;
        var dropzone_column = this.dataset.column;

        // console.log(dragged_card_column + " " + dropzone_column)

        // if(dragged_card_column != dropzone_card_column){
        //   console.log()
        //   // hook.pushEventTo(selector, 'move_column', {});
        // }

        // don't drop if same column AND card index
        var destination_column_id = this.closest(".list-column-component").dataset.column;
        var source_column_id = dragSrcEl.dataset.column;

        var dragged_card_index = dragSrcEl.dataset.card_index;
        var dropzone_card_index = this.dataset.card_index;

        if(destination_column_id == source_column_id)
          if(dropzone_card_index == dragged_card_index || dropzone_card_index == dragged_card_index - 1)
            return false;
      
        if (dragSrcEl !== this) {
          
          // var destination_column = document.querySelector(destination_column_id);
          console.log("destination list id:" + destination_column_id);

          dragged_task_id = dragSrcEl.dataset.task_id;                 // get task.id of the element being dragged (moved)
          dragged_task_index = dragSrcEl.dataset.task_index;           // get current task_index of the element being dragged (index before move)
                                                                       // hook --> socket will have the details of the task which acted as a dropzone
          /* dropzone insert */
          // this.innerHTML = e.dataTransfer.getData('text/html');
          // dragSrcEl.remove();

          // var destination_column_id = "#" + this.closest(".list-column-component").id;
          // var destination_column = document.querySelector(destination_column_id);
          // console.log(destination_column);

          var list = [];
          //".task-card." + dragSrcEl.dataset.task_status + "-column"
          // console.log(".task-card." + destination_column_id + "-column");

          document.querySelectorAll(".task-card.list-" + destination_column_id + "-column").forEach((card) => {
            list.push(card.dataset.task_id);
          });

          console.log(dragSrcEl.dataset.task_id + " to -> " + this.dataset.position + " of list ID#" + destination_column_id);

          hook.pushEventTo(selector, 'dropped', {
            // list: list,
            task_id: dragSrcEl.dataset.task_id,
            insert_index: this.dataset.position,
            list_id: destination_column_id
          });
        }

        dragSrcEl = null;
        return false;
      }    
  }
};