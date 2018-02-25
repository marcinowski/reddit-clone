@vote = (model, id, dir, element) ->
  $.post '/ratings/',
    'model': model,
    'id': id,
    'dir': dir
    (data) -> null # -> element

$ ->
  $(".rating-downvote").click (e) ->
    model = $(this).data("model")
    id = $(this).data("id")
    vote(model, id, -1, this)
  $(".rating-upvote").click (e) ->
    model = $(this).data("model")
    id = $(this).data("id")
    vote(model, id, 1, this)
