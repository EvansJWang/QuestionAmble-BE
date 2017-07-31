class RoundsController < ApplicationController
  def new
    @round = Round.new
  end

  def create
    @quest = Quest.find_by(key: params[:round][:game_key])
    @round = Round.new(quest_id: @quest.id, player_id: params[:round][:player_id])

    if (@round.save)
      render json: @round
    else
      render json: {
        error: "Invalid input - please try again."
      }, status: 422
    end
  end

  def next_question
    @round = Round.find_by(id: params[:id])
    round_questions = @round.quest.questions

    if @round.guesses.length == 0
      @next_question = round_questions[0]
    else
      current_question = Question.find_by(id: @round.guesses.last.question_id)
      current_position = round_questions.index(current_question)
      next_question_position = current_position + 1
      @next_question = round_questions[next_question_position]
    end

    if @next_question  == nil
      render json: {message: "game complete"}
    else
      render json: @next_question
    end
  end

  def compare_location
    questions_match = Question.within(0.03, :origin[params[:player_lat], params[:player_lng]])
    target = questions_match.select {|q| q.id == params[:cur_question_id]}

    if target.length == 0
      render json: {clue: "not found"}
    else
      render json: {clue: "found"}
    end
  end

  def show
    @round = Round.find_by(id: params[:id])
    render json: @round
  end

  private
  def round_params
    params.require(:round).permit(:game_key, :player_id)
  end
end
