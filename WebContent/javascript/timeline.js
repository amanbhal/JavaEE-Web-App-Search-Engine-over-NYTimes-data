$(document).ready(function () {
 
    // Open in new window
    $(".timeline-badge").click(function () {
        window.open($(this).find("a:first").attr("href"));
        return false;
    });
    
});