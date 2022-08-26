require "terminal-table"
require "json"
require_relative "boards"

class ClinBoards
  def initialize(filename)
    @filename = filename
    @boards = load_boards
  end

  def start
    welcome_message
    action = ""
    until action == "exit"
      print_table(list:@boards, title: "CLIn Boards", headings: ["ID", "Name", "Description", "List(#cards)"])
      
      action, id = menu(["create", "show ID", "update ID", "delete ID", "exit" ]) 

      case action
      when "create" then create_board(@boards)
      when "show" then puts "Show Board #{id}"  #update_playlist(id)
      when "update" then puts "Update Board #{id}"  #show_playlist(id)
      when "delete" then puts "Delete Board #{id}"  #delete_playlist(id)
      when "exit" then puts "Goodbye!"
      else
        puts "Invalid action"
      end
    end
    # puts action
  end

  private

  def create_board(boards)
    board_hash = board_form
    new_board = Boards.new(**board_hash)
    boards.push(new_board)
    File.write(@filename, boards.to_json)
  end

  def board_form
    print "Name: "
    name = gets.chomp
    print "Description: "
    description = gets.chomp
    { name: name, description: description }
  end

  def welcome_message
    puts "#" * 36
    puts "##{' ' * 6}Welcome to CLIn Boards#{' ' * 6}#"
    puts "#" * 36
  end

  def menu(options)
    puts "Board options: #{options.join(" | ")}"
    print "> "
    action, id = gets.chomp.split #=> "show 1" ~> ["show", "1"]
    [action, id.to_i] # return implicito ~> ["show", 1]
  end

  def print_table(list:, title:, headings:)
    table = Terminal::Table.new
    table.title = title
    table.headings = headings
    table.rows = list.map(&:details)
    puts table
  end

  def load_boards
    data = JSON.parse(File.read(@filename), symbolize_names: true)
    data.map { |board_hash| Boards.new(**board_hash) }
  end

end

# get the command-line arguments if neccesary
filename = ARGV.shift
ARGV.clear

filename = "store.json" if filename.nil?

app = ClinBoards.new(filename)
app.start
