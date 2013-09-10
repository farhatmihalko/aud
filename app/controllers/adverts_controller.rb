class AdvertsController < ApplicationController
  # GET /adverts
  # GET /adverts.json

  def index
    if !current_user
      redirect_to log_in_path
      return
    end
    @adverts = Advert.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @adverts }
    end
  end

  # GET /adverts/1
  # GET /adverts/1.json
  def show
    if !current_user
      redirect_to log_in_path
      return
    end
    @advert = Advert.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @advert }
    end
  end

  # GET /adverts/new
  # GET /adverts/new.json
  def new
    if !current_user
      redirect_to log_in_path
      return
    end
    @advert = Advert.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @advert }
    end
  end

  # GET /adverts/1/edit
  def edit
    if !current_user
      redirect_to log_in_path
      return
    end
    @advert = Advert.find(params[:id])
  end

  # POST /adverts
  # POST /adverts.json
  def create
    if !current_user
      redirect_to log_in_path
      return
    end
    @advert = Advert.new(params[:advert])
    @advert.banner = params[:advert][:banner]
    @advert.counter = 0
    # => raise @advert.inspect 
    respond_to do |format|
      if @advert.save
        format.html { redirect_to @advert, notice: 'Advert was successfully created.' }
        format.json { render json: @advert, status: :created, location: @advert }
      else
        format.html { render action: "new" }
        format.json { render json: @advert.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /adverts/1
  # PUT /adverts/1.json
  def update
    if !current_user
      redirect_to log_in_path
      return
    end
    @advert = Advert.find(params[:id])

    respond_to do |format|
      if @advert.update_attributes(params[:advert])
        format.html { redirect_to @advert, notice: 'Advert was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @advert.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /adverts/1
  # DELETE /adverts/1.json
  def destroy
    if !current_user
      redirect_to log_in_path
      return
    end
    @advert = Advert.find(params[:id])
    @advert.destroy

    respond_to do |format|
      format.html { redirect_to adverts_url }
      format.json { head :no_content }
    end
  end

  def hit
    ad = Advert.find(params[:id])
    ad.counter+=1
    ad.save!
    redirect params[:path]
  end
end