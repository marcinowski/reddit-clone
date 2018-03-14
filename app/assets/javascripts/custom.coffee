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

@countVote = (element, dir, opposite) ->
    model = $(element).data("model")
    id = $(element).data("id")
    sibling = $(element).siblings(opposite)
    score = $(element).siblings('.rating-score')
    s = parseInt(score.text())
    if sibling.hasClass('rating-highlight')
      score.text(s+2*dir)
    else if $(element).hasClass('rating-highlight')
      score.text(s-1*dir)
    else  # unvoted
      score.text(s+1*dir)
    vote(model, id, dir, element, sibling)

$ ->
  $(".rating-downvote").click (e) ->
    countVote(this, -1, '.rating-upvote')

  $(".rating-upvote").click (e) ->
    countVote(this, 1, '.rating-downvote')
