namespace "mikey.ranks"

class "Rank" {
  private {
    m_strName         = "??";
    m_iWeight         = 1;
    m_tblPermissions  = {};
  };

  public {
    __construct = function(self, strName, iWeight, tblPermissions)
      self.m_strName        = strName
      self.m_iWeight        = iWeight

      local tblNewPermissions = {}
      for k,v in pairs(tblPermissions) do
        tblNewPermissions[v] = true
      end
      self.m_tblPermissions = tblNewPermissions
    end;

    getName         = function(self)
      return self.m_strName
    end;

    getWeight       = function(self)
      return self.m_iWeight
    end;

    getPermissions  = function(self)
      return table.Copy(self.m_tblPermissions)
    end;

    hasPermission   = function(self, strPermission)
      return self.m_tblPermissions[strPermission] ~= nil
    end;
  };
}
