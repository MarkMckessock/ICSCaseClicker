% CS GO Case Opener - Created by Mark Mckessock for ICS3UG
% Program Description:
% The program goes through a directory containing the images to be used as skins.
% The program gets the file names which contain the skin name, weapon name, weapon grade and the various prices.
% The filenames are split into strings and assigned to an array of records.
% 6 skins are chosen according to accurate odds in the randSkin procedure, 1 of which is the winner
% The winning skin is added to a flexible array for the inventory. 
% The items can be sold from the inventory and the higher items are shifted down and the top element of the array is deleted.
% Duplicate items are possible in the spin but are generated according to chance
% The outcome of the spin is decided before it starts and the spin is just for show(just like the American election)
import GUI

View.Set("graphics:1150,640,offscreenonly")

type skin : % Main 'skin' type
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
%%%%% Images %%%%%
var sell : int := Pic.FileNew("images/sellButton.jpg")
var openButton : int := Pic.FileNew("images/openCaseButton.jpg")
var inventoryBtn : int := Pic.FileNew("images/invButton.jpg")
var walletJPG : int := Pic.FileNew("images/wallet.gif")
var blankBG : int := Pic.FileNew("images/Blank BG.jpg")
var buyButton : int := Pic.FileNew("images/buyButton.jpg")
var background : int := Pic.FileNew("images/Case OpenerBG1.jpg")
var rightClip : int := Pic.FileNew("images/Case OpenerBGRight.jpg")
var leftClip : int := Pic.FileNew("images/Case OpenerBGLeft.jpg")
var chromaIskin : int := Pic.FileNew("images/chromaIskins.jpg")
var openCaseButton : int := Sprite.New(openButton)
%%%%% Sprites %%%%%
var invButton : int := Sprite.New(inventoryBtn)
var wallet : int := Sprite.New(walletJPG)
var buySprite : int := Sprite.New(buyButton)
var chromaIskins : int := Sprite.New(chromaIskin)
var leftSprite : int := Sprite.New(leftClip)
var rightSprite : int := Sprite.New(rightClip)
%%%%% Fonts %%%%%
var font1 : int := Font.New("sans serif:12")
%%%%% VARs %%%%%
var money : real := 50.00
var xloc,y,button,streamNumber : int 
var exteriorRoll : int % Roll that checks for weapon quality
var statRoll : int % Roll that checks for stat trak
var inventory : flexible array 1 .. 0 of skin % Array that hold inv items
var drawSkins : array 1 .. 4, 1.. 2 of int % Array that holds the random skins that roll with the winning skin and their original indexes in the chromaI array for reference
var rolledSkin : int := 1 %Index of the winning item in the chromaI array
var sortSkin : flexible array 1 .. 0 of int % Array that holds the skins of a given quality during the random process
var chromaI : array 1 .. 14 of skin % Main array that holds all of the items of type skin
var filename : string %Gets the filename from the items in the folder
var count : int := 0 % stops the filenaming program from reading the '.' and '..' items in the folder
var namePart : int := 1 % Holds the part of the name being analyzed eg. "Cartel","AK-47" and "Classified" would all have consecutive namePart values
var namePos : int := 0 %Holds the current character in the file name being accessed
var step : array 1 .. upper(drawSkins)+1 of int % Holds the position variables for the skins that are animated
var rollCycle : int := -150 % Forces the program to roll the skins at a constant speed for a short time before slowing down
var baseRollSpeed : int := 25 %Allows the default roll speed to be reset every roll
var rollSpeed : int := baseRollSpeed
var roll : real % The roll value from 0.00 to 1.00 for the main randSkin function

procedure readFiles
    streamNumber := Dir.Open("images/skins/Chroma 1")
    for i : -1 .. 14
        filename := Dir.Get(streamNumber)
        if count > 1 then
            chromaI(i).image := Pic.FileNew("images/skins/Chroma 1/"+filename)
            chromaI(i).sprite := Sprite.New(chromaI(i).image)
            for b : namePos + 1.. length(filename)
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
end readFiles

readFiles

function randSkin (crate : array 1 .. * of skin): int % takes an array of skins and returns an index for an item in that array generated according to the percentages from CS GO
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

procedure addInvItem %Duplicates the winning item to the inventory array
    new inventory, upper(inventory)+1
    inventory(upper(inventory)).skinName := chromaI(rolledSkin).skinName
    inventory(upper(inventory)).weaponName := chromaI(rolledSkin).weaponName
    inventory(upper(inventory)).skinClass := chromaI(rolledSkin).skinClass
    inventory(upper(inventory)).sprite := chromaI(rolledSkin).sprite
    randint(statRoll,0,100) %Roll to see if the item is StatTrak (%7 chance)    
    randint(exteriorRoll,1,5) % Rolle to see the quality of the skin(equal % chance for each)    
    if statRoll < 7 then
        inventory(upper(inventory)).statTrak := true
    else
        inventory(upper(inventory)).statTrak := false
    end if
    if exteriorRoll = 1 then
        inventory(upper(inventory)).weaponQuality := "Factory New"
        if inventory(upper(inventory)).statTrak then
            inventory(upper(inventory)).price := chromaI(rolledSkin).skinPriceFN * 2 % StatTrak means double price
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

