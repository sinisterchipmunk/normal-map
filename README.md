# Normalmapper

Command line tool and Ruby library for generating normal maps.

Generates DOT3 bump maps, also known as normal maps, for use in 3D computing.


## Installation

Add this line to your application's Gemfile:

    gem 'normal_map'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install normal_map


## Command Line Usage

Generate a normal map from a regular full-color image:

  Usage:
    normal-map generate [options] COLORS NORMALS

  Options:
    -s, [--smooth]    # Average adjacent pixels to produce a smoother map
    -d, [--diagonal]  # Consider diagonally-adjacent pixels in normal 
                        calculations
    -w, [--wrap]      # Wrap edge pixels to the opposite edge, to make the 
                        map more tile-friendly

  Generates a normal map from COLORS and saves it to NORMALS



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
