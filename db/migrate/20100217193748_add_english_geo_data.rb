# Information obtained from http://www.wikipedia.com
# created by Juergen Helmers <juergen dot helmers at gmail dot com> for scientific-solution.com

class AddEnglishGeoData < ActiveRecord::Migration
  
  @country = "United Kingdom"
  @states = Hash.new
  @states['England'] = ['Greater London','Berkshire','Buckinghamshire','East Sussex','Hampshire','Kent','Oxfordshire',
                        'Surrey','West Sussex','Brighton and Hove','Isle of Wight','Medway','Milton Keynes','Portsmouth',
                        'Southampton','Cornwall','Devon','Dorset','Gloucestershire','Somerset','Wiltshire','Bath and North East Somerset',
                        'Bournemouth','Bristol','North Somerset','Plymouth','Poole','South Gloucestershire','Swindon','Torbay',
                        'Isles of Scilly','Shropshire','Staffordshire','Warwickshire','Worcestershire','West Midlands',
                        'Herefordshire','Stoke-on-Trent','Telford and Wrekin','Cheshire','Cumbria','Lancashire','Greater Manchester',
                        'Merseyside','Blackburn with Darwen','Blackpool','Halton','Warrington','County Durham','Northumberland',
                        'Tyne and Wear','Darlington','Stockton-on-Tees','Hartlepool','Redcar and Cleveland','Middlesbrough',
                        'North Yorkshire','South Yorkshire','West Yorkshire','York','East Riding of Yorkshire','Kingston upon Hull',
                        'North Lincolnshire','North East Lincolnshire','Derbyshire','Leicestershire','Lincolnshire','Northamptonshire',
                        'Nottinghamshire','Derby','Nottingham','Leicester','Rutland','Bedfordshire','Cambridgeshire','Essex',
                        'Hertfordshire','Norfolk','Suffolk','Luton','Peterborough','Southend-on-Sea','Thurrock']

  @states['Wales'] = ['Merthyr Tydfil (Merthyr Tudful)','Caerphilly (Caerffili)','Blaenau Gwent','Torfaen (Tor-faen)',
                      'Monmouthshire (Sir Fynwy)','Newport (Casnewydd)','Cardiff (Caerdydd)','Vale of Glamorgan (Bro Morgannwg)',
                      'Bridgend (Pen-y-bont ar Ogwr)','Rhondda Cynon Taf','Neath Port Talbot (Castell-nedd Port Talbot)','Swansea (Abertawe)',
                      'Carmarthenshire (Sir Gaerfyrddin)','Ceredigion','Powys','Wrexham (Wrecsam)','Flintshire (Sir y Fflint)',
                      'Denbighshire (Sir Ddinbych)','Conway (Conwy)','Gwynedd','Anglesey (Ynys Môn)','Pembrokeshire (Sir Benfro)']

  @states['Scotland'] = ['City of Aberdeen','Aberdeenshire','Angus','Argyll and Bute','Clackmannanshire',
                     'Dumfries and Galloway','City of Dundee','East Ayrshire','East Dunbartonshire','East Lothian',
                     'East Renfrewshire','City of Edinburgh','Falkirk','Fife','City of Glasgow','Highland','Inverclyde',
                     'Midlothian','Moray','North Ayrshire','North Lanarkshire','Perth and Kinross','Renfrewshire',
                     'Scottish Borders','South Ayrshire','South Lanarkshire','Stirling','West Dunbartonshire',
                     'West Lothian','Orkney Islands','Shetland Islands','Na h-Eileanan Siar (Western Isles)']                     
                     
                     
  @states['Northern Ireland'] = ['Antrim','Ards','Armagh (City)','Ballymena','Ballymoney','Banbridge','Belfast (City)',
                                 'Carrickfergus','Castlereagh','Coleraine','Cookstown','Craigavon','Derry (City)','Down',
                                 'Dungannon and South Tyrone','Fermanagh','Larne','Limavady','Lisburn (City)','Magherafelt',
                                 'Moyle','Newry and Mourne','Newtownabbey','North Down','Omagh','Strabane']
  
                                 
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
