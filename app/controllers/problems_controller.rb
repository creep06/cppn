class ProblemsController < ApplicationController
    def create
        problem = Problem.new(params)
        problem.save
    end

    def destroy
        problem = Problem.find(params[:id])
        problem.destroy
    end
end
