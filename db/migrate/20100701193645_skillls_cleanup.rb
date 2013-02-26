class SkilllsCleanup < ActiveRecord::Migration



  def self.up

    def self.move_skill_to(pFrom, pTo)
      ItemSkill.update_all("skilll_id = #{pTo}", "skilll_id = #{pFrom}")
      Skilll.delete(pFrom)
    end

    Skilll.transaction do
      #clean up cruft first
      ItemSkill.delete_all('skilll_id = 0')
      ##
      self.move_skill_to(33, 1)
      self.move_skill_to(44, 20)
      self.move_skill_to(35, 2)
      self.move_skill_to(45, 21)
      self.move_skill_to(46, 22)
      self.move_skill_to(47, 23)
      self.move_skill_to(36, 3)
      self.move_skill_to(37, 4)
      self.move_skill_to(48, 24)
      self.move_skill_to(38, 5)
      self.move_skill_to(49, 25)
      self.move_skill_to(50, 26)
      self.move_skill_to(51, 27)
      self.move_skill_to(39, 7)
      self.move_skill_to(32, 8)
      self.move_skill_to(52, 28)
      self.move_skill_to(53, 29)
      self.move_skill_to(40, 9)
      self.move_skill_to(54, 30)
    end

  end

  def self.down
  end


end
