import GUI
% Add stattrak image
% Fix Sprites

% CS GO Case Opener - Created by Mark Mckessock for ICS3UG
% Program Description:
% The program goes through a directory containing the images to be used as skins.
% The program gets the file names which contain the skin name, weapon name, weapon grade and the various prices.
% The filenames are split into strings and assigned to an array of records.
% 6 skins are chosen according to accurate odds in the randSkin procedure, 1 of which is the winner
% The winning skin is added to a flexible array for the inventory. 
% The items can be sold from the inventory and the higher items are shifted down and the top element of the array is deleted.

View.Set("graphics:1150,640,offscreenonly")
type skin :
record
    skinName : string
    weaponName : string
    skinClass : string
    weaponQuality : string
    statTrak : boolean  
    sold : boolean
    statTrakSprite : int
    image : int
    sprite : int
    price : real
    skinPriceFN : real
    skinPriceMW : real
    skinPriceFT : real
    skinPriceWW : real
    skinPriceBS : real
end record
var inventoryBtn : int := Pic.FileNew("invButton.jpg")
var invButton : int := Sprite.New(inventoryBtn)
var click : int
var firstRun : boolean := true
var money : real := 50.00
var walletJPG : int := Pic.FileNew("wallet.gif")
var wallet : int := Sprite.New(walletJPG)
Sprite.SetPosition(wallet,270,maxy-90,true)
var buttons : array 1 .. 50 of int
var blankBG : int := Pic.FileNew("Blank BG.jpg")
var buyButton : int := Pic.FileNew("buyButton.jpg")
var buySprite : int := Sprite.New(buyButton)
var winSprite,xloc,y,button : int 
%var statTrakImage : int := Pic.FileNew("stattrakimage")
var cardMil : int := Pic.FileNew("Mil-Spec Card.jpg")
var cardMS : int := Sprite.New(cardMil)
var cardCf : int := Pic.FileNew("Classified Card.jpg")
var cardCl : int := Sprite.New(cardCf)
var cardRt : int := Pic.FileNew("Restricted Card.jpg")
var cardRs : int := Sprite.New(cardRt)
var cardCrt : int := Pic.FileNew("Covert Card.jpg")
var cardCv : int := Sprite.New(cardCrt)
var cardEx : int := Pic.FileNew("Exceedingly Rare Card.jpg")
var cardER : int := Sprite.New(cardEx)
var chromaIskin : int := Pic.FileNew("chromaIskins.jpg")
var chromaIskins : int := Sprite.New(chromaIskin)
var exteriorRoll : int % Roll that checks for weapon quality
var statRoll : int % Roll that checks for stat trak
var inventory : flexible array 1 .. 0 of skin
var background : int := Pic.FileNew("Case OpenerBG1.jpg")
var rightClip : int := Pic.FileNew("Case OpenerBGRight.jpg")
var leftClip : int := Pic.FileNew("Case OpenerBGLeft.jpg")
var leftSprite : int := Sprite.New(leftClip)
var rightSprite : int := Sprite.New(rightClip)
var drawSkins : array 1 .. 4, 1.. 2 of int
var rolledSkin : int := 1
var sortSkin : flexible array 1 .. 0 of int
var streamNumber : int
var chromaI : array 1 .. 14 of skin
var filename : string
var caseLength : int := -2
var count : int := 0
var namePart : int := 1
var namePos : int := 0 %Holds the current character in the file name being accessed
var step : array 1 .. upper(drawSkins)+1 of int
var move : real := 1
var x : real := 1
var rollCycle : int := -150
var baseRollSpeed : int := 25
var rollSpeed : int := baseRollSpeed
var roll : real
var font1 : int := Font.New("sans serif:12")
streamNumber := Dir.Open("skins/Chroma 1")

