# Information obtained from http://www.wikipedia.com
# created by Juergen Helmers <juergen dot helmers at gmail dot com> for scientific-solution.com

class AddFrenchGeoData < ActiveRecord::Migration
  
  @country = "France"
  @states = Hash.new
  @states['Alsace'] = ['Bas-Rhin','Haut-Rhin']
  @states['Aquitaine'] = ['Dordogne','Gironde','Landes', 'Lot-et-Garonne', 'Pyrénées-Atlantiques']
  @states['Auvergne'] = ['Allier','Cantal','Haute-Loire','Puy-de-Dôme']
  @states['Basse-Normandie'] = ['Calvados','Manche','Orne']
  @states['Bourgogne'] = ['Côte-d\'Or','Nièvre','Saône-et-Loire','Yonne']
  @states['Bretagne'] = ['Côtes-d\'Armor','Finistère','Ille-et-Vilaine','Morbihan']
  @states['Centre'] = ['Cher','Eure-et-Loir','Indre','Indre-et-Loire','Loiret','Loir-et-Cher']
  @states['Champagne-Ardenne'] = ['Ardennes','Aube','Haute-Marne','Marne']
  @states['Corsica (Corse)'] = ['Corse-du-Sud','Haute-Corse']
  @states['Franche-Comté'] = ['Doubs','Haute-Saône','Jura','Territoire de Belfort']
  @states['Haute-Normandie'] = ['Eure','Seine-Maritime']
  @states['Île-de-France'] = ['Essonne','Hauts-de-Seine','Paris','Seine-et-Marne','Seine-Saint-Denis','Val-de-Marne','Val-d\'Oise','Yvelines']
  @states['Languedoc-Roussillon'] = ['Aude','Gard','Hérault','Lozère','Pyrénées-Orientales']
  @states['Limousin'] = ['Corrèze','Creuse','Haute-Vienne']
  @states['Lorraine'] = ['Meurthe-et-Moselle','Meuse','Moselle','Vosges']
  @states['Midi-Pyrénées'] = ['Ariège','Aveyron','Gers','Haute-Garonne','Hautes-Pyrénées','Lot','Tarn','Tarn-et-Garonne']
  @states['Nord-Pas-de-Calais'] = ['Nord','Pas-de-Calais']
  @states['Pays de la Loire'] = ['Loire-Atlantique','Maine-et-Loire','Mayenne','Sarthe','Vendée']
  @states['Picardie'] = ['Aisne','Oise','Somme']
  @states['Poitou-Charentes'] = ['Charente','Charente-Maritime','Deux-Sèvres','Vienne']
  @states['Provence-Alpes-Côte d\'Azur'] = ['Alpes-de-Haute-Provence','Alpes-Maritimes','Bouches-du-Rhône','Hautes-Alpes','Var','Vaucluse']
  @states['Rhône-Alpes'] = ['Ain','Ardèche','Drôme','Haute-Savoie','Isère','Loire','Rhône','Savoie']
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
