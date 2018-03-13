class PermissionsController < ApplicationController
    include PermissionsHelper
    def action
        action = permission_actions[params[:action]]
        user = User.find(params[:user])
        sub = Sub.find(params[:sub])
        UserPermissons.send(action, user, sub)
    end
end
