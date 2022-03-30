export default {
  mounted() {
    const hook = this;

    const selector = '#' + this.el.id;
    var items = document.querySelectorAll(selector);

    // if($(".task-card-component").data("drag_hook") == "Drag") {
      items.forEach(function (item) {
        item.addEventListener('dragstart', handleDragStart);
        item.addEventListener('dragover', handleDragOver);
        item.addEventListener('dragenter', handleDragEnter);
        item.addEventListener('dragleave', handleDragLeave);
        item.addEventListener('dragend', handleDragEnd);
        item.addEventListener('drop', handleDrop);
      });
    // }

    function handleDragStart(e) {
        console.log("handle drag start");
        this.style.opacity = '0.4';
        dragSrcEl = this;
      
        e.dataTransfer.effectAllowed = 'move';
        e.dataTransfer.setData('text/html', this.innerHTML);
      }
      
      function handleDragEnd(e) {
        this.style.opacity = '1';
      
        items.forEach(function (item) {
          item.classList.remove('over');
        });
      }
      
      function handleDragOver(e) {
        this.style.background = "gray";

        if (e.preventDefault) {
          e.preventDefault();
        }
      
        return false;
      }
      
      function handleDragEnter(e) {
        this.classList.add('over');
      }
      
      function handleDragLeave(e) {
        this.style.background = "transparent";

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
          var new_task_component = document.createElement("div");
          new_task_component.innerHTML = e.dataTransfer.getData('text/html'); 
          dragSrcEl.remove();
          this.append(new_task_component)
          /* end: simulate insert */


          var list = [];
          // document.querySelectorAll("." + this.dataset.task_status + "-column-task-card > .flex > .task-card" ).forEach((card) => {
          document.querySelectorAll("." + this.dataset.task_status + ".task-card").forEach((card) => {
            list.push(card.dataset.task_id);
          });
          
          hook.pushEventTo(selector, 'dropped', {
            list: list,
          });
        }
      
        return false;
      }    
  }
};