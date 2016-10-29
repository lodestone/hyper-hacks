-- A global variable for the Hyper Mode
k = hs.hotkey.modal.new({}, "F17")

-- Enter Hyper Mode when F18 (Hyper/Capslock) is pressed
pressedF18 = function()
  k.triggered = false
  k:enter()
  -- hs.alert.show('in')
end

-- HYPER+o: Delete
ofun = function()
  hs.eventtap.keyStroke({}, 'DELETE')
  k.triggered = true
end
k:bind({}, 'o', ofun, nil, ofun)

-- HYPER+Semi: Forward DELETE
semifun = function()
  hs.eventtap.keyStroke({}, 'FORWARDDELETE')
  k.triggered = true
end
k:bind({}, ';', semifun, nil, semifun)

-- Cursor movement modifiers for line, word, selecting, etc.
modifiers = {
  {''},
  {'cmd'},
  {'ctrl'},
  {'alt'},
  {'shift'},
  {'cmd','shift'},
  {'ctrl','shift'},
  {'alt','shift'},
}

-- Keypresses associated with each direction. I use colemak. Change to ijkl for qwerty.
movements = {
 { 'n', 'LEFT'},
 { 'l', 'LEFT'},
 { 'e', 'DOWN'},
 { 'u', 'UP'},
 { 'i', 'RIGHT'},
 { 'y', 'RIGHT'},
 { 'j', 'PAGEUP'},
 { 'h', 'PAGEDOWN'},
}
for j,jmod in ipairs(modifiers) do
  for i,bnd in ipairs(movements) do
    hs.alert.show(i..j)
    i = function()
      hs.eventtap.keyStroke(jmod,bnd[2])
      k.triggered = true
    end
    k:bind(jmod, bnd[1], i, nil, i)
  end
end

-- HYPER+k: Left Mouse Click
kfun = function()
  hs.eventtap.leftClick(hs.mouse.getAbsolutePosition())
  k.triggered = true
end
k:bind({}, 'k', kfun, nil, nil)

-- HYPER+m: Right Mouse Click
mfun = function()
  hs.eventtap.rightClick(hs.mouse.getAbsolutePosition())
  k.triggered = true
end
k:bind({}, 'm', mfun, nil, nil)

-- HYPER+comma: Middle Mouse Click
commafun = function()
  hs.eventtap.middleClick(hs.mouse.getAbsolutePosition())
  k.triggered = true
end
k:bind({}, ',', commafun, nil, nil)

-- HYPER+space: Return
spacefun = function()
  hs.eventtap.keyStroke({}, 'RETURN')
  k.triggered = true
end
k:bind({}, 'SPACE', spacefun, nil, spacefun)

-- HYPER+tilde: swapkeyboard layout
swaplayoutfun = function()
  current = hs.keycodes.currentLayout()
  if current == 'Colemak' then
    hs.keycodes.setLayout('U.S.')
  elseif current == 'U.S.' then
    hs.keycodes.setLayout('Colemak')
  end
  hs.alert.show(hs.keycodes.currentLayout())
  k.triggered = true
end
k:bind({}, '`', 'swapping keyboard layout', swaplayoutfun, nil, nil)

-- HYPER+=: Open Google in the default browser
equalsfun = function()
  launch = "app = Application.currentApplication(); app.includeStandardAdditions = true; app.doShellScript('open https://google.com')"
  hs.osascript.javascript(launch)
  k.triggered = true
end
k:bind('', '=', nil, equalsfun, nil, nil)

-- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed,
--   send ESCAPE if no other keys are pressed.
releasedF18 = function()
  k:exit()
  -- hs.alert.show('out')
  if not k.triggered then
    hs.eventtap.keyStroke({}, 'ESCAPE')
    hs.alert.show('ESCAPE')
  end
end

-- Bind the Hyper key
f18 = hs.hotkey.bind({}, 'F18', pressedF18, releasedF18)

-- Reload config when any lua file in config directory changes
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == '.lua' then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
        print('reloaded')
    end
end
local myWatcher = hs.pathwatcher.new(os.getenv('HOME') .. '/.hammerspoon/', reloadConfig):start()
hs.alert.show(hs.keycodes.currentLayout())
