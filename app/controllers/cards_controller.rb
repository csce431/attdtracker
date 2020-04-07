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
    
    def promptemail
        @card = Card.new
        @code = @card.code
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
        @teacher = @course.teacher_id

        if !code_exist(@card.code) && @card.email == nil
            redirect_to course_day_card_promptemail_path
        elsif !code_exist(@card.code) && @card.email != nil
        #check against database
            if email_exist_in_course(@card.email, @course)
                if @card.save 
                    @course.cards << @card
                    @day.cards << @card
                    
                    redirect_to new_course_day_card_path
                #If email of card is connected to a card
                else
                    redirect_to course_day_card_promptemail_path
                end
            #user did not provide email
            elsif @card.email == ''
                redirect_to course_day_card_promptemail_path
            #student is not enrolled in this class because email is not in the course
            else
                render 'noemail' #blank error page with "consult teacher to add you to the roster"
            end
        #if code exists in course, add it to the current day to mark that person as present
        elsif code_exist_in_course(@card.code, @course)
            @oldcard = Card.where(code: @card.code).first
            @day.cards << @oldcard

            redirect_to new_course_day_card_path
        #code exists but not in this class
        else
            @oldcard = Card.where(code: @card.code).first
            #first time swiping into this class but swiped before in another class
            if email_exist_in_course(@oldcard.email)
                @day.cards << @oldcard
                @course.cards << @oldcard
                
                redirect_to new_course_day_card_path
            #code exist but not enrolled in class
            else
                render 'noemail' #blank error page with "consult teacher to add you to the roster"
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