for i : -1 .. 14
    filename := Dir.Get(streamNumber)
    if count > 1 then
        chromaI(i).image := Pic.FileNew("skins/Chroma 1/"+filename)
        chromaI(i).sprite := Sprite.New(chromaI(i).image)
        for b : namePos + 1.. length(filename)
            %if filename(b) = "," or ((length(filename) - namePos) < 6 and filename(b) = ".") then
            if filename(b) = "," then
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

for i : 1 .. upper(chromaI)
    put chromaI(i).skinName
    View.Update
end for
delay(1000)

function randSkin (winning : boolean,crate : array 1 .. * of skin): int
    var temp : int
    new sortSkin, 0
    roll := Rand.Real
    if roll <= 0.7954 and roll > 0 then
        for i : 1 .. upper(chromaI)
            if chromaI(i).skinClass = "Mil-Spec" then
                new sortSkin, upper(sortSkin)+1
                sortSkin(upper(sortSkin)) := i
            end if
        end for
            randint(temp,1, upper(sortSkin))
    elsif roll > 0.7954 and roll <= 0.9575 then
        for i : 1 .. upper(chromaI)
            if chromaI(i).skinClass = "Restricted" then
                new sortSkin, upper(sortSkin)+1
                sortSkin(upper(sortSkin)) := i
            end if
        end for
            randint(temp,1, upper(sortSkin))
    elsif roll > 0.9575 and roll <= 0.9889 then
        for i : 1 .. upper(chromaI)
            if chromaI(i).skinClass = "Classified" then
                new sortSkin, upper(sortSkin)+1
                sortSkin(upper(sortSkin)) := i
            end if
        end for
            randint(temp,1, upper(sortSkin))
    elsif roll > 0.9889 and roll <= 0.9945 then
        for i : 1 .. upper(chromaI)
            if chromaI(i).skinClass = "Covert" then
                new sortSkin, upper(sortSkin)+1
                sortSkin(upper(sortSkin)) := i
            end if
        end for
            randint(temp,1, upper(sortSkin))
    elsif roll > 0.9945 and roll <= 1.00 then
        for i : 1 .. upper(chromaI)
            if chromaI(i).skinClass = "Covert" then
                new sortSkin, upper(sortSkin)+1
                sortSkin(upper(sortSkin)) := i
            end if
        end for
            randint(temp,1, upper(sortSkin))
    end if
    result sortSkin(temp)
end randSkin

procedure addInvItem
    new inventory, upper(inventory)+1
    inventory(upper(inventory)).skinName := chromaI(rolledSkin).skinName
    inventory(upper(inventory)).weaponName := chromaI(rolledSkin).weaponName
    inventory(upper(inventory)).skinClass := chromaI(rolledSkin).skinClass
    inventory(upper(inventory)).sprite := chromaI(rolledSkin).sprite
    randint(statRoll,0,100)    
    randint(exteriorRoll,1,5)    
    if statRoll < 7 then
        inventory(upper(inventory)).statTrak := true
    else
        inventory(upper(inventory)).statTrak := false
    end if
    if exteriorRoll = 1 then
        inventory(upper(inventory)).weaponQuality := "Factory New"
        if inventory(upper(inventory)).statTrak then
            inventory(upper(inventory)).price := chromaI(rolledSkin).skinPriceFN * 2
        else
            inventory(upper(inventory)).price := chromaI(rolledSkin).skinPriceFN
        end if
    elsif exteriorRoll = 2 then
        inventory(upper(inventory)).weaponQuality := "Minimal Wear"
        if inventory(upper(inventory)).statTrak then
            inventory(upper(inventory)).price := chromaI(rolledSkin).skinPriceMW * 2
        else
            inventory(upper(inventory)).price := chromaI(rolledSkin).skinPriceMW
        end if
    elsif exteriorRoll = 3 then
        inventory(upper(inventory)).weaponQuality := "Field Tested"
        if inventory(upper(inventory)).statTrak then
            inventory(upper(inventory)).price := chromaI(rolledSkin).skinPriceFT * 2
        else
            inventory(upper(inventory)).price := chromaI(rolledSkin).skinPriceFT
        end if
    elsif exteriorRoll = 4 then
        inventory(upper(inventory)).weaponQuality := "Well Worn"
        if inventory(upper(inventory)).statTrak then
            inventory(upper(inventory)).price := chromaI(rolledSkin).skinPriceWW * 2
        else
            inventory(upper(inventory)).price := chromaI(rolledSkin).skinPriceWW
        end if
    elsif exteriorRoll = 5 then
        inventory(upper(inventory)).weaponQuality := "Battle Scarred"
        if inventory(upper(inventory)).statTrak then
            inventory(upper(inventory)).price := chromaI(rolledSkin).skinPriceBS * 2
        else
            inventory(upper(inventory)).price := chromaI(rolledSkin).skinPriceBS
        end if
    end if
    inventory(upper(inventory)).sprite := Sprite.New(chromaI(rolledSkin).image)
