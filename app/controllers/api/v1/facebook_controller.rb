module Api
  module V1
    class FacebookController < ApplicationController
      respond_to :json

      before_filter :authenticate_user!

      def upcoming_birthdays
      	til = params[:til] || 1.week.from_now
      	respond_with current_user.upcoming_birthdays(Time.at til.to_i)
      end

      def photos_together
        til = params[:til] || 1.week.from_now
        friends = current_user.upcoming_birthdays(Time.at til.to_i)

      	respond_with current_user.photos_together(friends)
      end

    end
  end
end
