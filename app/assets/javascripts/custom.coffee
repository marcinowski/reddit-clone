@vote = (model, id, dir) ->
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
      return true

@countVote = (element, dir) ->
    $element = $(element)
    $parent = $element.parent()
    score = $parent.children('.rating-score')
    s = parseInt(score.text())
    ###
    +---+---+---+---+
    |   | 0 | 1 |-1 |
    +---+---+---+---+
    | 1 | 1 | 0 | 1 |
    +---+---+---+---+
    |-1 |-1 |-1 | 0 |
    +---+---+---+---+
    ###
    if dir == s # unvoted
      $element.removeClass('rating-highlight')
      dir = 0
    else if dir == -1
      $element.addClass('rating-highlight')
      $parent.children('.rating-upvote').removeClass('rating-highlight')
    else
      $element.addClass('rating-highlight')
      $parent.children('.rating-downvote').removeClass('rating-highlight')
    score.text(dir)
    vote($element.data("model"), $element.data("id"), dir)

$ ->
  $(".rating-downvote").click (e) ->
    countVote(this, -1)

  $(".rating-upvote").click (e) ->
    countVote(this, 1)
