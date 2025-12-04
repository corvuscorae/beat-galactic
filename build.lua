return {
  
  -- basic settings:
  name = 'BeatGalactic', -- name of the game for your executable
  developer = 'raven Ruiz', -- dev name used in metadata of the file
  output = 'dist', -- output location for your game, defaults to $SAVE_DIRECTORY
  version = '1.0', -- 'version' of your game, used to name the folder in output
  love = '11.5', -- version of LÖVE to use, must match github releases
  ignore = {'dist'}, -- folders/files to ignore in your project
  icon = 'assets/img/icon.png', -- 256x256px PNG icon for game, will be converted for you
}