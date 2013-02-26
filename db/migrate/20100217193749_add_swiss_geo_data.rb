# Information obtained from http://www.swiss.de/schweiz/
# created by Juergen Helmers <juergen dot helmers at gmail dot com> for scientific-solution.com

class AddSwissGeoData < ActiveRecord::Migration
  
  @country = "Switzerland"
  @states = Hash.new
  
  
  @states['Aargau'] = ['Wettingen','Baden','Aarau','Wohlen','Rheinfelden','Oftringen','Zofingen','Spreitenbach','Möhlin','Suhr','Brugg','Obersiggenthal','Neuenhof','Lenzburg','Reinach','Rothrist','Oberentfelden','Windisch','Muri','Aarburg']
  @states['Appenzell Ausserrhoden'] = ['Herisau','Teufen','Heiden','Speicher','Gais','Urnäsch','Walzenhausen','Trogen','Waldstatt','Wolfhalden','Rehetobel','Bühler','Schwellbrunn','Stein AR','Lutzenberg','Grub','Hundwil','Wald','Reute','Schönengrund']
  @states['Appenzell Innerrhoden'] = ['Appenzell','Rüte','Schwende','Oberegg','Gonten','Schlatt-Haslen']
  @states['Basel-Landschaft'] = ['Reinach','Allschwil','Muttenz','Pratteln','Binningen','Liestal','Sissach','Bottmingen','Gelterkinden','Laufen','Ettingen','Lausen','Bubendorf']
  @states['Basel-Stadt'] = ['Basel','Riehen','Bettingen']
  @states['Bern'] = ['Bern','Biel/Bienne','Thun','Köniz','Steffisburg','Burgdorf','Ostermundigen','Langenthal','Muri bei Bern','Spiez','Worb','Lyss','Münsingen','Ittigen','Zollikofen','Belp','Münchenbuchsee','Wohlen bei Bern','Langnau im Emmental','Moutier']
  @states['Freiburg'] = ['Freiburg','Bulle','Villars-sur-Glâne','Marly','Düdingen','Murten','Wünnewil-Flamatt','Châtel-Saint-Denis','Estavayer-le-Lac','Kerzers','Romont','Gurmels','Schmitten','Bösingen FR','Courtepin','Le Mouret','Attalens','Tafers','Givisiez','Domdidier']
  @states['Genf'] = ['Genf','Vernier','Lancy','Meyrin','Carouge','Onex','Thônex','Versoix','Le Grand-Saconnex','Chêne-Bougeries','Veyrier','Plan-les-Ouates','Bernex','Chêne-Bourg','Collonge-Bellerive','Cologny','Confignon','Pregny-Chambésy','Satigny','Bellevue']
  @states['Glarus'] = ['Glarus','Näfels','Niederurnen','Mollis','Netstal','Ennenda','Schwanden','Bilten','Oberurnen','Linthal','Luchsingen','Haslen','Mitlödi','Riedern','Elm','Engi','Filzbach','Obstalden','Mühlehorn','Schwändi']
  @states['Graubünden'] = ['Chur','Davos','Igis','Domat/Ems','St. Moritz','Klosters-Serneus','Samedan','Poschiavo','Zizers','Trimmis','Vaz/Obervaz','Bonaduz','Thusis','Flims','Maienfeld','Schiers','Roveredo','Ilanz','Arosa','Untervaz']
  @states['Jura'] = ['Delémont','Porrentruy','Bassecourt','Courroux','Courrendlin','Courtételle','Saignelégier','Courgenay','Vicques','Alle','Le Noirmont','Courfaivre','Les Breuleux','Develier','Boncourt','Fontenais','Glovelier','Les Bois','Cornol','Boécourt']
  @states['Luzern'] = ['Luzern','Emmen','Kriens','Littau','Horw','Ebikon','Sursee','Hochdorf','Willisau','Rothenburg','Meggen','Ruswil','Malters','Reiden','Neuenkirch','Adligenswil','Buchrain','Dagmersellen','Wolhusen','Weggis']
  @states['Neuenburg'] = ['La Chaux-de-Fonds','Neuchâtel','Le Locle','Peseux','Colombier','Boudry','Cortaillod','Corcelles-Cormondrèche','Le Landeron','Marin-Epagnier','Bevaix','Fleurier','Saint-Blaise','Couvet','Hauterive','Saint-Aubin-Sauges','Cernier','Cressier','Gorgier','Bôle']
  @states['Nidwalden'] = ['Stans','Hergiswil','Buochs','Stansstad','Ennetbürgen','Beckenried','Oberdorf','Ennetmoos','Wolfenschiessen','Dallenwil','Emmetten']
  @states['Obwalden'] = ['Sarnen','Kerns','Alpnach','Sachseln','Engelberg','Giswil','Lungern']
  @states['Schaffhausen'] = ['Schaffhausen','Neuhausen am Rheinfall','Thayngen','Beringen','Stein am Rhein','Hallau','Neunkirch','Schleitheim','Wilchingen','Ramsen','Löhningen','Stetten','Dörflingen','Buchberg','Gächlingen','Siblingen','Merishausen','Lohn','Rüdlingen','Trasadingen']
  @states['Schwyz'] = ['Freienbach','Schwyz','Einsiedeln','Küssnacht SZ','Arth','Ingenbohl','Schübelbach','Lachen','Wollerau','Altendorf','Feusisberg','Wangen','Galgenen','Muotathal','Steinen','Reichenburg','Tuggen','Unteriberg','Rothenthurm','Gersau']
  @states['Solothurn'] = ['Olten','Grenchen','Solothurn','Zuchwil','Biberist','Dornach','Trimbach','Derendingen','Balsthal','Bellach','Bettlach','Gerlafingen','Oensingen','Wangen bei Olten','Dulliken','Schönenwerd','Hägendorf','Niedergösgen','Lostorf','Langendorf']
  @states['St. Gallen'] = ['St. Gallen','Rapperswil-Jona','Wil','Gossau','Uzwil','Altstätten','Buchs','Flawil','Goldach','Wittenbach','Rorschach','Wattwil','Widnau','Gaiserwald','Mels','Kirchberg','Oberriet','Au','Rorschacherberg','Grabs']
  @states['Tessin'] = ['Lugano','Bellinzona','Locarno','Giubiasco','Chiasso','Minusio','Mendrisio','Losone','Biasca','Massagno','Ascona','Capriasca','Collina d\'Oro','Gordola','Morbio Inferiore','Stabio','Arbedo-Castione','Caslano','Agno','Balerna']
  @states['Thurgau'] = ['Frauenfeld','Kreuzlingen','Arbon','Amriswil','Weinfelden','Romanshorn','Aadorf','Sirnach','Bischofszell','Münchwilen','Egnach','Wängi','Tägerwilen','Eschlikon','Steckborn','Sulgen','Gachnang','Kradolf-Schönenberg','Diessenhofen','Bürglen']
  @states['Uri'] = ['Altdorf','Schattdorf','Bürglen','Erstfeld','Silenen','Flüelen','Seedorf','Attinghausen','Andermatt','Spiringen','Unterschächen','Seelisberg','Gurtnellen','Isenthal','Wassen','Göschenen','Sisikon','Hospental','Bauen','Realp']
  @states['Waadt'] = ['Lausanne','Yverdon-les-Bains','Montreux','Renens','Nyon','Vevey','Pully','Morges','Prilly','Gland','La Tour-de-Peilz','Ecublens','Lutry','Aigle','Epalinges','Payerne','Bussigny-près-Lausanne','Crissier','Ollon','Chavannes-près-Renens']
  @states['Wallis'] = ['Sion','Monthey','Sierre','Martigny','Brig-Glis','Naters','Bagnes','Conthey','Fully','Visp','Collombey-Muraz','Savièse','Nendaz','Zermatt','Vétroz','Troistorrents','Saxon','Saint-Maurice','Lens','Randogne']
  @states['Zürich'] = ['Zürich','Winterthur','Uster','Dübendorf','Dietikon','Wetzikon ZH','Wädenswil','Horgen','Kloten','Thalwil','Bülach','Volketswil','Adliswil','Regensdorf','Illnau-Effretikon','Schlieren','Stäfa','Opfikon','Küsnacht','Wallisellen']
  @states['Zug'] = ['Zug','Baar','Cham','Steinhausen','Risch','Hünenberg','Unterägeri','Oberägeri','Menzingen','Walchwil','Neuheim']
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
