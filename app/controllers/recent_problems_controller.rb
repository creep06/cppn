class RecentProblemsController < ApplicationController
    def create
        problem = RecentProblem.new(params)
        problem.save
    end

    def destroy
        problem = RecentProblem.find(params[:id])
        problem.destroy
    end
end
