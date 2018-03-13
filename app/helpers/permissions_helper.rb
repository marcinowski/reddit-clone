module PermissionsHelper
    actions = {
        # site wide important
        11 => 'add_superuser',
        12 => 'remove_superuser',

        101 => 'ban_login',
        102 => 'unban_login',
        111 => 'ban_user',
        112 => 'unban_user',
        121 => 'ban_add_subs',
        122 => 'unban_add_subs',
        131 => 'ban_comments',
        132 => 'unban_comments',
        141 => 'ban_posts',
        142 => 'unban_posts',
        # sub wide
        201 => 'add_moderator',
        202 => 'remove_moderator',

        301 => 'ban_from_sub',
        302 => 'unban_from_sub',
        311 => 'ban_comments_in_sub',
        312 => 'unban_comments_in_sub',
        321 => 'ban_posts_in_sub',
        322 => 'unban_posts_in_sub'
    }
end
