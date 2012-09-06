module Api
  module V1
    class CelebrationsController < ApplicationController
      respond_to :json

      def index
      	til = params[:til] || 1.week.from_now
      	respond_with Celebration.upcoming(Time.at til.to_i)
      end

    end
  end
end
