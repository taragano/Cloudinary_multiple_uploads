class AlbumsController < ApplicationController
  before_action :set_album, only: [:show, :edit, :update, :destroy, :show_photo]

  # GET /albums
  # GET /albums.json
  def index
    @albums = Album.all
  end

  # GET /albums/1
  # GET /albums/1.json
  def show
  end

  def show_photo
    @photo = Photo.find(params[:photo_id])
  end

  # GET /albums/new
  def new
    @album = Album.new
    @direct_mode = params[:direct_mode]
  end

  # GET /albums/1/edit
  def edit
    @direct_mode = params[:direct_mode]
  end

  # POST /albums
  # POST /albums.json
  def create
    @album = Album.new(album_params)

    respond_to do |format|
      if @album.save
        store_photos
        format.html { redirect_to @album, notice: 'Album was successfully created.' }
        format.json { render :show, status: :created, location: @album }
      else
        format.html { render :new }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /albums/1
  # PATCH/PUT /albums/1.json
  def update
    respond_to do |format|
      if @album.update(album_params)
        delete_photos
        store_photos
        format.html { redirect_to @album, notice: 'Album was successfully updated.' }
        format.json { render :show, status: :ok, location: @album }
      else
        format.html { render :edit }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1
  # DELETE /albums/1.json
  def destroy
    @album.destroy
    respond_to do |format|
      format.html { redirect_to albums_url, notice: 'Album was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_album
      @album = Album.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def album_params
      params.require(:album).permit(:title)
    end

    def store_photos
      photos = params[:album][:photos]
      photos.each{|photo| @album.photos.create(image: photo)} if photos
    end

    def delete_photos
      @album.photos.each do |photo|
        photo.destroy if params[photo.id.to_s] == "delete"
      end
    end
end
