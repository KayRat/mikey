class "Group" {
  private {
    m_iGroupID        = 0;
    m_strName         = "??";
    m_objColor        = color_black;
    m_iWeight         = 1;
    m_tblPermissions  = {};
  };

  public {
    __construct = function(self, iGroupID, strName, objColor, iWeight)
      self.m_iGroupID       = iGroupID
      self.m_strName        = strName
      self.m_objColor       = objColor
      self.m_iWeight        = iWeight
    end;

    getID           = function(self)
      return self.m_iGroupID
    end;

    getName         = function(self)
      return self.m_strName
    end;

    getColor        = function(self)
      return self.m_objColor
    end;

    getWeight       = function(self)
      return self.m_iWeight
    end;

    addPermission   = function(self, strPermission)
      self.m_tblPermissions[strPermission] = true
    end;

    addPermissions  = function(self, tblPermissions)
      for k,v in pairs(tblPermissions) do
        self:addPermission(k)
      end
    end;

    getPermissions  = function(self)
      return table.Copy(self.m_tblPermissions)
    end;

    hasPermission   = function(self, strPermission)
      return self.m_tblPermissions[strPermission] ~= nil
    end;
  };
}
