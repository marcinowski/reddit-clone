module SubsHelper
  def all_subs
    @subs = Sub.pluck(:slug)
  end
end
