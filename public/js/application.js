$(document).ready(function() {
  $("#comment_submit2").submit(function(e){
    e.preventDefault();
    var data = $("#comment_submit2").serialize();
    var post_id_num = $("#comment_submit2").prop("postid").value
    $.ajax({
      url:"/comments/"+ post_id_num,
      type:"post",
      data: data,
      success:function(result){
      $("#comments").replaceWith(result);
    }});
  });
});
