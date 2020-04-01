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

        if !code_exist(@card.code) && @card.email == nil
            render 'promptemail'
        elsif !code_exist(@card.code) && @card.email != nil
        #check against database
            if email_exist_in_course(@card.email, @course)
                if @card.save #maybe check if email of card is connected to a card - then use that (if student changes tamu id card)
                    @course.cards << @card
                    @day.cards << @card
                    Student.where(email: @card.email).first.card_num = @card.code

                    redirect_to new_course_day_card_path
                end 
            else
                render 'no_email' #blank error page with "consult teacher to add you to the roster"
            end
        elsif code_exist_in_course(@card.code, @course)
        #not functioning correctly 
            @oldcard = Card.where(code: @card.code).first
            @day.cards << @oldcard

            redirect_to new_course_day_card_path
        else
            @oldcard = Card.where(code: @card.code).first
            @day.cards << @oldcard
            @course.cards << @oldcard

            redirect_to new_course_day_card_path
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
    
    def code_exist_in_course(code, course)
        #return value 'ret'
        ret = false 
        for card in course.cards.all do
          if card.code == code
            ret = true
          end 
        end 
        ret
    end
    
    def email_exist(email)
        ret = false
        for student in Student.all do
            if email == student.email
                ret = true
            end
        end
        ret
    end

    def email_exist_in_course(email, course)
        ret = false
        for student in course.students.all do
            if email == student.email
                ret = true
            end
        end
        ret
    end

    private
        def card_params
            params.require(:card).permit(:code, :email)
        end
end