class MaKinshikei < ActiveRecord::Base
	self.table_name = self.table_name.chomp("s")
end
