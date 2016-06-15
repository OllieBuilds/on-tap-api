class BeersController < OpenReadController
  # before_action :set_beer, only: [:show, :update, :destroy]

  def findbeer
    brewery_db = bdb_client

    search = {
      q: params[:query],
      p: 1
    }

    search_results = brewery_db.search.beers(search)
    render json: search_results
  end

  # GET /beers
  # GET /beers.json
  def mybeers
    @beers = Beer.where('user_id = ?', current_user.id)

    render json: @beers
  end

  # GET /beers/1
  # GET /beers/1.json
  def show
    render json: @beer
  end

  # POST /beers
  # POST /beers.json
  def create
    brewery_db = bdb_client

    result = brewery_db.beers.find(beer_bdbid[:id])

    params = {
      favorite: false,
      name: result[:name],
      abv: result[:abv],
      image: result[:labels][:medium],
      bdb_id: result[:id],
      user_id: current_user.id
    }

    @beer = Beer.new(params)
    exists = !Beer.where(
      'user_id = ? AND bdb_id = ?',
      current_user.id,
      result[:id]
    ).empty?

    if !exists && @beer.save
      render json: @beer, status: :created
    else
      render json: @beer.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /beers/1
  # PATCH/PUT /beers/1.json
  def update
    @beer = Beer.where('user_id = ? AND bdb_id = ?', current_user.id, beer_bdbid[:id]).first
    @beer.toggle('favorite')
    if @beer.save
      head :no_content
    else
      render json: @beer.errors, status: :unprocessable_entity
    end
  end

  # DELETE /beers/1
  # DELETE /beers/1.json
  def destroy
    @beer = Beer.where(
      'user_id = ? AND bdb_id = ?',
      current_user.id,
      params[:bdb_id]
    )

    @beer.destroy_all

    head :no_content
  end

  private

  def bdb_client
    brewery_db = BreweryDB::Client.new do |config|
      config.api_key = Rails.application.secrets.brewery_db_key
    end
    brewery_db
  end

  def beer_bdbid
    params.require(:beers)
          .permit(:id)
  end

  def set_beer
    @beer = Beer.find(params[:id])
  end

  # def beer_params
  #   params[:beer]
  # end
end
