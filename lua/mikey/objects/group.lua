class "Group" {
  private {
    m_strName         = "??";
    m_objColor        = color_black;
    m_strInheritsFrom = "";
    m_iWeight         = 1;
    m_tblPermissions  = {};
  };

  public {
    __construct = function(self, strName, objColor, strInheritsFrom, iWeight)
      self.m_strName          = strName
      self.m_objColor         = objColor
      self.m_strInheritsFrom  = strInheritsFrom
      self.m_iWeight          = iWeight
    end;

    getName         = function(self)
      return self.m_strName
    end;

    getColor        = function(self)
      return self.m_objColor
    end;

    getInherited    = function(self)
      return self.m_strInheritsFrom
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
      local strInheritsFrom = self:getInherited()
      return (strInheritsFrom and mikey.groups.get(strInheritsFrom):hasPermission(strPermission)) or self.m_tblPermissions[strPermission] ~= nil
    end;
  };
}
