$("main").ready(function() {
    function handleDragStart(e) {
        console.log("in handle drag start");
        this.style.opacity = '0.4';
      }
      
      function handleDragEnd(e) {
        console.log("in handle drag end");
        this.style.opacity = '1';
      }
      
      console.log("Enable drag-and-drop reorder for tasks -- index page");
      
      var items = document.querySelectorAll(".task-card");
      
      console.log("ITEMS: ");
      console.log(items);
      
      items.forEach(function (item) {
        console.log("event listener added");
        
        item.addEventListener('dragstart', handleDragStart);
        item.addEventListener('dragend', handleDragEnd);
      });
        
      console.log("EventListener added to each item");
});