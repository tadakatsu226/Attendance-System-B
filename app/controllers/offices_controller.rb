class OfficesController < ApplicationController
  before_action :set_office, only: [:show, :edit, :update, :destroy]
  before_action :admin_user
  
  def index
    @offices = Office.all
  end
  
  def show
    
  end
    
  def office
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

  end
  
  def update
    if @office.update(office_params)
      flash[:success] = "拠点情報を更新しました。"
      redirect_to offices_url
    else
      flash[:danger] = "拠点情報は更新されませんでした"
      redirect_to offices_url
    end
  end
  
  
  def destroy
    @office.destroy
    flash[:success] = "#{@office.office_name}のデータを削除しました。"
    redirect_to offices_url
  end
  

  private
  
  def office_params
    params.require(:office).permit(:office_name, :office_number, :attendance_type) 
  end

  def set_office
    @office = Office.find(params[:id])
  end
  
end
