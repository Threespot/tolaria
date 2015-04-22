namespace :admin do

  desc "Add a new Tolaria Administrator from the command line"
  task :create => :environment do

    @administrator = Administrator.new

    STDOUT.puts "Enter the new Administrator’s credentials. All fields are required."

    STDOUT.print "Email address: "
    @administrator.email = STDIN.gets.chomp

    STDOUT.print "Full name: "
    @administrator.name = STDIN.gets.chomp

    STDOUT.print "Organization: "
    @administrator.organization = STDIN.gets.chomp

    if @administrator.save
      STDOUT.puts %{The administrator "#{@administrator.name}" <#{@administrator.email}> was successfully created.}
      exit(true)
    else
      STDOUT.puts "Your changes couldn’t be saved."
      @administrator.errors.full_messages.each do |message|
        STDOUT.puts message
      end
      exit(false)
    end

  end

end
