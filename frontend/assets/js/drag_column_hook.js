export default {
  mounted() {
    const hook = this;
    var dragSrcEl;

    selector = "#" + hook.el.id;

    attachListeners(document.querySelectorAll(".dropzone-column"));
    attachListeners(document.querySelectorAll(".list-column-container"));

    function attachListeners(items) {
      items.forEach(function (item) {
        item.addEventListener('dragstart', handleDragColumnStart);
        item.addEventListener('dragleave', handleDragColumnLeave);
        item.addEventListener('dragend', handleDragColumnEnd);
    
        if (item.dataset.kind == "dropzone") {
          item.addEventListener('dragover', handleDragColumnOver);
          item.addEventListener('dragenter', handleDragColumnEnter);
          item.addEventListener('drop', handleDropColumn);
        }
      });
    }

    function handleDragColumnStart(e) {
        dragSrcEl = this;
        this.style.opacity = '0.4';

        $(".dropzone-column").show();
        $(".dropzone-column").css("z-index", 10);
      
        e.dataTransfer.effectAllowed = 'move';
        e.dataTransfer.setData('text/html', this.innerHTML);
    }
      
      function handleDragColumnEnd(e) {
        this.style.opacity = '1';

        $(".dropzone-column").hide();

        document.querySelectorAll(".dropzone-column").forEach(function (item) {
          item.style.width = "40px";
        });

        dragSrcEl = null;
      }
      
      function handleDragColumnOver(e) {
        if (e.preventDefault) {
          e.preventDefault();
        }

        return false;
      }
      
      function handleDragColumnEnter(e) {
        console.log("enter.");
        // var column = document.querySelector("#" + this.id).closest(".task-list");
        // column.style.overflowY = "unset";

        var dragged_column_index = dragSrcEl.dataset.index;
        var target_dropzone_index = this.dataset.index;

        if(dragged_column_index == target_dropzone_index || dragged_column_index == target_dropzone_index - 1)
          return false;

        this.style.width = (dragSrcEl.offsetWidth+ 80) + "px";
      }
      
      function handleDragColumnLeave(e) {
        if(this.classList.contains("dropzone")) {
          this.style.width = "40px";
        } else {
          this.style.background = "transparent";
        }
      }
      
      function handleDropColumn(e) {      
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

          // hook.pushEventTo(selector, 'dropped', {
          //   // list: list,
          //   task_id: dragSrcEl.dataset.task_id,
          //   insert_index: this.dataset.position,
          //   list_id: destination_column_id
          // });
        }

        dragSrcEl = null;
        return false;
      }    
  }
};