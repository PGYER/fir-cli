# encoding: utf-8

module FIR
  module Parser
    module Pngcrush

      class << self

        def png_bin
          @png_bin ||= File.expand_path('../bin/pngcrush', __FILE__)
        end

        def uncrush_icon crushed_icon_path, uncrushed_icon_path
          system("#{png_bin} -revert-iphone-optimizations #{crushed_icon_path} #{uncrushed_icon_path} &> /dev/null")
        end

        def crush_icon uncrushed_icon_path, crushed_icon_path
          system("#{png_bin} -iphone #{uncrushed_icon_path} #{crushed_icon_path} &> /dev/null")
        end
      end
    end
  end
end
