class AdminsController < ApplicationController
	before_filter :authenticate_admin, :only => [:home, :create_admin, :new ]
	before_filter :save_login_state, :only => [:login, :login_attempt]

	def home
		@cur_question = Question.where(:reviewed=>true, :asked => false).order(:created_at).first
	end

	def new
		@admin = Admin.new
	end

	def create_admin
		@admin = Admin.new(admin_params)

		if @admin.save
			flash[:notice] = "You signed up successfully"
      flash[:color]= "valid"
		else
			flash[:notice] = "Form is invalid"
      flash[:color]= "invalid"
		end

		render "new"
	
	end

	def login

	end

	def login_attempt
		authorized_admin = Admin.authenticate(params[:username_or_email],params[:login_password])
		if authorized_admin
			session[:admin_id] = authorized_admin.id
      flash[:notice] = "Wow Welcome again, you logged in as #{authorized_admin.username}"
      redirect_to(:controller => "admins", :action => 'home')
    else
      flash[:notice] = "Invalid Username or Password"
      flash[:color]= "invalid"
      render "login"	
    end
	end
	def logout
		session[:admin_id] = nil
		redirect_to :action => 'login'
	end

	private
		def admin_params
			params.require(:admin).permit(:username, :email, :password, :password_confirmation)
		end
end
