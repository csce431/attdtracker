class CardsController < ApplicationController
    def index
        @cards = Card.where(course_id: :course_id)
    end
    
    def new
        @card = Card.new
        if(Card.where(courses_id: :courses_id).last)
            @lastCard = Card.where(course_id: :course_id).last.code
        end
        
    end
    
    def edit
        @card = card.find(params[:id])
    end
    
    def show
        @card = Card.find(params[:id])
    end
    
    def create
        @card = Card.new(card_params)
        @course = Course.find(params[:course_id])
        
        if code_exist(@card.code)
            render 'email'
        elsif @card.save
            @course << @card
            redirect_to new_course_day_card_path
        else
            render 'new'
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
 
        #redirect_to course_day_card_index
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
    
    private
        def card_params
            params.require(:card).permit(:code)
        end
end
