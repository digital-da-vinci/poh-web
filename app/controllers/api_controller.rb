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
		q = Question.where(:asked => false, :reviewed => true).order(:created_at).first

		render :json => q.to_json
	end

	def get_results
		q = nil
		if params[:question_id] =~ /-1/
			q = Question.where(:asked => true).order("created_at DESC").first
		else
			q = Question.find(params[:question_id])
		end

		render :json => { 
				:yes_count => q.yes_count,
				:no_count => q.no_count,
				:total => (q.yes_count + q.no_count),
				:question => q.question
			}
	end
end
