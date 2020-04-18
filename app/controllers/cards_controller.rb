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
        @card = Card.all
        @course = Course.find(params[:course_id])
        @students = @course.students
        @student = Student.all
    end
    
    def create
        @card = Card.new(card_params)
        @course = Course.find(params[:course_id])
        @day = Day.find(params[:day_id])
        @teacher = @course.teacher_id
        @students = @course.students

        @card_updated = false;
        
        # code doesn't exist in entire database and no email is linked to it
        if !code_exist(@card.code) && @card.email == nil
            # redirect_to course_day_card_promptemail_path(@course, @day, @card)
            # puts('EMAIL PROMPTED!!!')
            render 'prompt_email'
        # code doesn't exist in entire database, but there is email linked to it
        elsif !code_exist(@card.code) && @card.email != nil
            # check if linked email is in course's cards' emails
            if email_exist_in_course(@card.email, @course)
                # if email of card is connected to a card, use that (if student changes tamu id card)
                if @card.save
                    @course.cards << @card
                    @day.cards << @card
                    #Student.where(email: @card.email).first.card_num = @card.code
                    
                    # update student and card attribute (link email and card number)
                    @student = @students.where(email: @card.email).first
                    @student.update_attribute(:card_num, @card.code)
                    if !@student.prefname.nil?
                        @card.preferredname = @student.prefname
                    end
                    @card.firstname = @student.fname
                    @card.lastname = @student.lname

                    @card_updated = false;

                    # puts('EMAIL LINKED!!!')
                    render 'added_email'
                else
                    @existing_student = Card.where(email: @card.email).first
                    @existing_student.update_attribute(:code, @card.code)

                    @student = @students.where(email: @existing_student.email).first
                    @student.update_attribute(:card_num, @existing_student.code)
                    if !@student.prefname.nil?
                        @card.preferredname = @student.prefname
                    end
                    @card.firstname = @student.fname
                    @card.lastname = @student.lname
                    
                    # puts('EXISTING STUDENT WITH NEW CARD')

                    # re-add card to the course if not already
                    if !@existing_student.course_ids.include? @course.id
                        @course.cards << @existing_student
                    end

                    @day.cards << @existing_student
                    @card_updated = true;

                    render 'added_email'
                end
            # email is prompted, but email doesn't link to anything in entire database
            else
                render 'no_email' # error page with "consult instructor to add you to the roster"
            end
        # code exists in entire database
        else
            # code exists in course (no need to check for email)
            if code_exist_in_course(@card.code, @course)

                @oldcard = Card.where(code: @card.code).first
                @student = @students.where(email: @oldcard.email).first

                if !@student.prefname.nil?
                    @card.preferredname = @student.prefname
                end
                @card.firstname = @student.fname
                @card.lastname = @student.lname

                # card is already swiped in for that day ID
                if @oldcard.day_ids.include? @day.id
                    # already swiped in for the day (the current day.id)
                    # puts('ALREADY SWIPED IN!!!')
                    render 'already_in'
                else
                    # IT IS A NEW DAY, show confirmation page
                    # puts('SUCCESSFULLY SWIPED IN!!!')
                
                    # add card to the course if not already
                    if !@oldcard.course_ids.include? @course.id
                        @course.cards << @oldcard
                    end
                    # create day.id for card
                    @day.cards << @oldcard
                    render 'cards/show', :course_id => @course, :code => @card
                end
            # code doesn't exist in course, but exists in database
            else
                @oldcard = Card.where(code: @card.code).first
                @student = Student.where(email: @oldcard.email).first

                if !@student.prefname.nil?
                    @card.preferredname = @student.prefname
                end
                @card.firstname = @student.fname
                @card.lastname = @student.lname

                # error page with "consult instructor to add you to the roster"
                # puts('EXISTING STUDENT NOT IN COURSE!!!')
                render 'not_registered', :course_id => @course, :code => @card
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