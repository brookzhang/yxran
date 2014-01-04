$(".js-handover-store").bind("click",function(){
    $("#handover_store_id").val($(this).data("store-id"));
    $("form").submit();
  });