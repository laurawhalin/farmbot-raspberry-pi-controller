puts '[FarmBot Controller Menu]'
puts 'starting up'

require './lib/database/dbaccess.rb'
require './lib/database/filehandler.rb'

$db_write_sync = Mutex.new

#require './lib/controller.rb'
#require "./lib/hardware/ramps.rb"

#$bot_control    = Control.new
#$bot_hardware     = HardwareInterface.new

$shutdown    = 0

# just a little menu for testing

puts 'connecting to database'

$bot_dbaccess = DbAccess.new

$move_size      = 10
$command_delay  = 0
$pin_nr         = 13
$servo_angle    = 0

while $shutdown == 0 do

  #system('cls')
  system('clear')

  puts '[FarmBot Controller Menu]'
  puts ''
  puts 't - execute test'
  puts ''
  puts "move size = #{$move_size}"
  puts "command delay = #{$command_delay}"
  puts "pin nr = #{$pin_nr}"
  puts "servo angle = #{$servo_angle}"
  puts ''
  puts 'w - forward'
  puts 's - back'
  puts 'a - left'
  puts 'd - right'
  puts 'r - up'
  puts 'f - down'
  puts ''
  puts 'z - home z axis'
  puts 'x - home x axis'
  puts 'c - home y axis'
  puts ''
  puts 'y - dose water'
  puts 'u - set pin on'
  puts 'i - set pin off'
  puts 'k - move servo (pin 4,5)'
  puts ''
  puts 'q - step size'
  puts 'g - delay seconds'
  puts 'p - pin nr'
  puts 'j - servo angle (0-180)'
  puts ''
  print 'command > '
  input = gets
  puts ''

  case input.upcase[0]
#    when "P" # Quit
#      $shutdown = 1
#      puts 'Shutting down...'
    when "O" # Get status
      puts 'Not implemented yet. Press \'Enter\' key to continue.'
      gets
    when "J" # Set servo angle
      print 'Enter new servo angle > '
      servo_angle_temp = gets
      $servo_angle = servo_angle_temp.to_i if servo_angle_temp.to_i >= 0
    when "Q" # Set step size
      print 'Enter new step size > '
      move_size_temp = gets
      $move_size = move_size_temp.to_i if move_size_temp.to_i > 0
    when "G" # Set step delay (seconds)
      print 'Enter new delay in seconds > '
      command_delay_temp = gets
      $command_delay = command_delay_temp.to_i if command_delay_temp.to_i > 0
    when "P" # Set pin number
      print 'Enter new pin nr > '
      pin_nr_temp = gets
      $pin_nr = pin_nr_temp.to_i if pin_nr_temp.to_i > 0
    when "T" # Execute test file
      # read the file
      #TestFileHandler.readCommandFile

      $bot_dbaccess.create_new_command(Time.now + $command_delay,'menu')
      $bot_dbaccess.add_command_line('CALIBRATE X', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
      $bot_dbaccess.save_new_command

    when "K" # Move Servo
      $bot_dbaccess.create_new_command(Time.now + $command_delay,'menu')
      $bot_dbaccess.add_command_line('SERVO MOVE', 0, 0, 0, 0, 0, $pin_nr, $servo_angle, 0, 0, 0)
      $bot_dbaccess.save_new_command
    when "I" # Set Pin Off
      $bot_dbaccess.create_new_command(Time.now + $command_delay,'menu')
      $bot_dbaccess.add_command_line('PIN WRITE', 0, 0, 0, 0, 0, $pin_nr, 0, 0, 0, 0)
      $bot_dbaccess.save_new_command
    when "U" # Set Pin On
      $bot_dbaccess.create_new_command(Time.now + $command_delay,'menu')
      $bot_dbaccess.add_command_line('PIN WRITE', 0, 0, 0, 0, 0, $pin_nr, 1, 0, 0, 0)
      $bot_dbaccess.save_new_command
    when "Y" # Dose water
      $bot_dbaccess.create_new_command(Time.now + $command_delay,'menu')
      $bot_dbaccess.add_command_line('DOSE WATER', 0, 0, 0, 0, 15, 0,0,0,0,0)
      $bot_dbaccess.save_new_command
    when "Z" # Move to home
      $bot_dbaccess.create_new_command(Time.now + $command_delay,'menu')
      $bot_dbaccess.add_command_line('HOME Z', 0, 0, 0, 0, 0, 0,0,0,0,0)
      $bot_dbaccess.save_new_command
    when "X" # Move to home
      $bot_dbaccess.create_new_command(Time.now + $command_delay,'menu')
      $bot_dbaccess.add_command_line('HOME X', 0, 0, 0, 0, 0, 0,0,0,0,0)
      $bot_dbaccess.save_new_command
    when "C" # Move to home
      $bot_dbaccess.create_new_command(Time.now + $command_delay,'menu')
      $bot_dbaccess.add_command_line('HOME Y',0 ,0 ,-$move_size, 0, 0, 0,0,0,0,0)
      $bot_dbaccess.save_new_command
    when "W" # Move forward
      $bot_dbaccess.create_new_command(Time.now + $command_delay,'menu')
      $bot_dbaccess.add_command_line('MOVE RELATIVE',0,$move_size, 0, 0, 0, 0,0,0,0,0)
      $bot_dbaccess.save_new_command
    when "S" # Move back
      $bot_dbaccess.create_new_command(Time.now + $command_delay,'menu')
      $bot_dbaccess.add_command_line('MOVE RELATIVE',0,-$move_size, 0, 0, 0, 0,0,0,0,0)
      $bot_dbaccess.save_new_command
    when "A" # Move left
      $bot_dbaccess.create_new_command(Time.now + $command_delay,'menu')
      $bot_dbaccess.add_command_line('MOVE RELATIVE', -$move_size, 0, 0, 0, 0, 0,0,0,0,0)
      $bot_dbaccess.save_new_command
    when "D" # Move right
      $bot_dbaccess.create_new_command(Time.now + $command_delay,'menu')
      $bot_dbaccess.add_command_line('MOVE RELATIVE', $move_size, 0, 0, 0, 0, 0,0,0,0,0)
      $bot_dbaccess.save_new_command
    when "R" # Move up
      $bot_dbaccess.create_new_command(Time.now + $command_delay,'menu')
      $bot_dbaccess.add_command_line('MOVE RELATIVE', 0, 0, $move_size, 0, 0, 0,0,0,0,0)
      $bot_dbaccess.save_new_command
    when "F" # Move down
      $bot_dbaccess.create_new_command(Time.now + $command_delay,'menu')
      $bot_dbaccess.add_command_line("MOVE RELATIVE", 0, 0, -$move_size, 0, 0, 0,0,0,0,0)
      $bot_dbaccess.save_new_command
    end

end