end addInvItem

procedure hideSprites
    Sprite.Hide(leftSprite)
    Sprite.Hide(rightSprite)
    Sprite.Hide(buySprite)
    Sprite.Hide(cardMS)
    Sprite.Hide(cardCl)
    Sprite.Hide(cardCv)
    Sprite.Hide(cardER)
    Sprite.Hide(cardRs)
    Sprite.Hide(chromaIskins)
    Sprite.Hide(chromaI(rolledSkin).sprite)
    for i : 1 .. upper(drawSkins)
        Sprite.Hide(drawSkins(i,1))
    end for
end hideSprites

procedure sellItem(index : int)
    delay(100)
    if upper(inventory) > 0 then
        if index not= upper(inventory) then
            money := money + inventory(index).price
            Sprite.Hide(inventory(index).sprite)
            for i : index .. (upper(inventory) - 1)
                inventory(i) := inventory(i+1)
            end for
                Sprite.Hide(inventory(index).sprite)
            for i : 1 .. upper(inventory)
                Sprite.Hide(inventory(i).sprite)
            end for
                new inventory, upper(inventory)-1
        else
            money := money + inventory(index).price
            for i : 1 .. upper(inventory)
                Sprite.Hide(inventory(i).sprite)
            end for
                new inventory, upper(inventory)-1
        end if
    end if
end sellItem

procedure invScreen
    cls
    hideSprites
    Pic.Draw(blankBG,0,0,0)
    loop
        if upper(inventory) > 0 then
            for i : 1 .. upper(inventory)
                if i <= upper(inventory) then
                    Sprite.SetPosition(inventory(i).sprite,i*150-80,600,true)
                    Sprite.Show(inventory(i).sprite)
                    Font.Draw(inventory(i).weaponName + " - " + inventory(i).skinName,i*150-140,540,font1,white)
                    %Font.Draw(inventory(i).price,i*150,450,font1,White)
                    %Font.Draw(inventory(i).weaponQuality,i*150,450,font1,White)
                    %if inventory(i).statTrak then
                    %Sprite.SetPosition(inventory(i).statTrakSprite,%X-Pos%,%Y-Pos%)
                    %Sprite.Show(inventory(i).statTrakSprite)
                    %end if
                    Draw.Box(i*150-150,450,i*150,500,black)
                    if xloc > i*150-150 and xloc < i*150 and y > 450 and y < 500 and button = 1 then
                        cls
                        hideSprites
                        Pic.Draw(blankBG,0,0,0)
                        sellItem(i)
                    end if
                end if
            end for
        end if
        Sprite.SetPosition(buySprite,270,385,true)
        Sprite.Show(buySprite)
        mousewhere(xloc,y,button)
        exit when xloc > 158 and xloc < 380 and y > 362 and y < 410 and button = 1
    end loop
end invScreen

procedure openCase(crate : array 1 .. * of skin)
%%%%% fills the drawSkins array with a set of random skins %%%%%
    for i : 1 .. upper(drawSkins)
        drawSkins(i,2) := randSkin(false,crate)
        drawSkins(i,1) := Sprite.New(chromaI(drawSkins(i,2)).image)
    end for
