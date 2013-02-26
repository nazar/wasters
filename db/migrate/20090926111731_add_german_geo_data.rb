class AddGermanGeoData < ActiveRecord::Migration

# written by Alexander Keiblinger for scientific-solution.com <alexander dot keiblinger at gmail dot com>

  @country = "Germany"
  @states = Hash.new
  @states['Baden-Württemberg'] = ['Heidelberg', 'Heilbronn', 'Karlsruhe', 'Mannheim', 'Pforzheim',  'Stuttgart',  'Ulm' ,'Freiburg im Breisgau' ,'Reutlingen']
  @states['Bayern'] = ['Augsburg', 'Erlangen', 'Fürth', 'Herzogenaurach', 'Ingolstadt',  'München',  'Nürnberg' ,'Regensburg' ,'Würzburg']
  @states['Berlin'] = ['Berlin', 'Charlottenburg-Wilmersdorf', 'Friedrichshain-Kreuzberg', 'Lichtenberg', 'Marzahn-Hellersdorf', 'Mitte', 'Neukölln', 'Pankow', 'Reinickendorf', 'Spandau', 'Steglitz-Zehlendorf', 'Tempelhof-Schöneberg', 'Treptow-Köpenick' ]  
  @states['Brandenburg'] = ['Cottbus', 'Potsdam', 'Barnim', 'Dahme-Spreewald', 'Elbe-Elster','Havelland','Märkisch-Oderland', 'Oberhavel','Oberspreewald-Lausitz', 'Oder-Spree','Ostprignitz-Ruppin', 'Potsdam-Mittelmark','Prignitz' ,'Spree-Neiße', 'Teltow-Fläming', 'Uckermark']
  @states['Bremen'] = ['Bremen', 'Bremerhaven']
  @states['Hamburg'] = ['Hamburg']
  @states['Hessen'] = ['Darmstadt','Frankfurt','Gießen','Kassel','Marburg','Offenbach am Main','Wiesbaden','Wetzlar']
  @states['Niedersachsen'] = ['Braunschweig','Göttingen','Hannover','Hildesheim','Oldenburg','Osnabrück','Salzgitter','Wolfenbüttel']
  @states['Mecklenburg-Vorpommern'] = ['Rostock','Schwerin','Stralsund','Wismar']
  @states['Nordrhein-Westfalen'] = ['Aachen','Bielefeld','Bochum','Bonn','Köln','Dortmund','Duisburg','Düsseldorf', 'Essen','Gelsenkirchen','Hagen', 'Krefeld', 'Leverkusen', 'Münster', 'Oberhausen', 'Paderborn' ,'Witten' ,'Wuppertal' ]
  @states['Rheinland-Pfalz'] = ['Frankenthal','Koblenz','Ludwigshafen','Mainz','Neustadt an der Weinstraße','Speyer','Trier','Zweibrücken']
  @states['Saarland'] = ['Neunkirchen','Saarbrücken','Saarlouis']
  @states['Sachsen'] = ['Chemnitz','Dresden','Leipzig']
  @states['Sachsen-Anhalt'] = ['Halle', 'Magdeburg']
  @states['Schleswig-Holstein'] = ['Kiel', 'Lübeck']
  @states['Thüringen'] = ['Erfurt','Gera','Jena']
  def self.up
    country = Country.find_or_create_by_name(@country)
    country_id = country.id 
    
    @states.each { | key, value |
      State.new(:name => key).save
      state = State.find_by_name(key)
      value.each do |metro_area|
        MetroArea.new(:name => metro_area, :state_id => state.id, :country_id => country_id).save
      end
    }   
  end

  def self.down
    country = Country.find_by_name(@country).destroy
    @states.each { | key, value |
      State.find_by_name(key).destroy
      value.each do |metro_area|
        MetroArea.find_by_name(metro_area).destroy
      end
    }
  end
end
