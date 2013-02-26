class AddSkilllz < ActiveRecord::Migration

  def self.up
    add_column :skillls, :skill_type, :integer, {:default => 0}

    Skilll.create(:title => 'Armor Use', :skill_type => 1)
    Skilll.create(:title => 'Athletics', :skill_type => 1)
    Skilll.create(:title => 'Dodge', :skill_type => 1)
    Skilll.create(:title => 'First Aid', :skill_type => 1)
    Skilll.create(:title => 'Group Tactics', :skill_type => 1)
    Skilll.create(:title => 'Melee', :skill_type => 1)
    Skilll.create(:title => 'Pistol', :skill_type => 1)
    Skilll.create(:title => 'Rifle', :skill_type => 1)
    Skilll.create(:title => 'Social', :skill_type => 1)

    Skilll.create(:title => 'Coordination', :skill_type => 2)
    Skilll.create(:title => 'Charisma', :skill_type => 2)
    Skilll.create(:title => 'Dexterity', :skill_type => 2)
    Skilll.create(:title => 'Endurance', :skill_type => 2)
    Skilll.create(:title => 'Intelligence', :skill_type => 2)
    Skilll.create(:title => 'Perception', :skill_type => 2)
    Skilll.create(:title => 'Strength', :skill_type => 2)
    Skilll.create(:title => 'Willpower', :skill_type => 2)
  end

  def self.down
    remove_column :skillls, :skill_type
  end
end
