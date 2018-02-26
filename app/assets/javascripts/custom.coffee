@vote = (model, id, dir, element, sibling) ->
  $.post
    url: '/ratings/',
    type: 'POST',
    headers: {
      'X-Transaction': 'POST Example',
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    },
    data: {
      'model': model,
      'id': id,
      'dir': dir
    },
    error: (jqXHR, textStatus, errorThrown) ->
      console.log(textStatus);
    success: (data, textStatus, jqXHR) ->
      $(element).toggleClass('rating-highlight')
      $(sibling).removeClass('rating-highlight')
      score = $(element).siblings('.rating-score')
      s = parseInt(score.text());
      score.text(s+dir);

$ ->
  $(".rating-downvote").click (e) ->
    model = $(this).data("model")
    id = $(this).data("id")
    sibling = $(this).siblings('.rating-upvote')
    vote(model, id, -1, this, sibling)
  $(".rating-upvote").click (e) ->
    model = $(this).data("model")
    id = $(this).data("id")
    sibling = $(this).siblings('.rating-downvote')
    vote(model, id, 1, this, sibling)
