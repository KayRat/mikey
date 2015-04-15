local objKick = mike.plugins.get("Kick")

function objKick:onRun(objPl, strFirst)
    print("serverside onRun kick ran by", objPl, strFirst)
end

mike.plugins.add(objKick)
