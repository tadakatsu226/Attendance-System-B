class OfficesController < ApplicationController
    
  def index
    @offices = Office.all
    # @office = Office.find(params[:id])
    
  end
  
  def show
    
  end
    
  def new
    @office = Office.new
      
  end
  
  def create
    @office = Office.new(office_params)
    if @office.save
    flash[:success] = "拠点情報が追加されました"
    redirect_to offices_url
    else
    flash[:danger] = "拠点情報は追加されませんでした"
    redirect_to offices_url
    end  
  end
    

  def edit
    @office = Office.find(params[:id])
    
  end
  
  def update
    
  end
  
  
  # def destroy
  #   @user.destroy
  #   flash[:success] = "#{@user.name}のデータを削除しました。"
  #   redirect_to users_url
  # end
  
  
  private
  
  def office_params
    params.require(:office).permit(:office_name, :office_number, :attendance_type) 
  end

  
  
  
  
  
end
