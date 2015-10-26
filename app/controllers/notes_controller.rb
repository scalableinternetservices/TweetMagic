class NotesController < ApplicationController
  before_action :authenticate_user!, :except => [:show]
  #respond_to :html, :js

  def index
    @notes = current_user.notes.paginate(page: params[:page])
  end

  def new
  end

  def create
  	 @note = current_user.notes.build(note_params)
    if @note.save
      #flash.now[:success] = "Nice one!"
      #flash.keep(:success)
      #redirect_to root_url
      #render :js => "window.location = '#{note_path(@note)}"
      respond_to do |format|
        format.html {render nothing: true, status: 200} 
        format.json {render nothing: true, status: 200} 
      end
    
    else
      #flash.now[:alert] = "Oops! Say something before submitting."
      #flash.keep(:alert)
      respond_to do |format|
        format.html {render nothing: false, status: 400} 
        format.json {render nothing: false, status: 400}
      end
    end
  end

  def update
    
    @note = Note.find(params[:id])
    if(params[:upvote])
      @note.upvote_by current_user
      @vote_type = :upvote
      flash.now[:success] = "Upvoted!"
      respond_to do |format|
        format.html { redirect_to @note }
        format.js
      end
    elsif(params[:downvote])
      @note.downvote_by current_user
      flash.now[:alert] = "Downvoted!"
      @vote_type = :downvote
      respond_to do |format|
        format.html { redirect_to @note }
        format.js
      end
    end 
  end

  def show
    @note = Note.find(params[:id])
    if(user_signed_in?)
      @note_owner = @note.user_id
    else
      @note_owner = -1
    end
  end

  private

    def note_params
      params.require(:note).permit(:title, :content, :university, :class_subject, :professor, :tags)
    end

    def correct_user
      @note = current_user.notes.find_by(id: params[:id])
      redirect_to root_url if @note.nil?
    end
end
