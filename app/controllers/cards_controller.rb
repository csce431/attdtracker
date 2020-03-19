class CardsController < ApplicationController
    def index
        @course = Course.find(params[:course_id])
        @cards = @course.cards.all
        @day = Day.find(params[:day_id])
    end
    
    def new
        @card = Card.new
        #if(Card.where(courses_id: :courses_id).last)
        #    @lastCard = Card.where(course_id: :course_id).last.code
        #end
        
    end
    
    def edit
        @card = Card.find(params[:id])
    end
    
    def show
        @card = Card.find(params[:id])
        @course = Course.find(params[:course_id])
        @students = @course.students
    end
    
    def create
        @card = Card.new(card_params)
        @course = Course.find(params[:course_id])
        @day = Day.find(params[:day_id])
        @bool = !code_exist(@card.code)
        #@page holds which prompt it is on
        
        if @card.save
            if @bool
                redirect_to edit_course_day_card_path(@course, @day, @card) #render ''
            else
                redirect_to new_course_day_card_path
            end
            @course.cards << @card
        else
            email = email_exist(@card.email)
            if email == ""
                render 'no_email'
            elsif @card.save
            #if @card.save
                @course.cards << @card
                @day.cards << @card

                redirect_to new_course_day_card_path
            else
                render 'new'
            end
        end
    end
    
    def update
        @card = Card.find(params[:id])
 
        if @card.update(card_params)
            redirect_to @card
        else
            render 'edit'
        end
    end
    
    def destroy
        @card = Card.find(params[:id])
        @card.destroy
 
        redirect_to course_day_cards_url
    end 
    
    def newEmail
    
    end
    
    def code_exist(code)
        #return value 'ret'
        ret = false 
        for card in Card.all do
          if card.code == code
            ret = true
          end 
        end 
        ret
    end
    
    def email_exist(email)
        ret = ""
        for student in Student.all do
            if email == student.email
                ret = email
            end
        end
        ret
    end
    
    private
        def card_params
            params.require(:card).permit(:code, :email)
        end
end