class AddSouthAfricanGeoData < ActiveRecord::Migration
  
  #structure of south africa according to http://en.wikipedia.org/wiki/List_of_South_African_Municipalities
  # written by Alexander Keiblinger for scientific-solution.com <alexander dot keiblinger at gmail dot com>

  @country = "South Africa"
  @states = Hash.new
  @states['Eastern Cape'] = ['Cacadu District Municipality', 'Amatole District Municipality', 'Chris Hani District Municipality', 'Ukhahlamba District Municipality',
     'O.R.Tambo District Municipality',  'Alfred Nzo District Municipality',  'Nelson Mandela Bay Metropolitan Municipality']

  @states['Free State'] = ['Xhariep District Municipality', 'Motheo District Municipality', 'Lejweleputswa District Municipality', 'Thabo Mofutsanyane District Municipality','Fezile Dabi District Municipality']

  @states['Gauteng'] = ['Sedibeng District Municipality', 'Metsweding District Municipality', 'West Rand District Municipality', 'Ekurhuleni Metropolitan Municipality', 'City of Johannesburg Metropolitan Municipality', 'City of Tshwane Metropolitan Municipality']

  @states['KwaZulu-Natal'] = ['Ugu District Municipality', 'Umgungundlovu District Municipality', 'Uthukela District Municipality', 'Umzinyathi District Municipality','Amajuba District Municipality','Zululand District Municipality', 'Umkhanyakude District Municipality','uThungulu District Municipality', 'iLembe District Municipality','Sisonke District Municipality','eThekwini Municipality Metropolitan']

  @states['Limpopo'] = ['Mopani District Municipality','Vhembe District Municipality','Capricorn District Municipality','Waterberg District Municipality','Greater Sekhukhune District Municipality']

  @states['Mpumalanga'] = ['Gert Sibande District Municipality','Nkangala District Municipality','Ehlanzeni District Municipality']

  @states['North West'] = ['Bojanala Platinum District Municipality','Ngaka Modiri Molema District Municipality','Dr Ruth Segomotsi Mompati District Municipality','Dr Kenneth Kaunda District Municipality']

  @states['Northern Cape'] = ['Namakwa District Municipality','Pixley ka Seme District Municipality','Siyanda District Municipality','Frances Baard District Municipality','Kgalagadi District Municipality']

  @states['Western Cape'] = ['West Coast District Municipality','Cape Winelands District Municipality','Overberg District Municipality','Eden District Municipality','Central Karoo District Municipality']
  
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
