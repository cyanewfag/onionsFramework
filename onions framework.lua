local guiInfo = { 100, 100, 250, 350, false, 0, 0 };
local colors = { color.new(20, 20, 20, 255), color.new(30, 30, 30, 255), color.new(125, 125, 125, 255), color.new(40, 40, 40, 255), color.new(45, 45, 45, 255), color.new(255, 255, 255, 255), color.new(35, 35, 35, 255) };
local fonts = { renderer.create_font("Verdana", 10, false), renderer.create_font("Verdana", 12, false) };
local mousePos;
local mouseDown = { false, 0, 0 };
local keyArray = { {0x41, "A"}, {0x42, "B"}, {0x43, "C"}, {0x44, "D"}, {0x45, "E"}, {0x46, "F"}, {0x47, "G"}, {0x48, "H"}, {0x49, "I"}, {0x4A, "J"}, {0x4B, "K"}, {0x4C, "L"}, {0x4D, "M"}, {0x4E, "N"}, {0x4F, "O"}, {0x50, "P"}, {0x51, "Q"}, {0x52, "R"}, {0x53, "S"}, {0x54, "T"}, {0x55, "U"}, {0x56, "V"}, {0x57, "W"}, {0x58, "X"}, {0x59, "Y"}, {0x5A, "Z"}, {0x20, " "}, {0xBC, ","}, {0xBD, "-"}, {0xBE, "."}, {0xBB, "+"}, {0xDE, "\""}, {0xDC, "|"} };
local keyPressTable = {};
local drawColor = { false, "", 0, 0 }

local vars = {
    { "onion_gui_enabled", true, 0x4D, "M", false },
    { "onion_gui_draggable", true },
    { "onion_hud_enabled", true },
    { "onion_hud_drag", false },
    { "onion_hud_color", false, 40, 175, 247, 255 },
    { "onion_hud_text_divider", "|", false }
};

local function checkVar(var, index)
    for i = 1, #vars do
        if (vars[i][1] == var) then
            if (index == nil) then
                return vars[i][2];
            else
                return vars[i][index];
            end
        end
    end
end

local function setVar(var, value, index)
    for i = 1, #vars do
        if (vars[i][1] == var) then
            if (index == nil) then
                vars[i][2] = value;
            else
                vars[i][index] = value;
            end
        end
    end
end

local function grabColor(var)
    return color.new(checkVar(var, 3), checkVar(var, 4), checkVar(var, 5), checkVar(var, 6))
end

