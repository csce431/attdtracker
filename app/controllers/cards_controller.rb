class CardsController < ApplicationController
    def index
        @cards = Card.all
    end
    
    def new
        @card = Card.new
    end
    
    def edit
        @card = card.find(params[:id])
    end
    
    def show
        @card = Card.find(params[:id])
    end
    
    def create
        @card = Card.new(card_params)
        #if unique
        # render 'file name here'
        if @card.save
            redirect_to new_course_day_card_path #add welcome ___
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
    
    private
        def card_params
            params.require(:card).permit(:code)
        end
end
