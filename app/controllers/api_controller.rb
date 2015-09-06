class ApiController < ApplicationController
	skip_before_filter :verify_authenticity_token, :only => [:post_answer, :get_question]

	def post_answer
		puts params
		q = Question.find(params[:question_id])
		
		if(params[:answer] =~ /yes/)
			q.yes_count += 1
		elsif params[:answer] =~ /no/
			q.no_count += 1
		end

		q.save

		render :json => { :status => "success" }
	end

	def get_question
		q = Question.where(:asked => false).order(:created_at).first

		render :json => q.to_json
	end
end