local function onionTextbox(x, y, w, var, limit)
    renderer.rect( x, y, w, 18, colors[2]);
    renderer.filled_rect( x + 1, y + 1, w - 2, 16, colors[5]);
    renderer.rect( x + 3, y + 3, w - 6, 12, colors[2]);
    renderer.filled_rect( x + 4, y + 4, w - 8, 10, colors[1]);

    if (mousePos.x >= x and mousePos.x <= x + w and mousePos.y >= y and mousePos.y <= y + 18) then
        if (mouseDown[1]) then
            renderer.filled_rect( x + 5, y + 5, w - 10, 8, colors[5]);
        else
            renderer.filled_rect( x + 5, y + 5, w - 10, 8, colors[4]);
        end

        if (keys.key_pressed(0x01)) then
            setVar(var, true, 3);
        end
    else
        if (keys.key_pressed(0x01)) then
            setVar(var, false, 3);
        end

        if (checkVar(var, 3)) then
            renderer.filled_rect( x + 5, y + 5, w - 10, 8, colors[5]);
        end
    end

    if (checkVar(var, 3)) then
        if (keys.key_pressed(0x08)) then
            setVar(var, string.sub(checkVar(var), 1, -2));
        end

        if (keys.key_pressed(0x0D) or keys.key_pressed(0x09)) then
            setVar(var, false, 3);
        end
    end

    if (checkVar(var, 3)) then
        local stringAdder = "";
        if (#keyPressTable > 0) then
            for i = 1, #keyPressTable do
                stringAdder = stringAdder .. keyPressTable[i][2];
            end
        end

        if (stringAdder ~= nil) then
            if (limit == nil) then
                if (keys.key_down(0x10)) then
                    setVar(var, checkVar(var) .. stringAdder);
                else
                    setVar(var, checkVar(var) .. string.lower(stringAdder));
                end
            elseif (#checkVar(var) + #stringAdder <= limit) then
                if (keys.key_down(0x10)) then
                    setVar(var, checkVar(var) .. stringAdder);
                else
                    setVar(var, checkVar(var) .. string.lower(stringAdder));
                end
            end
        end
    end

    local a = renderer.get_text_size("J", fonts[2]);
    local allowedChars = (w - 10) / a.x;

    local text = checkVar(var);
    if (#text > allowedChars) then
        text = string.sub(text, 1, allowedChars);
    end

    local textSize = renderer.get_text_size(text, fonts[2]);
    renderer.text(x + 5, y + (9 - (textSize.y / 2)), text, colors[6], fonts[2]);
end

local function onionCheckbox(x, y, z, text, var)
    local enabled = checkVar(var);

    renderer.rect( x, y, z, z, colors[2]);
    renderer.filled_rect( x + 1, y + 1, z - 2, z - 2, colors[5]);
    renderer.rect( x + 3, y + 3, z - 6, z - 6, colors[2]);
    renderer.filled_rect( x + 4, y + 4, z - 8, z - 8, colors[1]);

    if (enabled) then
        renderer.filled_rect( x + 6, y + 6, z - 12, z - 12, colors[7]);
    end

    local textSize = renderer.get_text_size(text, fonts[2]);

    if (mousePos.x >= x and mousePos.x <= x + z + textSize.x + 6 and mousePos.y >= y and mousePos.y <= y + z) then
        if (mouseDown[1] == false) then
            renderer.filled_rect( x + 6, y + 6, z - 12, z - 12, colors[5]);
        else
            renderer.filled_rect( x + 6, y + 6, z - 12, z - 12, colors[4]);
        end

        if (keys.key_pressed(0x01)) then
            setVar(var, not checkVar(var));
        end
    end

    renderer.text(x + z + 6, y + ((z / 2) - (textSize.y / 2)), text, colors[6], fonts[2]);
end

local function onionIntSlider(x, y, w, text, var, min, max, index)
    if (min <= max) then
        local curValue;

        if (index == nil) then
            curValue = checkVar(var);
        else
            curValue = checkVar(var, index);
        end

        local addedValue = max / w;

        if (mouseDown[1]) then
            if (mouseDown[2] >= x and mouseDown[2] <= x + w and mouseDown[3] >= y and mouseDown[3] <= y + 10) then
                if (mousePos.x >= x and mousePos.x <= x + w) then
                    if (index == nil) then
                        setVar(var, addedValue * (mousePos.x - x));
                    else
                        setVar(var, addedValue * (mousePos.x - x), index);
                    end
                else
                    if (mousePos.x >= x) then                    
                        if (index == nil) then
                            setVar(var, max);
                        else
                            setVar(var, max, index);
                        end
                    else
                        if (index == nil) then
                            setVar(var, min);
                        else
                            setVar(var, min, index);
                        end
                    end
                end
            end
        end

        renderer.filled_rect(x, y + 3, w, 4, colors[2]);
        renderer.filled_rect(x, y, 2, 10, colors[2]);
        renderer.filled_rect(x + w - 2, y, 2, 10, colors[2]);
        renderer.filled_rect(x + (curValue / addedValue), y, 1, 10, colors[5]);
        renderer.text(x + (curValue / addedValue) + 5, y, tostring(math.floor(curValue)), colors[6], fonts[2]);

        local textSize = renderer.get_text_size(text, fonts[2]);
        renderer.text(x, y + 10 + 2, text, colors[6], fonts[2]);
    end
end

local function onionColorPicker(x, y, z, text, var)
    local opened = checkVar(var);
    local textSize = renderer.get_text_size(text, fonts[2]);

    renderer.filled_rect( x, y, z, z, grabColor(var));
    renderer.rect( x, y, z, z, colors[3]);
    renderer.text(x + z + 6, y + ((z / 2) - (textSize.y / 2)), text, colors[6], fonts[2]);

    if (mousePos.x >= x and mousePos.x <= x + z + textSize.x + 6 and mousePos.y >= y and mousePos.y <= y + z) then
        if (keys.key_pressed(0x01)) then
            setVar(var, not checkVar(var));
            drawColor[1] = checkVar(var);
            drawColor[2] = var;
            drawColor[3] = x + z + 6;
            drawColor[4] = y;
        end
    else
        if (opened) then
            if (mousePos.x <= x + z + 6 or mousePos.x >= x + z + 166 or mousePos.y <= y or mousePos.y >= y + 122) then
                if (keys.key_pressed(0x01)) then
                    setVar(var, false);
                    drawColor[1] = false;
                end
            end
        end
    end
end

local function drawColorPicker()
    if (drawColor[1]) then
        renderer.filled_rect( drawColor[3], drawColor[4], 160, 122, colors[1]);
        renderer.rect( drawColor[3], drawColor[4], 160, 122, colors[3]);
        renderer.filled_rect(drawColor[3] + 138, drawColor[4] + 6, 16, 108, grabColor(drawColor[2]));
        renderer.rect( drawColor[3] + 138, drawColor[4] + 6, 16, 108, colors[3]);

        onionIntSlider(drawColor[3] + 6, drawColor[4] + 12, 100, "Red Value", drawColor[2], 0, 255, 3);
        onionIntSlider(drawColor[3] + 6, drawColor[4] + 38, 100, "Green Value", drawColor[2], 0, 255, 4);
        onionIntSlider(drawColor[3] + 6, drawColor[4] + 64, 100, "Blue Value", drawColor[2], 0, 255, 5);
        onionIntSlider(drawColor[3] + 6, drawColor[4] + 90, 100, "Alpha Value", drawColor[2], 0, 255, 6);
    end
end

local function onionKeybind(x, y, text, var)
    local enabled = checkVar(var);
    local textSize = renderer.get_text_size(checkVar(var, 4), fonts[2]);

    renderer.rect( x, y, textSize.x + 16, 18, colors[2]);
    renderer.filled_rect( x + 1, y + 1, textSize.x + 14, 16, colors[5]);
    renderer.rect( x + 3, y + 3, textSize.x + 10, 12, colors[2]);
    renderer.filled_rect( x + 4, y + 4, textSize.x + 8, 10, colors[1]);

    if (checkVar(var, 5)) then
        if (#keyPressTable ~= 0) then
            setVar(var, keyPressTable[1][1], 3);
            setVar(var, keyPressTable[1][2], 4);
            setVar(var, false, 5)
        end
    end

    if (keys.key_pressed(checkVar(var, 3))) then
        setVar(var, not checkVar(var))
    end

    if (keys.key_pressed(0x01)) then
        if (mouseDown[1] and mouseDown[2] >= x and mouseDown[2] <= x + textSize.x + 16 and mouseDown[3] >= y and mouseDown[3] <= y + 18) then
            setVar(var, true, 5)
        end
    end

    if (checkVar(var, 5) or mousePos.x >= x and mousePos.x <= x + textSize.x + 16 and mousePos.y >= y and mousePos.y <= y + 18) then
        renderer.filled_rect( x + 5, y + 5, textSize.x + 6, 8, colors[5]);
    end

    renderer.text(x + 8, y + ((18 / 2) - (textSize.y / 2)), checkVar(var, 4), colors[6], fonts[2]);
end

local function drawGUI()
    if (guiOpened) then
        renderer.filled_rect(guiInfo[1], guiInfo[2], guiInfo[3], guiInfo[4], colors[1]);
        renderer.filled_rect(guiInfo[1], guiInfo[2], guiInfo[3], 20, colors[2]);
        renderer.rect(guiInfo[1], guiInfo[2], guiInfo[3], guiInfo[4], colors[3]);
        renderer.rect(guiInfo[1], guiInfo[2], guiInfo[3], 20, colors[3]);

        onionCheckbox( guiInfo[1] + 10, guiInfo[2] + 30, 18, "Draggable", "onion_gui_draggable" );
        onionCheckbox( guiInfo[1] + 10, guiInfo[2] + 54, 18, "Enable HUD", "onion_hud_enabled" );
        onionCheckbox( guiInfo[1] + 10, guiInfo[2] + 78, 18, "Draggable HUD", "onion_hud_drag" );
        onionColorPicker( guiInfo[1] + 10, guiInfo[2] + 102, 18, "HUD Color", "onion_hud_color" );
        onionKeybind( guiInfo[1] + 10, guiInfo[2] + 126, "peepee", "onion_gui_enabled" );
        onionTextbox( guiInfo[1] + 10, guiInfo[2] + 150, 100, "onion_hud_text_divider", 1 );
    end
end

local hudInfo = { 10, 10 }
local function drawHUD()
    if (checkVar("onion_hud_enabled")) then
        local divide = " " .. checkVar("onion_hud_text_divider") .. " ";
        local text = zapped.username .. divide .. zapped.userid .. divide .. zapped.users_online;
        local textSize = renderer.get_text_size(text, fonts[2]);
        renderer.filled_rect(hudInfo[1], hudInfo[2] + 2, textSize.x + 12, textSize.y + 4, color.new(20, 20, 20, 150));
        renderer.filled_rect(hudInfo[1], hudInfo[2], textSize.x + 12, 2, grabColor("onion_hud_color"));
        renderer.text(hudInfo[1] + 6, hudInfo[2] + 4, text, colors[6], fonts[2]);
    end
end

local function inputHandler()
    if (keys.key_pressed(checkVar("onion_gui_enabled", 3))) then
        guiOpened = not guiOpened;
        
        if (guiOpened == false) then
            drawColor[1] = false;
        end
    end

    mousePos = keys.get_mouse();

    if (keys.key_down(0x01)) then
        if (mouseDown[1] == false) then
            mouseDown[1] = true;
            mouseDown[2], mouseDown[3] = mousePos.x, mousePos.y;

            if (mousePos.x >= guiInfo[1] and mousePos.x <= guiInfo[1] + guiInfo[3] and mousePos.y >= guiInfo[2] and mousePos.y <= guiInfo[2] + 20) then
                guiInfo[5] = true;
                guiInfo[6], guiInfo[7] = mousePos.x - guiInfo[1], mousePos.y - guiInfo[2];
            end
        elseif (guiInfo[5] and checkVar("onion_gui_draggable")) then
            guiInfo[1], guiInfo[2] = mousePos.x - guiInfo[6], mousePos.y - guiInfo[7];
        end
    else
        if (mouseDown[1]) then
            mouseDown[1] = false;
            mouseDown[2], mouseDown[3] = 0, 0;
            guiInfo[5] = false;
            guiInfo[6], guiInfo[7] = 0, 0;
        end
    end

    keyPressTable = {};
    for i = 1, #keyArray do
        if (keyArray[i][1] ~= nil) then
            if (keys.key_pressed(keyArray[i][1])) then
                table.insert(keyPressTable, {keyArray[i][1], keyArray[i][2]});
            end
        end
    end
end

function on_render()
    inputHandler();
    drawGUI();
    drawHUD();
    drawColorPicker();
end
