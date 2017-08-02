class QuestionsController < ApplicationController
  def new
    @question = Question.new
  end

  def create
    return if authenticate!(current_user)
    @question = Question.new(question_params)
    if @question.save
      render json: @question
    else
      render json: {
        error: "Invalid input - please try again."
      }, status: 422
    end
  end

  def show
    return if authenticate!(current_user)
    @question = Question.find_by(id: params[:id])
    render json: @question
  end

  def update
    return if authenticate!(current_user)
    @question = Question.find_by(id: params[:id])
    @question.update_attributes(question_params)
    if @question.save
      render json: @question
    else
      render json: {
        error: "Invalid input - please try again."
      }, status: 422
    end
  end

  def destroy
    return if authenticate!(current_user)
    @question = Question.find_by(id: params[:id])
    @question.destroy
  end

  private
  def question_params
    params.require(:question).permit(:quest_id, :question_text, :answer, :hint, :clue_type, :clue_text, :clue_image, :lat, :lng)
  end
end
