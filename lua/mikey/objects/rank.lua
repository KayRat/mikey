namespace "mikey.ranks"

class "Rank" {
  private {
    m_strName         = "??";
    m_iWeight         = 1;
    m_tblPermissions  = {};
    m_objColor        = color_black;
  };

  public {
    __construct = function(self, strName, iWeight, tblPermissions, objColor)
      self.m_strName        = strName
      self.m_iWeight        = iWeight

      local tblNewPermissions = {}
      for k,v in pairs(tblPermissions) do
        tblNewPermissions[v] = true
      end
      self.m_tblPermissions = tblNewPermissions
      self.m_objColor = objColor or color_black
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

    getColor        = function(self)
      return self.m_objColor
    end;

    hasPermission   = function(self, strPermission)
      return self.m_tblPermissions[strPermission] ~= nil
    end;
  };
}
