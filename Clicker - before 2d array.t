import GUI
View.Set("graphics:max,max")
type skin :
    record
        skinName : string
        weaponName : string
        skinClass : string
        image : int
        sprite : int
        skinPriceFN : real
        skinPriceMW : real
        skinPriceFT : real
        skinPriceWW : real
        skinPriceBS : real
    end record

% Top level: array of cases
% 1 : Chroma I
% Second Level: array of array(qualities)
% 1: Covert, 2: Classified, 3: Restricted, 4: Mil-Spec, 5: Exceedingly Rare
% Third level: array of record(skins)
var streamNumber : int
var chromaI : array 1 .. 14 of skin
var filename : string
var caseLength : int := -2
var count : int := 0
var namePart : int := 1
var namePos : int := 0 %Holds the current character in the file name being accessed
var randSkin : int := 1
var step : int := 0
var move : real := 1
var x : real := 1
var rollCycle : int := 0
var rollSpeed : int := 10
var roll : real
streamNumber := Dir.Open("skins/Chroma 1")

for i : -1 .. 14
    filename := Dir.Get(streamNumber)
    if count > 1 then
        chromaI(i).image := Pic.FileNew("skins/Chroma 1/"+filename)
        chromaI(i).sprite := Sprite.New(chromaI(i).image)
            for b : namePos + 1.. length(filename)
                if filename(b) = "," or ((length(filename) - namePos) < 9 and filename(b) = ".")then
                    if namePart = 1 then
                        chromaI(i).skinName := filename(namePos+1..(b)-1)
                        namePos := b
                        namePart += 1
                        break
                    elsif namePart = 2 then
                        chromaI(i).weaponName := filename(namePos+1..(b)-1)
                        namePos := b
                        namePart += 1
                        break
                    elsif namePart = 3 then
                        chromaI(i).skinClass := filename(namePos+1..(b)-1)
                        if chromaI(i).skinClass = "Covert" then
                            new skinClasses(1,1), upper(skinClasses(1,1) + 1
                            skinClasses(1,1,upper(skinClasses(1,1))) := chromaI(i)

                        end if
                        namePos := b
                        namePart += 1
                        break
                    elsif namePart = 4 then
                        chromaI(i).skinPriceFN := strreal(filename(namePos+1..(b)-1))
                        namePos := b
                        namePart += 1
                        break
                    elsif namePart = 5 then
                        chromaI(i).skinPriceMW := strreal(filename(namePos+1..(b)-1))
                        namePos := b
                        namePart += 1
                        break
                    elsif namePart = 6 then
                        chromaI(i).skinPriceFT := strreal(filename(namePos+1..(b)-1))
                        namePos := b
                        namePart += 1
                        break
                    elsif namePart = 7 then
                        chromaI(i).skinPriceWW := strreal(filename(namePos+1..(b)-1))
                        namePos := b
                        namePart +=1
                        break
                    elsif namePart = 8 then
                        chromaI(i).skinPriceBS := strreal(filename(namePos+1..(b)-1))
                        namePos := b
                        namePart +=1
                        break
                    end if
                end if
            end for
        namePart := 1
        namePos := 0
    end if 
    count += 1
end for

for i : 1 .. 14
    put chromaI(i).skinName
    put chromaI(i).weaponName
    put chromaI(i).skinClass
    put chromaI(i).skinPriceFN
    put chromaI(i).skinPriceMW
    put chromaI(i).skinPriceFT
    put chromaI(i).skinPriceWW
    put chromaI(i).skinPriceBS
    delay(2000)
end for

procedure randCase
    Sprite.Hide(chromaI(randSkin).sprite)
    cls
    randSkin := Rand.Int(1,upper(chromaI))
    put chromaI(randSkin).skinName
    put chromaI(randSkin).weaponName
    Sprite.SetPosition(chromaI(randSkin).sprite,200,200,true)
    Sprite.Show(chromaI(randSkin).sprite)
    put "Factory New Price: $",chromaI(randSkin).skinPriceFN
    var button : int := GUI.CreateButton(600,100,0,"Open a Case",randCase)
    loop
        exit when GUI.ProcessEvent
    end loop
end randCase

%roll
procedure openCase(crate : array 1 .. * of skin)
loop
    roll := Rand.Real
    if roll <= 0.7954 then
        
    end if
    Sprite.Show(chromaI(2).sprite)
    Sprite.Animate(chromaI(2).sprite,chromaI(2).image,step,300,true)
    Sprite.Show(chromaI(1).sprite)
    Sprite.Animate(chromaI(1).sprite,chromaI(1).image,step+360,300,true)
    View.Update
    put rollSpeed
    step := step + rollSpeed
    delay(5)
    rollCycle += 1
    if rollCycle > 100 then
    if rollCycle > 14 then
        rollSpeed -= 1
        rollCycle := 0
    end if
    end if
    exit when rollSpeed = 0
end loop
end openCase
openCase(chromaI)

