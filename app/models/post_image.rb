class PostImage < ApplicationRecord
  belongs_to :post
  validates :url,
    presence: true

  before_create :generateDetails

  private
    def generateDetails
      r = URI.parse(self.url)
      case r.host
      when /youtube/
        generateForYouTube r.query
      when /imgur/
        generateForImgur r.path.split('/').reject{|i| i.empty?}[-1]
      when /gfycat/
        generateForGfyCat r.path.split('/').reject{|i| i.empty?}[-1]
      else
        self.site = nil
      end
    end

  private
    def generateForYouTube(query)
      # https://www.youtube.com/watch?v=VqOaQgD_2KA
      q = Hash[URI.decode_www_form(query)]['v']
      self.site = 'youtube'
      self.site_id = q
      self.thumbnail_url = "https://i.ytimg.com/vi/#{q}/hqdefault.jpg"
      self.embedded_url = "
        <iframe
          width='560'
          height='315'
          src='https://www.youtube.com/embed/#{q}'
          frameborder='0'
          allow='autoplay; encrypted-media'
          allowfullscreen
        ></iframe>"
    end

  private
    def generateForImgur(path)
      # https://imgur.com/lHntoVH
      self.site = 'imgur'
      self.site_id = path
      self.thumbnail_url = "https://i.imgur.com/#{path}b.jpg"
      self.embedded_url = "
        <blockquote class='imgur-embed-pub' lang='en' data-id='#{path}'>
          <a href='//imgur.com/#{path}'></a>
        </blockquote>"
    end

  private
    def generateForGfyCat(path)
      # https://gfycat.com/PettyCrispLice
      self.site = 'gfycat'
      self.site_id = path
      self.thumbnail_url = "https://thumbs.gfycat.com/#{path}-thumb100.jpg"
      self.embedded_url = "
        <iframe
          src='https://gfycat.com/ifr/#{path}'
          frameborder='0'
          scrolling='no'
          allowfullscreen
          width='640'
          height='814'
        ></iframe>"
    end
end
