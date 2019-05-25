class UsersController < ApplicationController
    def follow
        user = User.new(params.require(:user).permit(:name))
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
end
