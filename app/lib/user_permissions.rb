class UserPermissions
  include SessionsHelper
  # auth
  class << self
    def can_login? user
      user.user_permission.can_login
    end

    def ban_login user
      unless is_superuser?(current_user)
          return false
      end
      user.user_permission.update(can_login: false)
    end

    def unban_login user
      unless is_superuser?(current_user)
          return false
      end
      user.user_permission.update(can_login: true)
    end

    # admins
    def is_superuser? user
      user.user_permission.is_superuser
    end

    def add_superuser user
      unless is_superuser?(current_user)
          return false
      end
      user.user_permission.update(is_superuser: true)
    end

    def remove_superuser user
      unless is_superuser?(current_user)
          return false
      end
      user.user_permission.update(is_superuser: false)
    end

    def is_moderator? (user, sub)
      if is_superuser?(user)
          return true
      end
      !sub.sub_moderators.find_by(user: user).nil?
    end

    def add_moderator (user, sub)
      unless is_moderator?(current_user)
          return false
      end
      sub.sub_moderators.find_or_create_by(user: user)
    end

    def remove_moderator (user, sub)
      unless is_moderator?(current_user)
          return false
      end
      p = sub.sub_moderators.find_by(users: user)
      if p.nil?
        return true
      end
      p.destroy
    end

    # bans
    def is_user_banned? user
      user.user_permission.is_banned
    end

    def ban_user user
      unless is_superuser?(current_user)
          return false
      end
      user.user_permission.update(is_banned: true)
    end

    def unban_user user
      unless is_superuser?(current_user)
          return false
      end
      user.user_permission.update(is_banned: false)
    end

    def is_banned_from_sub? (user, sub)
      p = user.sub_bans.find_by(sub: sub)
      if p.nil?
        return false
      end
      p.is_banned
    end

    def ban_from_sub (user, sub)
      unless is_moderator?(current_user)
          return false
      end
      sub.sub_bans.find_or_create_by(user: user).update(is_banned: true)
    end

    def unban_from_sub (user, sub)
      unless is_moderator?(current_user)
          return false
      end
      p = sub.sub_bans.find_by(user: user)
      if p.nil?
        return true
      end
      return p.update(is_banned: false)
    end

    # ban subs
    def can_add_subs? user
      user.user_permission.can_sub
    end

    def ban_add_subs user
      unless is_moderator?(current_user)
          return false
      end
      user.user_permission.update(can_sub: false)
    end

    def unban_add_subs user
      unless is_moderator?(current_user)
          return false
      end
      user.user_permission.update(can_sub: true)
    end

    # ban comments
    def can_comment? user, sub
      unless user.user_permission.can_comment
        return false
      end
      return can_comment_in_sub?(user, sub)
    end

    def ban_comments user
      unless is_superuser?(current_user)
          return false
      end
      user.user_permission.update(can_comment: false)
    end

    def unban_comments user
      unless is_superuser?(current_user)
          return false
      end
      user.user_permission.update(can_comment: true)
    end

    def can_comment_in_sub? (user, sub)
      p = sub.sub_bans.find_by(user: user)
      if p.nil?
        return true
      end
      !p.cannot_comment
    end

    def ban_comments_in_sub (user, sub)
      unless is_moderator?(current_user)
          return false
      end
      user.sub_permissions.find_or_create_by(sub: sub).update(cannot_comment: true)
    end

    def unban_comments_in_sub (user, sub)
      unless is_moderator?(current_user)
          return false
      end
      p = sub.sub_bans.find_by(user: user)
      if p.nil?
        return true
      end
      p.update(cannot_comment: true)
    end

    # ban posts
    def can_post? user, sub
      unless user.user_permission.can_post
        return false
      end
      return can_post_in_sub?(user, sub)
    end

    def ban_posts user
      unless is_superuser?(current_user)
          return false
      end
      user.user_permission.update(can_post: false)
    end

    def unban_posts user
      unless is_superuser?(current_user)
          return false
      end
      user.user_permission.update(can_post: true)
    end

    def can_post_in_sub? (user, sub)
      p = sub.sub_bans.find_by(user: user)
      if p.nil?
        return true
      end
      !p.cannot_post
    end

    def ban_posts_in_sub (user, sub)
      unless is_moderator?(current_user)
          return false
      end
      user.sub_permissions.find_or_create_by(sub: sub).update(cannot_post: true)
    end

    def unban_posts_in_sub (user, sub)
      unless is_moderator?(current_user)
          return false
      end
      p = sub.sub_bans.find_by(user: user)
      if p.nil?
        return true
      end
      user.sub_permissions.find_or_create_by(sub: sub).update(cannot_post: false)
    end
  end
end
