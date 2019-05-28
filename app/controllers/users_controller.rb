class UsersController < ApplicationController
    def follow
        user = User.new(name: params[:name])
        if user.save
            # TODO: 成功メッセージ投稿
        else
            # TODO: 失敗メッセージ投稿
        end
    end

    def remove
        user = User.find(params[:id])
        if user.destroy
            # TODO: 成功メッセージ投稿
        else
            # TODO: 失敗メッセージ投稿
        end
    end

    def get_problems
        User.initialize_user(5)
    end

    private
end
