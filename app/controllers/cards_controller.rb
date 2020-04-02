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
        @card = Card.all
        @course = Course.find(params[:course_id])
        @students = @course.students
        @student = Student.all
    end
    
    def create
        @card = Card.new(card_params)
        @course = Course.find(params[:course_id])
        @day = Day.find(params[:day_id])
        @students = @course.students

        @code_in_course = true

        if !code_exist(@card.code) && @card.email == nil
            render 'promptemail'
        elsif !code_exist(@card.code) && @card.email != nil
            # check against database for card's email (code doesn't exist yet)
            if email_exist_in_course(@card.email, @course)
                # maybe check if email of card is connected to a card - then use that (if student changes tamu id card)
                if @card.save
                    @course.cards << @card
                    @day.cards << @card
                    #Student.where(email: @card.email).first.card_num = @card.code
                    
                    @student = @students.where(email: @card.email).first
                    @student.update_attribute(:card_num, @card.code)

                    @card.preferredname = @student.prefname
                    @card.firstname = @student.fname
                    @card.lastname = @student.lname

                    render 'added_email'
                end 
            else
                render 'no_email' # blank error page with "consult teacher to add you to the roster"
            end
        elsif code_exist_in_course(@card.code, @course) #### not functioning correctly
            # code exists (no need to check for email)

            @oldcard = Card.where(code: @card.code).first
            @day.cards << @oldcard

            @student = @students.where(email: @oldcard.email).first

            @card.preferredname = @student.prefname
            @card.firstname = @student.fname
            @card.lastname = @student.lname

            ##### TODO: check if card is already swiped in for that day ID
            if @oldcard.day_ids.include? @day.id
                # already signed in for today (the current day.id)
                render 'already_in'
            else
                # if new day, show confirmation page
                render 'cards/show', :course_id => @course, :code => @card
            end
        else # ???
            @oldcard = Card.where(code: @card.code).first
            @day.cards << @oldcard
            @course.cards << @oldcard

            @student = Student.all.where(email: @oldcard.email).first

            @card.preferredname = @student.prefname
            @card.firstname = @student.fname
            @card.lastname = @student.lname

            @code_in_course = false

            render 'cards/show', :course_id => @course, :code => @card
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
        ret = false
        for card in Card.all do
          if card.code == code
            ret = true
          end
        end
        ret
    end
    
    def code_exist_in_course(code, course)
        ret = false
        for student in course.students.all do
            if code == student.card_num
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