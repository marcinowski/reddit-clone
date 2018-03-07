module SubsHelper
  def all_subs
    limit = 20
    selected_subs = []
    unless current_user.nil?
      selected_subs = current_user.sub_subscriptions.limit(limit).pluck(:sub_id)
      subs = Sub.find(selected_subs)
    end
    other_limit = limit - selected_subs.count
    subs += Sub.where.not(id: selected_subs).limit(other_limit)
    return subs.pluck(:slug)
  end

  def is_user_subscribed_to_sub? (sub, user)
    sub.sub_subscriptions.where(user: user).exists?
  end

  def count_subscribers (sub)
    sub.sub_subscriptions.count
  end
end