%%%%% Main Program Loop %%%%%
    loop
        money := money - 3.25
        Sprite.Show(wallet)
        for i : 1 .. upper(inventory)
            Sprite.Hide(inventory(i).sprite)
        end for
            %%%%%% Hide Skins %%%%%%%%%%%    
        Pic.Draw(background,0,0,0)
        Font.Draw("$" + realstr(money,4),300,545,font1,white)
        hideSprites
        rollCycle := 0
        rollSpeed := baseRollSpeed
        for i : 1 .. upper(step)
            step(i) := 150 * i -150
        end for
        rolledSkin := randSkin(true,crate)    
        
        for i : 1 .. upper(drawSkins)
            drawSkins(i,2) := randSkin(false,crate)
            drawSkins(i,1) := Sprite.New(crate(drawSkins(i,2)).image)
            Sprite.Show(drawSkins(i,1))
            Sprite.SetHeight(drawSkins(i,1),0)
        end for
            
        Sprite.Show(chromaI(rolledSkin).sprite)
        Sprite.SetPosition(chromaIskins,maxx div 2,220,true)
        Sprite.SetHeight(crate(rolledSkin).sprite,0)
        Sprite.SetHeight(rightSprite,0)
        Sprite.SetHeight(leftSprite,0)
        Sprite.SetHeight(chromaIskins,0)
%%%%% Animation Loop %%%%%
        loop
            Sprite.Animate(crate(rolledSkin).sprite,crate(rolledSkin).image,step(1),470,true)
            for i : 2 .. 5
                Sprite.Animate(drawSkins(i-1,1),crate(drawSkins(i-1,2)).image,step(i),470,true)
            end for
                Sprite.SetPosition(rightSprite,870,0,false)
            Sprite.SetPosition(leftSprite,0,0,false)
            Sprite.Show(rightSprite)
            Sprite.Show(leftSprite)
            Draw.ThickLine(maxx div 2,410,maxx div 2, maxy - 110,5,yellow)
            Sprite.Show(chromaIskins)
            View.Update
            
            for i : 1 .. 5
                if step(i) > 935 then
                    step(i) := step (i)-718
                end if
            end for
                
            for i : 1 .. upper(step)
                step(i) := step(i) + rollSpeed
            end for
                
            delay(3)
            rollCycle += 1
            
            if rollCycle >= 0 then
                if rollCycle > 14 then
                    rollSpeed -= 1
                    rollCycle := 0
                end if
            end if
            
            exit when rollSpeed = 0
        end loop     
        addInvItem
        if inventory(upper(inventory)).statTrak then
            Font.Draw("Stattrak! " + inventory(upper(inventory)).weaponName + " - " + inventory(upper(inventory)).skinName + " (" + inventory(upper(inventory)).weaponQuality + ") $" + realstr(inventory(upper(inventory)).price,4),maxx div 2-180,370,font1,white)
        else
            Font.Draw(chromaI(rolledSkin).weaponName + " - " + chromaI(rolledSkin).skinName + " (" + inventory(upper(inventory)).weaponQuality + ") $" + realstr(inventory(upper(inventory)).price,4),maxx div 2-180,370,font1,white)
        end if 
        View.Update
        loop
            Sprite.SetPosition(buySprite,270,385,true)
            Sprite.Show(buySprite)
            Sprite.SetPosition(invButton,885,385,true)
            Sprite.Show(invButton)
            mousewhere(xloc,y,button)
            View.Update
            if xloc > 781 and xloc < 990 and y > 362 and y < 410 and button = 1 then
                Sprite.Hide(invButton)
                invScreen
                break
            elsif xloc > 158 and xloc < 380 and y > 362 and y < 410 and button = 1 then
                hideSprites   
                openCase(chromaI)
                break
            end if 
        end loop
    end loop
end openCase

if firstRun = true then
    firstRun := false
    openCase(chromaI)
end if