procedure hideSprites % Hides all the main sprites when changing screens
    Sprite.Hide(leftSprite)
    Sprite.Hide(rightSprite)
    Sprite.Hide(buySprite)
    Sprite.Hide(chromaIskins)
    Sprite.Hide(chromaI(rolledSkin).sprite)
    for i : 1 .. upper(drawSkins)
        Sprite.Hide(drawSkins(i,1))
    end for
        for i : 1 .. upper(inventory)
        Sprite.Hide(inventory(i).sprite)
    end for
        Sprite.Hide(openCaseButton)
end hideSprites

procedure sellItem(index : int) %Removes the item indicated by the index argument from the inventory array and adds its value to the wallet
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
        Sprite.SetPosition(wallet,maxx-140,maxy-70,true)
        Font.Draw("$" + realstr(money,4),maxx-110,maxy - 75,font1,white)
        if upper(inventory) > 0 and upper(inventory) < 7 then %If there are only six or less items it only needs one row
            for i : 1 .. 6
                if i <= upper(inventory) then
                    Sprite.SetPosition(inventory(i).sprite,i*150-80,maxy-40,true)
                    Sprite.Show(inventory(i).sprite)
                    Font.Draw(inventory(i).weaponName + " - " + inventory(i).skinName,i*150-(150-i),maxy-110,font1,white)
                    Draw.Line(i*150+i,maxy-151,i*150+i,maxy,black)
                    Draw.Line(0,maxy-151,i*150,maxy-151,black)
                    Pic.Draw(sell,i*150-(150-i),maxy-150,0)
                    if xloc > i*150-150 and xloc < i*150 and y > maxy-153 and y < maxy-119 and button = 1 then
                        cls
                        hideSprites
                        Pic.Draw(blankBG,0,0,0)
                        sellItem(i)
                    end if
                end if
                Sprite.Show(openCaseButton)
                delay(10)
            end for
            elsif upper(inventory) > 6 then % If two rows are needed...
            for i : 1 .. 6
                if i <= upper(inventory) then
                    Sprite.SetPosition(inventory(i).sprite,i*150-80,maxy-40,true)
                    Sprite.Show(inventory(i).sprite)
                    Font.Draw(inventory(i).weaponName + " - " + inventory(i).skinName,i*150-(150-i),maxy-110,font1,white)
                    Draw.Line(i*150+i,maxy-151,i*150+i,maxy,black)
                    Draw.Line(0,maxy-151,i*150,maxy-151,black)
                    Pic.Draw(sell,i*150-(150-i),maxy-150,0)
                    if xloc > i*150-150 and xloc < i*150 and y > maxy-153 and y < maxy-119 and button = 1 then
                        cls
                        hideSprites
                        Pic.Draw(blankBG,0,0,0)
                        sellItem(i)
                    end if
                end if
                Sprite.Show(openCaseButton)
                delay(10)
            end for
                for i : 7 .. upper(inventory)
                if i <= upper(inventory) then
                    Sprite.SetPosition(inventory(i).sprite,i*150-970,440,true)
                    Sprite.Show(inventory(i).sprite)
                    Font.Draw(inventory(i).weaponName + " - " + inventory(i).skinName,i*150-(1050-i),489-110,font1,white)
                    Draw.Line(i*150-900+(i-6),489-151,i*150-900+(i-6),maxy,black)
                    Draw.Line(0,489-151,i*150-900,489-151,black)
                    Pic.Draw(sell,i*150-(1050-(i-6)),489-150,0)
                    if xloc > i*150-1050 and xloc < i*150-900 and y > 489-153 and y < 489-119 and button = 1 then
                        cls
                        hideSprites
                        Pic.Draw(blankBG,0,0,0)
                        sellItem(i)
                    end if
                end if
            end for
        end if
        Sprite.SetPosition(openCaseButton,maxx-100,maxy-23,true)
        Sprite.Show(openCaseButton)
        mousewhere(xloc,y,button)
        exit when xloc > 945 and xloc < 1149 and y > 593 and y < 635 and button = 1
    end loop
end invScreen

