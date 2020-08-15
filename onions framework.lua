local guiOpened = false;
local guiInfo = { 100, 100, 250, 350, false, 0, 0 };
local colors = { color.new(20, 20, 20, 255), color.new(30, 30, 30, 255), color.new(125, 125, 125, 255), color.new(40, 40, 40, 255), color.new(45, 45, 45, 255), color.new(255, 255, 255, 255), color.new(35, 35, 35, 255) };
local fonts = { renderer.create_font("Verdana", 10, false), renderer.create_font("Verdana", 12, false) };
local mousePos;
local mouseDown = { false, 0, 0 };

local vars = {
    { "onion_gui_draggable", true },
    { "onion_hud_enabled", true },
    { "onion_hud_drag", false },
    { "onion_hud_color", false, 40, 175, 247, 255 }
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

    renderer.filled_rect( x, y, z, z, color.new(checkVar(var, 3), checkVar(var, 4), checkVar(var, 5), checkVar(var, 6)));
    renderer.rect( x, y, z, z, colors[3]);
    renderer.text(x + z + 6, y + ((z / 2) - (textSize.y / 2)), text, colors[6], fonts[2]);

    if (mousePos.x >= x and mousePos.x <= x + z + textSize.x + 6 and mousePos.y >= y and mousePos.y <= y + z) then
        if (keys.key_pressed(0x01)) then
            setVar(var, not checkVar(var));
        end
    else
        if (opened) then
            if (mousePos.x <= x + z + 6 or mousePos.x >= x + z + 306 or mousePos.y <= y or mousePos.y >= y + 200) then
                if (keys.key_pressed(0x01)) then
                    setVar(var, false);
                end
            end
        end
    end

    if (opened) then
        renderer.filled_rect( x + z + 6, y, 160, 122, colors[1]);
        renderer.rect( x + z + 6, y, 160, 122, colors[3]);
        renderer.filled_rect( x + z + 6 + 138, y + 6, 16, 108, color.new(checkVar(var, 3), checkVar(var, 4), checkVar(var, 5), checkVar(var, 6)));
        renderer.rect( x + z + 6 + 138, y + 6, 16, 108, colors[3]);

        onionIntSlider(x + z + 12, y + 12, 100, "Red Value", "onion_hud_color", 0, 255, 3);
        onionIntSlider(x + z + 12, y + 38, 100, "Green Value", "onion_hud_color", 0, 255, 4);
        onionIntSlider(x + z + 12, y + 64, 100, "Blue Value", "onion_hud_color", 0, 255, 5);
        onionIntSlider(x + z + 12, y + 90, 100, "Alpha Value", "onion_hud_color", 0, 255, 6);
    end
end

local function drawGUI()
    if (guiOpened) then
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

        renderer.filled_rect(guiInfo[1], guiInfo[2], guiInfo[3], guiInfo[4], colors[1]);
        renderer.filled_rect(guiInfo[1], guiInfo[2], guiInfo[3], 20, colors[2]);
        renderer.rect(guiInfo[1], guiInfo[2], guiInfo[3], guiInfo[4], colors[3]);
        renderer.rect(guiInfo[1], guiInfo[2], guiInfo[3], 20, colors[3]);

        onionCheckbox( guiInfo[1] + 10, guiInfo[2] + 30, 18, "Draggable", "onion_gui_draggable" );
        onionCheckbox( guiInfo[1] + 10, guiInfo[2] + 54, 18, "Enable HUD", "onion_hud_enabled" );
        onionCheckbox( guiInfo[1] + 10, guiInfo[2] + 78, 18, "Draggable HUD", "onion_hud_drag" );
        onionColorPicker( guiInfo[1] + 10, guiInfo[2] + 102, 18, "HUD Color", "onion_hud_color");
    end
end

local hudInfo = { 10, 10 }
local function drawHUD()
    if (checkVar("onion_hud_enabled")) then
        local text = zapped.username .. " | " .. zapped.userid .. " | " .. zapped.users_online;
        local textSize = renderer.get_text_size(text, fonts[2]);
        renderer.filled_rect(hudInfo[1], hudInfo[2] + 2, textSize.x + 12, textSize.y + 4, color.new(20, 20, 20, 150));
        renderer.filled_rect(hudInfo[1], hudInfo[2], textSize.x + 12, 2, color.new(checkVar("onion_hud_color", 3), checkVar("onion_hud_color", 4), checkVar("onion_hud_color", 5), checkVar("onion_hud_color", 6)));
        renderer.text(hudInfo[1] + 6, hudInfo[2] + 4, text, colors[6], fonts[2]);
    end
end

function on_render()
    if (keys.key_pressed(0x4D)) then
        guiOpened = not guiOpened;
    end

    mousePos = keys.get_mouse();

    drawGUI();
    drawHUD();
end