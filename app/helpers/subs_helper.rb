module SubsHelper
  def all_subs
    @subs = Sub.pluck(:slug)
  end

  def is_user_subscribed_to_sub? (sub, user)
    SubSubscription.where(user_id: user, sub_id: sub).exists?
  end

  def count_subscribers (sub)
    SubSubscription.where(sub_id: sub).count
  end
end
