require 'test_helper'

class ItemSchematicTest < ActiveSupport::TestCase

  fixtures :items

  context 'CRUD tests' do


    context 'create tests' do

      setup do
        @handle_parts = {
                :item => {:item_id => 5},
                :schematics => {
                        '-1' => {:item_id => 6, :qty => 5}} #wood
                }
        @blade_parts = {
                :item => {:item_id => 10},
                :schematics => {
                        '-1' => {:item_id => 7, :qty => 3} #iron
                        }
                }
        #build knife... this is the actual knife build save
        @knife_parts = {
                :item => {:item_id => 2},
                :schematics => {
                        '-1' => {:item_id => 5, :qty => 2}, #two sided handle
                        '-2'  => {:item_id => 10, :qty => 1}, #blade
                        '-3'  => {:item_id => 11, :qty => 1} #scabbard
                        }
                }
      end

      should 'save knife schematics - 2 levels' do
        #build knife schematics given a hash of parts

        #build handle
        handle = Item.find_by_id(@handle_parts[:item][:item_id])
        handle.save_schematics(@handle_parts[:schematics], 1)
        handle.save
         #tests
        assert handle.schematic_roots.count, 1
        assert handle.schematic_roots.first.assembley, 1
        
        #build blade in previous session
        blade = Item.find_by_id(@blade_parts[:item][:item_id])
        blade.save_schematics(@blade_parts[:schematics], 1)
        blade.save

        #tests
        assert blade.schematic_roots.count, 1
        assert blade.schematic_roots.first.assembley, 2

        #save it
        knife = Item.find_by_id(@knife_parts[:item][:item_id])
        knife.save_schematics(@knife_parts[:schematics], 1)
        knife.save
        #test it
        assert knife.schematic_roots.count, 3
        assert_equal knife.schematic_roots.collect{|a| a.assembley}.uniq.length, 3
        assert_equal knife.assemblies, '1:5,2:10,3:2'
        
        #test full retrieve of knife... should include all 5 subitems from linked schematics. i.e.
        #knife
          #handle, qty:1, lvl:1
            #wood, qty:5, :lvl2
          #blade, qty:1, lvl:1
            #iron, qty:1, lvl:2
          #scabbard, qty:1. lvl:1
        assert_equal ItemSchematic.by_assemblies(knife.assemblies).length, 5
#        raise knife.full_schematics_hash.to_yaml
      end

      should 'save knife schematics - 3 levels' do
        #build handle
        handle = Item.find_by_id(@handle_parts[:item][:item_id])
        handle.save_schematics(@handle_parts[:schematics], 1)
        handle.save

        #build blade in previous session
        blade = Item.find_by_id(@blade_parts[:item][:item_id])
        blade.save_schematics(@blade_parts[:schematics], 1)
        blade.save

        #save it
        knife = Item.find_by_id(@knife_parts[:item][:item_id])
        knife.save_schematics(@knife_parts[:schematics], 1)
        knife.save
        
        #build three level deep schematic
          #belt
          #knife
            #handle, qty:1, lvl:1
              #wood, qty:5, :lvl2
            #blade, qty:1, lvl:1
              #iron, qty:1, lvl:2
            #scabbard, qty:1. lvl:1
        @knife_belt = {
                :item => {:item_id => 12},
                :schematics => {
                        '-1' => {:item_id => 2,  :qty => 1}, #knife
                        '-2' => {:item_id => 13, :qty => 1}, #belt
                        }
                }
        belt = Item.find_by_id(@knife_belt[:item][:item_id])
        belt.save_schematics(@knife_belt[:schematics], 1)
        belt.save
        #test it
        assert belt.schematic_roots.count, 2
        assert_equal belt.schematic_roots.collect{|a| a.assembley}.uniq.length, 2
        assert_equal belt.assemblies, '1:5,2:10,3:2,4:12'

        raise belt.full_schematics_hash.to_yaml
      end

      

    end


  end


end
