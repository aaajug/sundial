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
        }
      });

    function handleDragStart(e) {
        this.style.opacity = '0.4';
        dragSrcEl = this;
      
        e.dataTransfer.effectAllowed = 'move';
        e.dataTransfer.setData('text/html', this.innerHTML);
        // e.dataTransfer.setData("height", this.offsetHeight + "px");
        // console.log(e.dataTransfer.getData("height"));
      }
      
      function handleDragEnd(e) {
        this.style.opacity = '1';
      
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
        console.log(e.path);

        // if(!dragSrcEl.classList.contains("task-card-container"))
        //   return false;

        this.style.height = (dragSrcEl.offsetHeight + 100) + "px";
        this.classList.add('over');
      }
      
      function handleDragLeave(e) {
        if(this.classList.contains("dropzone")) {
          this.style.height = "120px";
        } else {
          this.style.background = "transparent";
        }
        
        this.classList.remove('over');
      }
      
      function handleDrop(e) {      
        e.stopPropagation();
      
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

          hook.pushEventTo(selector, 'dropped', {
            list: list,
          });
        }
      
        dragSrcEl = null;
        return false;
      }    
  }
};