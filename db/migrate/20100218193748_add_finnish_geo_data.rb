# Information obtained from http://www.europa-auf-einen-blick.de/finnland/regionen.php
# created by Juergen Helmers <juergen dot helmers at gmail dot com> for scientific-solution.com

class AddFinnishGeoData < ActiveRecord::Migration
  
  @country = "Finland"
  @states = Hash.new
  
  
  @states['Åland'] = ['Maarianhamina']         
  @states['Central Finnland'] = ['Jyväskylä']        
  @states['Central Ostrobothnia'] = ['Kokkola']       
  @states['Etelä-Savo'] = ['Mikkeli']        
  @states['Itä-Uusimaa'] = ['Porvoo']       
  @states['Kainuu'] = ['Kajaani']       
  @states['Kanta-Häme'] = ['Hämeenlinna']        
  @states['Kymenlaakso'] = ['Kotka']        
  @states['Lapland'] = ['Rovaniemi']        
  @states['North Karelia'] = ['Joensuu']        
  @states['North Ostrobothnia'] = ['Oulu']        
  @states['Ostrobothnia'] = ['Vaasa']        
  @states['Päijät-Häme'] = ['Lahti']        
  @states['Pirkanmaa'] = ['Tampere']        
  @states['Pohjois-Savo'] = ['Kuopio']        
  @states['Satakunta'] = ['Pori']        
  @states['South Karelia'] = ['Lappeenranta']        
  @states['South Ostrobothnia'] = ['Seinäjoki']        
  @states['Uusimaa'] = ['Helsinki']        
  @states['Varsinais-Suomi'] = ['Turku'] 
    
                                 
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
