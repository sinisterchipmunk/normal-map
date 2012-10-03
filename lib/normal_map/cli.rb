require 'thor'

class NormalMap::CLI < Thor
  include Thor::Actions

  desc "generate [options] COLORS NORMALS",
       "Generates a normal map from COLORS and saves it to NORMALS"
  method_option :smooth, :type => :boolean, :default => false, :aliases => '-s', :desc => "Average adjacent pixels to produce a smoother accurate map"
  method_option :diagonal, :type => :boolean, :default => false, :aliases => '-d', :desc => "Consider diagonally-adjacent pixels in normal calculations"
  method_option :wrap, :type => :boolean, :default => false, :aliases => '-w', :desc => "Wrap edge pixels to the opposite edge, to make the map more tile-friendly"
  def generate colors_fn, normals_fn
    create_file normals_fn do
      NormalMap.new(colors_fn, options).to_blob { |f| f.format = "PNG" }
    end
  end
end
