import { ColorStyle } from "./quill";

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

      if(content) {
        var unexpanded = content.classList.contains("truncated");
    
        $(".task-card").find(".content").addClass("truncated");
        $(".draggable-card").find(".flex").removeClass("highlighted");
        
        if(unexpanded) {
          content.classList.remove("truncated");
          flex_container.classList.add("highlighted");
        }
      }
    }

    function handleDragStart(e) {
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
        $(".dropzone").hide();

        document.querySelectorAll(".dropzone").forEach(function (item) {
          item.style.height = "50px";
        });

        var column = document.querySelector("#" + this.id).closest(".task-list");
        column.style.overflowY = "scroll";

        var dragged_card_column = dragSrcEl.dataset.task_status;
        var dropzone_card_column = this.dataset.column;

        if(dragged_card_column != dropzone_card_column){
          hook.pushEventTo(selector, 'move_column', {});
        }

        var dragged_card_index = dragSrcEl.dataset.card_index;
        var dropzone_card_index = this.dataset.card_index;


        if(dropzone_card_index == dragged_card_index || dropzone_card_index == dragged_card_index - 1)
          return false;
      
        if (dragSrcEl !== this) {
          dragged_task_id = dragSrcEl.dataset.task_id;                 // get task.id of the element being dragged (moved)
          dragged_task_index = dragSrcEl.dataset.task_index;           // get current task_index of the element being dragged (index before move)
                                                                       // hook --> socket will have the details of the task which acted as a dropzone
          /* dropzone insert */
          this.innerHTML = e.dataTransfer.getData('text/html');
          dragSrcEl.remove();

          var list = [];
            document.querySelectorAll(".task-card." + dragSrcEl.dataset.task_status + "-column").forEach((card) => {
            list.push(card.dataset.task_id);
          });

          hook.pushEventTo(selector, 'dropped', {
            list: list,
          });
        }

        dragSrcEl = null;
        return false;
      }    
  }
};