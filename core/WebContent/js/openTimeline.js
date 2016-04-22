$(".childNode").hide();

$(".parentNode").click(function(){
   $(".childNode").hide(100);
   $(this).children().show(100);
});