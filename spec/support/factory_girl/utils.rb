module Raindrops
  module Support
    module Utils
      # Retourne le "vrai" répertoire racine de l'application
      def self.rails_true_root
        Rails.root.to_s.chomp '/spec/dummy'
      end
    end
  end
end
