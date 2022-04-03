export default {
  mounted() {
    const hook = this;

    const selector = '#' + this.el.id;
    var items = document.querySelectorAll(selector);

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

      // $(".task-card").click(function() {
      //   // console.log("task card clicked");
      
      //   var unexpanded = $(this).find(".content").hasClass("truncated");
      //   console.log("unexpanded: " + unexpanded);
      
      
      //   $(".task-card").find(".content").addClass("truncated");
      
      //   if(unexpanded)
      //     $(this).find(".content").removeClass("truncated");
      
      // });

    function handleClick(e) {
      var content = this.querySelector(".content");

      if(content) {
        var unexpanded = content.classList.contains("truncated");
    
        $(".task-card").find(".content").addClass("truncated");
        
        // console.log("unexpanded: " + unexpanded);
        if(unexpanded)
          content.classList.remove("truncated");
      }
    }

    function handleDragStart(e) {
        dragSrcEl = this;

        this.style.opacity = '0.4';

        var content = this.querySelector(".content");
        if (content)
          content.classList.add("truncated");

        $(".dropzone").show();
        $(".dropzone").css("z-index", 10);

        // var column = document.querySelector("#" + this.id).closest(".task-list");
        // column.style.overflowY = "unset";

      
        e.dataTransfer.effectAllowed = 'move';
        e.dataTransfer.setData('text/html', this.innerHTML);
        // e.dataTransfer.setData("height", this.offsetHeight + "px");
        // console.log(e.dataTransfer.getData("height"));
      }
      
      function handleDragEnd(e) {
        this.style.opacity = '1';

        $(".dropzone").hide();

        var object = document.querySelector("#" + this.id);
        
        if(column) {
          var column = object.closest(".task-list");
          column.style.overflowY = "scroll";
        }

        document.querySelectorAll(".dropzone").forEach(function (item) {
          item.style.height = "50px";
        });
      
        items.forEach(function (item) {
          item.classList.remove('over');
        });

        dragSrcEl = null;
      }
      
      function handleDragOver(e) {
        // this.style.background = "gray";

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

        if(dropzone_card_index == dragged_card_index || dropzone_card_index == dragged_card_index - 1)
          return false;

        this.style.height = (dragSrcEl.offsetHeight + 80) + "px";
        // this.classList.add('over');
      }
      
      function handleDragLeave(e) {
        // this.style.background = "pink";
        if(this.classList.contains("dropzone")) {
          this.style.height = "50px";
        } else {
          this.style.background = "transparent";
        }
        
        // this.classList.remove('over');
      }
      
      function handleDrop(e) {      
        e.stopPropagation();

        $(".dropzone").hide();

        document.querySelectorAll(".dropzone").forEach(function (item) {
          item.style.height = "50px";
        });

        var column = document.querySelector("#" + this.id).closest(".task-list");
        column.style.overflowY = "scroll";

        var dragged_card_index = dragSrcEl.dataset.card_index;
        var dropzone_card_index = this.dataset.card_index;

        if(dropzone_card_index == dragged_card_index || dropzone_card_index == dragged_card_index - 1)
          return false;
      
        if (dragSrcEl !== this) {
          dragged_task_id = dragSrcEl.dataset.task_id;                 // get task.id of the element being dragged (moved)
          dragged_task_index = dragSrcEl.dataset.task_index;           // get current task_index of the element being dragged (index before move)
                                                                       // hook --> socket will have the details of the task which acted as a dropzone

          /* start: simulates a swap rather than an insert */                                                             
          // dragSrcEl.innerHTML = this.innerHTML;                          // dragged_element <--- dropzone_element
          // this.innerHTML = e.dataTransfer.getData('text/html');          // dropzone_element <--- dragged_element
          /* end: simulates a swap rather than an insert */  

          /* start: simulate insert */
          // var new_task_component = document.createElement("div");
          // new_task_component.innerHTML = e.dataTransfer.getData('text/html'); 
          // dragSrcEl.remove();
          // this.append(new_task_component)
          /* end: simulate insert */

          /* dropzone insert */
          this.innerHTML = e.dataTransfer.getData('text/html');
          dragSrcEl.remove();


          var list = [];
            document.querySelectorAll(".task-card." + dragSrcEl.dataset.task_status + "-column").forEach((card) => {
            list.push(card.dataset.task_id);
          });

          // console.log(list);
          hook.pushEventTo(selector, 'dropped', {
            list: list,
          });
        }
      
        dragSrcEl = null;
        return false;
      }    
  }
};