$(document).ready(function() {
  console.log("init scroll");
});

$(".scroll-edge-up").mouseover(function() {
  console.log("scroll up");
  $( ".task-list relative" ).scroll();
});

$(".scroll-edge-up").click(function() {
  console.log("scroll up");
  // $( ".task-list relative" ).scroll();
});