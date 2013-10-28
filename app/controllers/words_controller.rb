class WordsController < ApplicationController
  def index
    @adverts = Advert.get_adverts
    @show = true
    render :define
  end

  def define
    @word = Word.where(:language => params['lang'], :name => params['name']).first
    if (@word.nil?)
      if params['lang'] == 'kz'
        @variants = Lemmatizer.lemmatize params['name']
      end
      if @variants
        @variants.each do |v|
          @w = Word.where(:language => params['lang'], :name => v).first
          if @w
            @word = @w
          end
        end
      end
    end
    if (@word.nil?)
      if (request.xhr?)
        render :json => 'Error'
      else
        render :define
      end
      return
    end

    respond_to do |format|
      format.html { render :json => @word }
      format.json { render :json => @word }
    end
  end

  def try_api
    respond_to do |format|
      format.html {}
      format.json {}
    end
  end

  def suggest
    @suggestions = Word.order(:indexed_name)
      .where(:language => params['lang'])
      .find(:all, :conditions => ['name LIKE ? ', ''+params[:name]+'%'],:limit => 10)
      .map{|w| w.name}
  
    if @suggestions.count < 10
      @suggestions = Word.similar(params[:lang], params[:name])
    end

    render :json => @suggestions[0,10]
  end

  def nearby
    @word = Word.where(:language => params['lang'], :name => params['name']).first
    @lower = Word.where(:language => params['lang']).order(:indexed_name)
      .find(:all, :conditions => ['indexed_name > ? ', @word.indexed_name],:limit => 4)
    @upper = Word.where(:language => params['lang']).find(:all, :order => 'indexed_name desc',
      :conditions => ['indexed_name <= ? ', @word.indexed_name],:limit => 5).reverse
    render :json => @upper + @lower
  end

  def random
    @rand = []
    @words = Word.where(:language => params['lang'])
    (1..9).each do
      num = rand(@words.count)
      r = @words.first(:offset => num)
      @rand << r
    end
    @rand.sort_by! {|obj| obj.indexed_name}
    render :json => @rand
  end

  def examples
  end

  def about_us
  end

  def contact_us
  end

end
