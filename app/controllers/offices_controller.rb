class OfficesController < ApplicationController
  before_action :set_office, only: [:show, :edit, :update, :destroy]

  
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
    render :office
    end  
  end
    

  def edit

  end
  
  def update
    
    if @office.update_attributes!(office_params)
      flash[:success] = "拠点情報を更新しました。"
      redirect_to offices_url
    else
      render :edit
    end
  end
  
  
  def destroy
    @office.destroy
    flash[:success] = "#{@office.office_name}のデータを削除しました。"
    redirect_to offices_url
  end
  
 
 
  def set_office
    @office = Office.find(params[:id])
  end
 
 

  private
  
  def office_params
    params.permit(:office_name, :office_number, :attendance_type) 
  end

 
  
end