procedure openCase(crate : array 1 .. * of skin)
    
    %%%%% fills the drawSkins array with a set of random skins %%%%%
    for i : 1 .. upper(drawSkins)
        drawSkins(i,2) := randSkin(crate)
        drawSkins(i,1) := Sprite.New(chromaI(drawSkins(i,2)).image)
    end for
    %%%%% Main Program Loop %%%%%
    loop
        cls
        Sprite.Show(wallet)
        for i : 1 .. upper(inventory)
            Sprite.Hide(inventory(i).sprite)
        end for
        %%%%%% Layout/Images %%%%%%%%%%%    
        Pic.Draw(background,0,0,0)
        Font.Draw("$" + realstr(money,4),300,545,font1,white)
        hideSprites
        
        %Reset rollcycle and speed
        rollCycle := 0
        rollSpeed := baseRollSpeed
        %Reset all sprite positions
        for i : 1 .. upper(step)
            step(i) := 150 * i -150
        end for
        %Draw all sprites to screen
        rolledSkin := randSkin(crate)
        Sprite.SetHeight(chromaIskins,0)
        Sprite.SetPosition(chromaIskins,maxx div 2,220,true)
        Sprite.Show(chromaIskins)
        Sprite.SetPosition(buySprite,270,385,true)
        Sprite.Show(buySprite)
        Sprite.SetPosition(invButton,885,385,true)
        Sprite.Show(invButton)
        for i : 1 .. upper(drawSkins)
            drawSkins(i,2) := randSkin(crate)
            drawSkins(i,1) := Sprite.New(crate(drawSkins(i,2)).image)
            Sprite.Show(drawSkins(i,1))
            Sprite.SetHeight(drawSkins(i,1),0)
        end for
            
        Sprite.Show(chromaI(rolledSkin).sprite)
        Sprite.SetHeight(crate(rolledSkin).sprite,0)
        Sprite.SetHeight(rightSprite,0)
        Sprite.SetHeight(leftSprite,0)  
        %%%%% Wait for user i
        loop
            Sprite.SetPosition(wallet,270,maxy-90,true)
            mousewhere(xloc,y,button)
            if xloc > 781 and xloc < 990 and y > 362 and y < 410 and button = 1 then
                Sprite.Hide(invButton)
                invScreen
                hideSprites                
                Pic.Draw(background,0,0,0)
                Sprite.Show(buySprite)
                Sprite.Show(invButton)
                Sprite.Show(chromaIskins)
                Font.Draw("$" + realstr(money,4),300,545,font1,white)
                View.Update
            elsif xloc > 158 and xloc < 380 and y > 362 and y < 410 and button = 1 then
                exit
            end if
        end loop
        %%%%% Animation Loop %%%%%
        money := money - 3.25
        cls
        Pic.Draw(background,0,0,0)
        Font.Draw("$" + realstr(money,4),300,545,font1,white)
        loop
            Sprite.Animate(crate(rolledSkin).sprite,crate(rolledSkin).image,step(1),470,true)
            for i : 2 .. 5
                Sprite.Animate(drawSkins(i-1,1),crate(drawSkins(i-1,2)).image,step(i),470,true)
            end for
                Sprite.SetPosition(rightSprite,870,0,false)
            Sprite.SetPosition(leftSprite,0,0,false)
            Sprite.Show(rightSprite)
            Sprite.Show(leftSprite)
            Sprite.SetHeight(chromaIskins,0)
            Sprite.Show(chromaIskins)
            Draw.ThickLine(maxx div 2,410,maxx div 2, maxy - 110,5,yellow)
            View.Update
            %Loops items
            for i : 1 .. 5 
                if step(i) > 935 then
                    step(i) := step (i)-718
                end if
            end for
            %Changes items position variables    
            for i : 1 .. upper(step)
                step(i) := step(i) + rollSpeed
            end for
            delay(3)
            rollCycle += 1
            %Slows the Roll
            if rollCycle >= 0 then
                if rollCycle > 14 then
                    rollSpeed -= 1
                    rollCycle := 0
                end if
            end if
            exit when rollSpeed = 0
        end loop     
        addInvItem
        %%%%% Print Items details %%%%%
        if inventory(upper(inventory)).statTrak then
            Font.Draw("Stattrak! " + inventory(upper(inventory)).weaponName + " - " + inventory(upper(inventory)).skinName + " (" + inventory(upper(inventory)).weaponQuality + ") $" + realstr(inventory(upper(inventory)).price,4),maxx div 2-180,370,font1,white)
        else
            Font.Draw(chromaI(rolledSkin).weaponName + " - " + chromaI(rolledSkin).skinName + " (" + inventory(upper(inventory)).weaponQuality + ") $" + realstr(inventory(upper(inventory)).price,4),maxx div 2-180,370,font1,white)
        end if 
        View.Update
        %%%%% Wait for input again %%%%%
        loop
            mousewhere(xloc,y,button)
            View.Update
            if xloc > 781 and xloc < 990 and y > 362 and y < 410 and button = 1 then
                Sprite.Hide(invButton)
                invScreen
                exit
            elsif xloc > 158 and xloc < 380 and y > 362 and y < 410 and button = 1 then
                hideSprites   
                openCase(chromaI)
                exit
            end if 
        end loop
    end loop
end openCase
openCase(chromaI)