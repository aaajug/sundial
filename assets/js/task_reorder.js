// function handleDragStart(e) {
//   this.style.opacity = '0.4';
//   // this.style.border = 'yellow';

//   dragSrcEl = this;

//   e.dataTransfer.effectAllowed = 'move';
//   e.dataTransfer.setData('text/html', this.innerHTML);
// }

// function handleDragEnd(e) {
//   // this.style.background = 'green';

//   this.style.opacity = '1';

//   items.forEach(function (item) {
//     item.classList.remove('over');
//   });
// }

// function handleDragOver(e) {
//   // this.style.background = 'white';

//   if (e.preventDefault) {
//     e.preventDefault();
//   }

//   return false;
// }

// function handleDragEnter(e) {
//   // this.style.background = 'red';

//   this.classList.add('over');
// }

// function handleDragLeave(e) {
//   // this.style.background = 'orange';
//   this.style.opacity = '1';
//   this.classList.remove('over');
// }

// function handleDrop(e) {
//   // this.style.background = 'pink';
//   // console.log("this: " + this.innerHTML); // dropzone html

//   e.stopPropagation();

//   if (dragSrcEl !== this) {
//     /* start: will simulate a swap rather than an insert */
//     // dragSrcEl.innerHTML = this.innerHTML;                          dragged_element <--- dropzone_element
//     // this.innerHTML = e.dataTransfer.getData('text/html');          dropzone_element <--- dragged_element
//     /* end: will simulate a swap rather than an insert */

     
//     // this.append(dragSrcEl.innerHTML);
//     // var new_node = <div class="task-card-component"></div>
//     // dragSrcEl.innerHTML = "";   

//     // or catch event thru a phx hook
//     // hook.pushEventTo(selector, 'dropped', {

//     //   draggedId: e.item.id, // id of the dragged item
  
//     //   dropzoneId: e.to.id, // id of the drop zone where the drop occured
  
//     //   draggableIndex: e.newDraggableIndex, // index where the item was dropped (relative to other items in the drop zone)
  
//     // });
//   }

//   return false;
// }

// var items = document.querySelectorAll(".task-card-component");

// items.forEach(function (item) {
//   item.addEventListener('dragstart', handleDragStart);
//   item.addEventListener('dragover', handleDragOver);
//   item.addEventListener('dragenter', handleDragEnter);
//   item.addEventListener('dragleave', handleDragLeave);
//   item.addEventListener('dragend', handleDragEnd);
//   item.addEventListener('drop', handleDrop);
// });

// $(".task-card-component").click(function() {
//   console.log("pushing event...");
//   this.pushEvent("#phx-FuCKVIlDly0CaiFl-1-0", "dropped", {id: "1", target: "2"});
//   console.log("pushed.");
// });

document.querySelectorAll('.dropzone').forEach((dropzone) => {
  
    });











    document.querySelectorAll('.dropzone').forEach((dropzone) => {
      new Sortable(dropzone, {
        animation: 0,
        delay: 50,
        delayOnTouchOnly: true,
        group: 'shared',
        draggable: '.draggable',
        ghostClass: 'sortable-ghost',
        onEnd: function (evt) {
          hook.pushEventTo(selector, 'dropped', {
            draggedId: evt.item.id,
            dropzoneId: evt.to.id,
            draggableIndex: evt.newDraggableIndex,
          });
        },
      });
    });